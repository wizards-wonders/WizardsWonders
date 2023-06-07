

# deploy info ABEYMainet testV2 update url and event
deploy Glostone -----------------> Address:  0x5FbDB2315678afecb367f032d93F642f64180aa3
deploy Hexore -----------------> Address:  0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
deploy WizardsWonders -----------------> Address:  0x903963ff172ec33A194b4174D47824dA063CEEAa
deploy ICO -----------------> Address:  0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9

# deploy info ABEY Mainnet testV1
deploy Glostone -----------------> Address:  0x5FbDB2315678afecb367f032d93F642f64180aa3
deploy Hexore -----------------> Address:  0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
deploy WizardsWonders -----------------> Address:  0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
deploy ICO -----------------> Address:  0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9



# Wizards-contracts

## Glostone.sol

* The standard ERC20 contract has an upper limit of issuance, the upper limit is 1e10 * 1e18, and the owner authority can control the suspension of transfer.

    // Suspend the contract, limit the owner to call
    function pause() external;

    // Cancel the pause, only the owner can call
    function unpause() external;

## Hexore.sol

* A standard ERC20 contract with unlimited circulation and owner, miner, and burner permissions. The burner and owner permissions can control mint, and the burner and owner permissions can control burn.

    // Mint a certain amount of Hexore to the user, the to address is the receiver, the amount is the minted amount, limited to miner and owner calls
    function mint(address to, uint256 amount) external;

    // Burn a certain amount of Hexore for the user, the to address is the burning user, the amount is the burning amount, and the burner and owner calls are limited
    function burn(address to, uint256 amount) external;



# WizardsWonders.sol

* Standard ERC721 contract. There are owner, miner, and upgrade permissions. The mint and owner permissions can mint Nft to the user, and the upgrade and owner permissions can update the nft attribute.

    // cast nft, limited to miner and owner calls
    function safeMint(address to_, uint256 tokenId_) external;
    
    // Modify the rarity of nft, tokenId_ is the tokenId to be modified, rarityUpgrade_ is the rarity to be updated, limited to upgrade and owner calls
    function changeCardRarity(uint256 tokenId_, RarityType rarityUpgrade_) external;

    // Modify the rarity of nft, tokenHash_ is the token's Hash to be modified, rarityUpgrade_ is the rarity to be updated, limited to upgrade and owner calls
    function changeCardRarity(string memory tokenHash_, RarityType rarityUpgrade_) public onlyUpgrade 


    // Modify the base URI, limit the owner to call
    function setBaseURI(string memory baseURI_) external;

    // get token URI use tokenHash
    function tokenURI(string memory tokenHash_) public  view returns(string memory)

    // tranfserFrom use tokenHash
    function transferFrom(address from_, address to_, string memory tokenHash_) public

    // safeTransferFrom use tokenHash
    function safeTransferFrom(address from_, address to_, string memory tokenHash_) public 

    // safeMint must input token attributes
    function safeMint(
        address to_, 
        string memory  tokenHash_,
        string memory Series_,
        string memory Type_,
        string memory Rarity_,
        string memory Faction_,
        uint256  PointValue_,
        bool OP_
        ) 

    // get tokenAttrib use tokenhash
    function getTokenAttrib(string memory tokenHash_) public view returns(
        string memory Series,
        string memory Type,
        string memory Rarity,
        string memory Faction,
        uint256  PointValue,
        bool  OP)

    //ownerOf get token Owner use tokenhash
    function ownerOf(string memory tokenHash_) public view returns(address)

    //getApproved use tokenhash
    function getApproved(string memory tokenHash_) public view returns(address)

    // use token ID to get Tokenhash
    function tokenIDToTokenHash(uint256 ) public view returns(string)

    // use token Hash to get tokenID
    function tokenHashToTokenID(string ) public view returns(uint256)
    

# ICO.sol

public fundraising contract. Users can subscribe for Glostone at a tiered price. With owner permission, it is used to set the payment currency, set the price ladder, and transfer to Glostone to ICO.

    // price configuration
    struct PriceInterval {
        uint256 intervalEnd; // price range end quantity
        uint256 price; // price in this range
    }
    
    // Return the total subscribed tokens of ICO
    function totalSupply() external view returns(uint256);

    // return the number of tokens subscribed
    funciton saleTokenAmount() external view returns(uint256);

    // Query price ladder details, index is the index
    function priceInterval(uint256 index) external view returns(PriceInterval memory); 

    // subscribeable token address
    function token() external view returns(address);

    // The token address used for payment, address(1) is abey
    function payToken() external view returns(address);

    // Return the remaining purchasable tokens
    function tokensAvailable() external view returns(uint256);

    // Transfer token, _amount is the transfer amount, only the owner can call
    function transferInToken(uint256 _amount) external; 

    // Subscription token, _amount is the subscription amount
    function buyTokens(uint256 _amount) external;

    // Calculate the price to be paid for the subscription, _saleTokenAmount is the subscribed quantity, _amount is the new subscription quantity, and the return value is the price to be paid for the subscription
    function calcTokenPrice(uint256 _saleTokenAmount, uint256 _amount) external view returns(uint256);

    // Returns the number of price ladder configurations
    function getPriceIntervalLength() public view returns(uint256);

    // Reset the price ladder configuration, only the owner can call
    function setPriceInterval(PriceInterval[] memory _priceInterval) external;

    // End the sale, limit the owner to call, and return the remaining tokens and tokens obtained by subscription to the caller
    function endSale() public;

    // Take out the subscription assets, limited to the owner to call
    function withdrawal() external;

    // Set the payment currency, only the owner can call
    function setPayToken(IERC20 _payToken) external;


## LootBox.sol

* Blind box contract, users can pay a fee to buy a blind box, which contains WizardsWonders NFT. With owner and creator permissions, creator permissions can create blind boxes.

    // price configuration
    struct PriceInterval {
        uint256 intervalEnd; // price range end quantity
        uint256 price;  // price in this range
    }
    
    // total number of blind boxes
    function supplyBoxNum() external view returns(uint256);

    // number of blind boxes sold
    function buyBoxIndex() external view returns(uint256);

    // number of remaining blind boxes
    function remainingLootBoxNum() external view returns(uint256)

    // Query price ladder details, index is the index
    function priceInterval(uint256 index) external view returns(PriceInterval memory); 

    // nft address in blind box
    function nft() external view returns(address);

    // The token address used for payment, address(1) is abey
    function payToken() external view returns(address);

    // Create blind boxes in batches, the parameter is the corresponding NFT tokenId, limited to creator creation
    function createLootBox(uint256[] memory _tokenIds) external;

    // Calculate the price of the blind box, _buyBoxIndex is the number of blind boxes sold, _amount is the number of new blind boxes purchased this time, and the return value is the price to be paid for the purchase
    function calcLootBoxPrice(uint256 _buyBoxIndex, uint256 _amount) public view returns(uint256);

    // buy blind box, _num is the purchase quantity
    function buyLootBox(uint256 _num);

    // Returns the number of price ladder configurations
    function getPriceIntervalLength() public view returns(uint256);

    // Reset the price ladder configuration, only the owner can call
    function setPriceInterval(PriceInterval[] memory _priceInterval) external;

    // Set the nft address, only the owner can call
    function setNft(address _nft) external;

    // Set the payment currency, only the owner can call
    function setPayToken(IERC20 _payToken) external;

    // Take out the subscription assets, limited to the owner to call
    function withdrawal() external;