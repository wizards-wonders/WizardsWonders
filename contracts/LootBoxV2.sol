pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./TransferHelper.sol";

interface IWizardsWonders {
    enum RarityType {None, Boring, Fancy, SuperFancy}

    function safeTransferFrom(address from, address to, uint256 tokenId) external returns (bool);
    function safeMint(address to_, uint256 tokenId_) external;
}

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract LootBox is AccessControl, Pausable, ReentrancyGuard {
    using SafeMath for uint256;

    event SetNft(address indexed nft);
    event BuyLootBox(address indexed user, uint256 num);

    struct PriceInterval {
        uint256 intervalEnd;
        uint256 price;
    }

    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

    uint256 public supplyBoxNum;
    uint256 public buyBoxIndex;

    PriceInterval[] public priceInterval;
    address public nft;
    IERC20 public payToken;

    // index -> tokenId
    mapping(uint256 => uint256) public lootBoxIndexTokenIdMapping;

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "LootBox: NOT_OWNER_MEMBER");
        _;
    }

    modifier onlyCreator() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(CREATOR_ROLE, msg.sender), "LootBox: NOT_CREATOR_MEMBER");
        _;
    }

    constructor(address _nft, IERC20 _payToken, PriceInterval[] memory _priceInterval) public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleRule();

        nft = _nft;
        payToken = _payToken;
        _setPriceInterval(_priceInterval);
    }

    function remainingLootBoxNum() public view returns(uint256) {
        return supplyBoxNum.sub(buyBoxIndex);
    }

    function createLootBox(uint256[] memory _tokenIds) public onlyCreator {
        for (uint256 i=0; i<_tokenIds.length; i++) {
            supplyBoxNum += 1;
            uint256 tokenId = _tokenIds[i];
            lootBoxIndexTokenIdMapping[supplyBoxNum] = tokenId;
        }
    }

    function calcLootBoxPrice(uint256 _buyBoxIndex, uint256 _amount) public view returns(uint256) {
        uint256 total;
        uint256 startIndex = priceInterval.length-1;
        uint256 endIndex = priceInterval.length-1;
        for (uint256 i=priceInterval.length-1; i>=0; i--) {
            if (_buyBoxIndex <= priceInterval[i].intervalEnd) {
                startIndex = i;
            }
            if (_buyBoxIndex.add(_amount) <= priceInterval[i].intervalEnd) {
                endIndex = i;
            }
            if (i==0) {
                break;
            }
        }
        if (startIndex == endIndex) {
            total = _amount.mul(priceInterval[startIndex].price).div(1e18);
            return total;
        }
        for (uint256 i=startIndex; i<=endIndex; i++) {
            if (i == startIndex) {
                total = total.add(
                    priceInterval[i].intervalEnd.sub(buyBoxIndex).mul(priceInterval[i].price).div(1e18)
                );
            } else if (i == endIndex) {
                total = total.add(
                    buyBoxIndex.add(_amount).sub(priceInterval[i-1].intervalEnd).mul(priceInterval[i].price).div(1e18)
                );
            } else {
                total = total.add(
                    priceInterval[i].intervalEnd.sub(priceInterval[i-1].intervalEnd).mul(priceInterval[i].price).div(1e18)
                );
            }
        }
        return total;
    }

    function buyLootBox(uint256 _num) public nonReentrant payable {
        uint256 total = calcLootBoxPrice(buyBoxIndex, _num);
        require(buyBoxIndex.add(_num) <= supplyBoxNum, "LootBox: NOT_ENOUGH_LOOT_BOX");

        _pay(total);

        for (uint256 i=0; i<_num; i++) {
            buyBoxIndex += 1;
            uint256 tokenId = lootBoxIndexTokenIdMapping[buyBoxIndex];
            IWizardsWonders(nft).safeMint(msg.sender, tokenId);
        }

        emit BuyLootBox(msg.sender, _num);
    }

    function getPriceIntervalLength() public view returns(uint256) {
        return priceInterval.length;
    }

    function setPriceInterval(PriceInterval[] memory _priceInterval) public onlyOwner {
        _setPriceInterval(_priceInterval);
    }

    function setNft(address _nft) public onlyOwner {
        nft = _nft;
        emit SetNft(_nft);
    }

    function setPayToken(IERC20 _payToken) public onlyOwner {
        payToken = _payToken;
    }

    function withdrawal() public onlyOwner {
        if (address(payToken) == address(1)) {
            uint256 value = address(this).balance;
            (bool success,) = msg.sender.call{value:value}(new bytes(0));
            require(success, 'LootBox: WITHDRAW_ABEY_FAILED');
        } else {
            uint256 payTokenBalance = payToken.balanceOf(address(this));
            TransferHelper.safeTransfer(address(payToken), msg.sender, payTokenBalance);
        }
    }

    function _setRoleRule() internal {
        _setRoleAdmin(CREATOR_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(PAUSE_ROLE, DEFAULT_ADMIN_ROLE);
    }

    function _setPriceInterval(PriceInterval[] memory _priceInterval) internal {
        for(uint256 i=0; i<_priceInterval.length; i++){
            priceInterval.push(_priceInterval[i]);
        }
    }

    function _pay(uint256 _amount) internal {
        if (address(payToken) == address(1)) {
            require(msg.value >= _amount, "LootBox: NOT_ENOUGH_VALUE");

            uint256 remainingValue = msg.value.sub(_amount);
            if (remainingValue > uint256(0)) {
                msg.sender.transfer(remainingValue);
            }
        } else {
            TransferHelper.safeTransferFrom(address(payToken), msg.sender, address(this), _amount);
        }
    }
}
