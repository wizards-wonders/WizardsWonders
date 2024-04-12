pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./TransferHelper.sol";
import "./interface/IWizardsWonders.sol";



contract LootBox is AccessControl, Pausable, ReentrancyGuard {
    using SafeMath for uint256;

    bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
    event SetNft(address indexed nft);
    event SetBootBoxList(LootBoxListS _lootBoxList);
    event BuyLootBox(address indexed user, uint256 num);

    struct LootBoxListS {
        string[] tokenHashList;
        uint256 hexoreBonus;
    }

    //enum carType {None, Commander, Wonder, ActionCard,Unit}

    bytes32 public constant SETTING_ROLE = keccak256("SETTER_ROLE");
    bytes32 public constant PAUSE_ROLE = keccak256("PAUSE_ROLE");

    IWizardsWonders.carType public carType;
    uint256 public buyBoxIndex; // alread buy lootbox amount
    address public wizardsNFT;
    address public feeTo;
    uint256 public price;
    IERC20 public payToken;
    IERC20 public HexoreToken;
    LootBoxListS[] public  lootBoxList;

    // index -> tokenId
    mapping(uint256 => uint256) public lootBoxIndexTokenIdMapping;

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "LootBox: NOT_OWNER_MEMBER");
        _;
    }
    modifier onlySetter() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(SETTING_ROLE, msg.sender), "LootBoxSetting: NOT_SETTER");
        _;
    }

    constructor(
        address _nft, 
        IERC20 _payToken,
        IERC20 _hexoreToken,
        IWizardsWonders.carType _carType) public {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleRule();

        carType = _carType;
        wizardsNFT = _nft;
        payToken = _payToken;
        HexoreToken = _hexoreToken;
    }

    function setFeeTo(address _feeTo) public onlySetter{
        feeTo = _feeTo;
    }

    function setPrice(uint256 _price) public onlySetter{
        price = _price;
    }

    function buyLootBox() public{
        // check index
        uint256 curIndex = buyBoxIndex;
        require(curIndex < lootBoxList.length-1,"LootBox: not lootbox to sale");
        LootBoxListS memory lbs = lootBoxList[curIndex];
        // get pay
        _pay(price);

        // send nft
        uint256 nftlen = lbs.tokenHashList.length;
        require(HexoreToken.balanceOf(address(this)) >= lbs.hexoreBonus,"LootBox: not enough Bounes");
        if(nftlen >0){
            for(uint256 i=0; i<nftlen-1;i++){
                require(IWizardsWonders(wizardsNFT).ownerOf(lbs.tokenHashList[i]) == address(this),"LootBox: not nft owner");
                IWizardsWonders(wizardsNFT).transferFrom(address(this),msg.sender,lbs.tokenHashList[i]);
            }
        }

        // send bounes
        if(lbs.hexoreBonus>0) _payBounes(msg.sender,lbs.hexoreBonus);

        // sendBootbox
        buyBoxIndex++;
    }
    
    function setBootBoxList(
        LootBoxListS[] memory _lootLists
    ) public onlySetter{
        uint256 len = _lootLists.length;
        for(uint256 i=0; i<len; i++){
            lootBoxList.push(_lootLists[i]);
        }
    }

    function changeBootBoxListInfo(
        uint256 _index,
        LootBoxListS memory _lootList
    ) public onlySetter{
        lootBoxList[_index] = _lootList;
    }

    

    function setNft(address _nft) public onlyOwner {
        wizardsNFT = _nft;
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
        _setRoleAdmin(PAUSE_ROLE, DEFAULT_ADMIN_ROLE);
    }

    function _payBounes(address _user,uint256 _amount) internal{
        TransferHelper.safeTransfer(address(HexoreToken), _user, _amount);
    }

    function _pay(uint256 _amount) internal {
        if (address(payToken) == address(1)) {
            require(msg.value >= _amount, "LootBox: NOT_ENOUGH_VALUE");

            uint256 remainingValue = msg.value.sub(_amount);
            if (remainingValue > uint256(0)) {
                msg.sender.transfer(remainingValue);
            }
        } else {
            require(feeTo != address(0),"LootBox: feeTo is zero");
            TransferHelper.safeTransferFrom(address(payToken), msg.sender, feeTo, _amount);
        }
    }

    // for 721
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external pure returns (bytes4){
        return MAGIC_ON_ERC721_RECEIVED;
    }
}
