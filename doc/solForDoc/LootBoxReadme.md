# There are two ways to implement LootBox:
## 1. The contract is only responsible for collecting fees
### The contract provides the following interfaces:
* function
*  setPrice(IWizardsWonders _carType,address _feeToken, uint256 _price);
*  _setupRole(bytes32 role, address account);
*  buyLootBox(IWizardsWonders _carType,uint256 _amount); // amount is the number of LootBox  to be purchased
* event 
*  BuyLootBox(address _user,IWizardsWonders _carType,uint256 _amount,uint256 _payAmount);

## 2. The contract is responsible for collecting fees and minting WizardsWonders NFT, and giving other rewards.
###  contract LootBox
* function
*  buyLootBox(IWizardsWonders _carType,uint256 _amount);
*  setSettingAddr(address _settingAddr);
*  _setupRole(bytes32 role, address account);
* event 
*  BuyLootBox(address _user,IWizardsWonders _carType,uint256 _amount,uint256 _payAmount);


###  contract LootBoxSetting
* function 
* setPrice(IWizardsWonders _carType, address _feeToken,uint256 _price);
* setTokenList(IWizardsWonders _carType,tokenInfo [] tokenList);
<!--
setTokenList must give the token info 
@ hexosAmount_  how many heoxs amount can get when user buy one lootbox 
struct tokenInfo{
        uint256 _tokenID
        string   tokenHash_;
        string  Series_;
        string  Rarity_;
        string  Faction_;
        uint256  PointValue_;
        bool OP_;
        uint256 hexosAmount_;
    }
-->
* 