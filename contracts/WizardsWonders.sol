pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract WizardsWonders is ERC721, AccessControl {

    event UpdateCardRarity(
        uint256 indexed tokenId, 
        RarityType oldRarity, 
        RarityType newRarity,
        string  tokenHash,
        string _Series,
        string _Type,
        string _Rarity,
        string _Faction,
        uint256 _PointValue,
        bool _op
        );

    event TransferFrom(
        uint256 indexed tokenId, 
        address from, 
        address to,
        string  tokenHash,
        string _Series,
        string _Type,
        string _Rarity,
        string _Faction,
        uint256 _PointValue,
        bool _op
    );


    
    
    
    enum RarityType {None, Boring, Fancy, SuperFancy}

    struct tokenAttribS{
        string Series;
        string Type;
        string Rarity;
        string Faction;
        uint256 PointValue;
        bool OP;
    }

    mapping(uint256 => string ) public tokenIDToTokenHash;
    mapping(string => uint256) public tokenHashToTokenID;
    mapping(string => bool) public tokenHashMintFlage;
    mapping(uint256 => tokenAttribS) public tokenAttrib;
    // tokenId -> RarityType
    mapping(uint256 => RarityType) public tokenIdRarity;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADE_ROLE = keccak256("UPGRADE_ROLE");

    modifier onlyOwner() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "WizardsWonders: NOT_OWNER_MEMBER");
        _;
    }

    modifier onlyMinter() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(MINTER_ROLE, msg.sender), "WizardsWonders: NOT_MINTER_MEMBER");
        _;
    }

    modifier onlyUpgrade() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender) || hasRole(UPGRADE_ROLE, msg.sender), "WizardsWonders: NOT_UPGRADE_MEMBER");
        _;
    }

    

   // constructor(string memory baseURI_) ERC721("W&W Trading Card", "WWTC") public {
    constructor(string memory baseURI_) ERC721("W&W Trading Card Test", "WWTCT") public {
        _setBaseURI(baseURI_);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleRule();
    }

    function safeMint(
        address to_, 
        string memory  tokenHash_,
        string memory Series_,
        string memory Type_,
        string memory Rarity_,
        string memory Faction_,
        uint256  PointValue_,
        bool OP_
        ) public onlyMinter {
        
        mint(
            to_,
            tokenHash_,
            Series_,
            Type_,
            Rarity_,
            Faction_,
            PointValue_,
            OP_
        );
    }

    function batchSafeMint(
        address[] memory tos_, 
        string[] memory  tokenHashs_,
        string[] memory Seriess_,
        string[] memory Types_,
        string[] memory Raritys_,
        string[] memory Factions_,
        uint256[] memory PointValues_,
        bool[] memory OPs_
    ) public onlyMinter{
        uint256 len = tos_.length-1;
        for(uint256 i=0; i<=len; i++){
            mint(
                tos_[i],
                tokenHashs_[i],
                Seriess_[i],
                Types_[i],
                Raritys_[i],
                Factions_[i],
                PointValues_[i],
                OPs_[i]
        );
        }
    }

    function mint(
        address to_, 
        string memory  tokenHash_,
        string memory Series_,
        string memory Type_,
        string memory Rarity_,
        string memory Faction_,
        uint256  PointValue_,
        bool OP_
        ) internal  {
        require(!tokenHashMintFlage[tokenHash_],"tokenhash not mint");
        uint256 tokenId_ = ERC721.totalSupply().add(1);
        _safeMint(to_, tokenId_);

        tokenHashMintFlage[tokenHash_] = true;
        tokenHashToTokenID[tokenHash_] = tokenId_;
        tokenIDToTokenHash[tokenId_] = tokenHash_;

        tokenAttrib[tokenId_] = tokenAttribS({
            Series : Series_,
            Type : Type_,
            Rarity : Rarity_,
            Faction : Faction_,
            PointValue : PointValue_,
            OP : OP_
        });

        tokenIdRarity[tokenId_] = RarityType.None;
    }

    function changeCardRarity(uint256 tokenId_, RarityType rarityUpgrade_) public onlyUpgrade {
        require(_exists(tokenId_), "WizardsWonders: CURRENT_TOKEN_NOT_EXIST");
        RarityType oldRarity = tokenIdRarity[tokenId_];
        tokenIdRarity[tokenId_] = rarityUpgrade_;


        emit UpdateCardRarity(
            tokenId_, 
            oldRarity, 
            rarityUpgrade_,
            tokenIDToTokenHash[tokenId_],
            tokenAttrib[tokenId_].Series ,
            tokenAttrib[tokenId_].Type ,
            tokenAttrib[tokenId_].Rarity ,
            tokenAttrib[tokenId_].Faction ,
            tokenAttrib[tokenId_].PointValue,
            tokenAttrib[tokenId_].OP
            );
    }

    function changeCardRarity(string memory tokenHash_, RarityType rarityUpgrade_) public onlyUpgrade {
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];
        require(_exists(tokenId_), "WizardsWonders: CURRENT_TOKEN_NOT_EXIST");
        
        RarityType oldRarity = tokenIdRarity[tokenId_];
        tokenIdRarity[tokenId_] = rarityUpgrade_;

        emit UpdateCardRarity(
            tokenId_, 
            oldRarity, 
            rarityUpgrade_,
            tokenHash_,
            tokenAttrib[tokenId_].Series ,
            tokenAttrib[tokenId_].Type ,
            tokenAttrib[tokenId_].Rarity ,
            tokenAttrib[tokenId_].Faction ,
            tokenAttrib[tokenId_].PointValue,
            tokenAttrib[tokenId_].OP
            );
    }

    function setBaseURI(string memory baseURI_) public onlyOwner {
        _setBaseURI(baseURI_);
    }

    function tokenURI(uint256 tokenId_) public override view returns(string memory){
        string memory uri = super.baseURI();
        string memory typeF = "/";
        string memory tokenHash = tokenIDToTokenHash[tokenId_];
        return string(abi.encodePacked(uri, tokenHash,typeF,"metadata"));
    }
    function tokenURI(string memory tokenHash_) public  view returns(string memory){
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];
        return tokenURI(tokenId_);
    }


    function transferFrom(address from_, address to_, string memory tokenHash_) public   {
        require(tokenHashMintFlage[tokenHash_],"tokenhash not mint");
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];
        ERC721.transferFrom(from_, to_, tokenId_);

        emit TransferFrom(
            tokenId_, 
            from_, 
            to_,
            tokenHash_,
            tokenAttrib[tokenId_].Series ,
            tokenAttrib[tokenId_].Type ,
            tokenAttrib[tokenId_].Rarity ,
            tokenAttrib[tokenId_].Faction ,
            tokenAttrib[tokenId_].PointValue,
            tokenAttrib[tokenId_].OP
        );

    }


    function safeTransferFrom(address from_, address to_, string memory tokenHash_) public   {
        require(tokenHashMintFlage[tokenHash_],"tokenhash not mint");
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];
        ERC721.safeTransferFrom(from_, to_, tokenId_, "");
        emit TransferFrom(
            tokenId_, 
            from_, 
            to_,
            tokenHash_,
            tokenAttrib[tokenId_].Series ,
            tokenAttrib[tokenId_].Type ,
            tokenAttrib[tokenId_].Rarity ,
            tokenAttrib[tokenId_].Faction ,
            tokenAttrib[tokenId_].PointValue,
            tokenAttrib[tokenId_].OP
        );

    }

    function approve(address to_,string memory tokenHash_) public {
        require(tokenHashMintFlage[tokenHash_],"tokenhash not mint");
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];
        ERC721.approve(to_,tokenId_);
    }

    function _setRoleRule() internal {
        _setRoleAdmin(MINTER_ROLE, DEFAULT_ADMIN_ROLE);
        _setRoleAdmin(UPGRADE_ROLE, DEFAULT_ADMIN_ROLE);
    }

    function getTokenIdRarity(string memory tokenHash_) public view returns(RarityType){
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];

        return tokenIdRarity[tokenId_];
    }

    function getTokenAttrib(string memory tokenHash_) public view returns(
        string memory Series,
        string memory Type,
        string memory Rarity,
        string memory Faction,
        uint256  PointValue,
        bool  OP){
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];
        Series = tokenAttrib[tokenId_].Series;
        Type =tokenAttrib[tokenId_].Type;
        Rarity = tokenAttrib[tokenId_].Rarity;
        Faction = tokenAttrib[tokenId_].Faction;
        PointValue = tokenAttrib[tokenId_].PointValue;
        OP = tokenAttrib[tokenId_].OP;
    }

    function ownerOf(string memory tokenHash_) public view returns(address){
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];
        return ERC721.ownerOf(tokenId_);
    }

    function getApproved(string memory tokenHash_) public view returns(address){
        uint256 tokenId_ = tokenHashToTokenID[tokenHash_];
        return ERC721.getApproved(tokenId_);
    }
}
