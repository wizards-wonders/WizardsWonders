pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

interface IWizardsWonders {
    enum RarityType {None, Boring, Fancy, SuperFancy}

    function safeTransferFrom(address from, address to, uint256 tokenId) external returns (bool);
    function safeMint(address to_, uint256 tokenId_, RarityType rarityUpgrade_) external;
}

contract LootBoxV1 is AccessControl, Pausable, ReentrancyGuard {
    using SafeMath for uint256;

    event SetNft(address indexed nft);
    event SetLootBoxPrice(uint256 indexed price);
    event BuyLootBox(address indexed user, uint256 num);

    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

    uint256 public supplyBoxNum;
    uint256 public buyBoxIndex;

    uint256 public lootBoxPrice;
    address public nft;

    // index -> tokenId
    mapping(uint256 => uint256) public lootBoxIndexTokenIdMapping;
    // tokenId -> rarity
    mapping(uint256 => IWizardsWonders.RarityType) public lootBoxTokenIdRarityMapping;

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "LootBox: NOT_OWNER_MEMBER");
        _;
    }

    modifier onlyCreator() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(CREATOR_ROLE, msg.sender), "LootBox: NOT_CREATOR_MEMBER");
        _;
    }

    constructor(address _nft, uint256 _price) public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleRule();
        nft = _nft;
        lootBoxPrice = _price;
    }

    function remainingLootBoxNum() public view returns(uint256) {
        return supplyBoxNum.sub(buyBoxIndex);
    }

    function createLootBox(uint256[] memory _tokenIds, IWizardsWonders.RarityType[] memory _rarities) public onlyCreator {
        require(_tokenIds.length == _rarities.length, "LootBox: LENGTH_MISMATCH");
        for (uint256 i=0; i<_tokenIds.length; i++) {
            supplyBoxNum += 1;
            uint256 tokenId = _tokenIds[i];
            IWizardsWonders.RarityType rarity = _rarities[i];
            lootBoxIndexTokenIdMapping[supplyBoxNum] = tokenId;
            lootBoxTokenIdRarityMapping[tokenId] = rarity;
        }
    }

    function buyLootBox(uint256 _num) public nonReentrant payable {
        uint256 price = lootBoxPrice.mul(_num);
        require(msg.value >= price, "LootBox: NOT_ENOUGH_VALUE");
        require(buyBoxIndex + _num <= supplyBoxNum, "LootBox: NOT_ENOUGH_LOOT_BOX");
        // pay loot box
        address(this).transfer(price);

        for (uint256 i=0; i<_num; i++) {
            buyBoxIndex += 1;
            uint256 tokenId = lootBoxIndexTokenIdMapping[buyBoxIndex];
            IWizardsWonders.RarityType rarity = lootBoxTokenIdRarityMapping[tokenId];
            IWizardsWonders(nft).safeMint(msg.sender, tokenId, rarity);
        }

        uint256 remainingValue = msg.value.sub(price);
        if (remainingValue > uint256(0)) {
            msg.sender.transfer(remainingValue);
        }
        emit BuyLootBox(msg.sender, _num);
    }

    function setLootBoxPrice(uint256 _price) public onlyOwner {
        lootBoxPrice = _price;
        emit SetLootBoxPrice(_price);
    }

    function setNft(address _nft) public onlyOwner {
        nft = _nft;
        emit SetNft(_nft);
    }

    function withdrawal() external onlyOwner {
        uint256 value = address(this).balance;
        (bool success,) = msg.sender.call{value:value}(new bytes(0));
        require(success, 'LootBox: WITHDRAW_FAILED');
    }

    function _setRoleRule() internal {
        _setRoleAdmin(CREATOR_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(PAUSE_ROLE, DEFAULT_ADMIN_ROLE);
    }

    receive() external payable {}
}
