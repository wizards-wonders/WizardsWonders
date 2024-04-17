
<!--
Please fill in the corresponding permission address according to different contracts.
if your want to add Role pls add to contracts
-->

# Hexore  
* MINTER_ROLE
<!--MINTER_ROLE
Minter role is Hexore contract role who can mint Hexore,
function mint(address to, uint256 amount) public onlyMinter 
 -->
* BURNER_ROLE
<!--BURNER_ROLE
burner role is Hexore contract role who can burn Hexore,
function burn(address to, uint256 amount) public onlyBurner
 -->
# WizardsWonders
* MINTER_ROLE
<!--BURNER_ROLE
burner role is WizardsWonders contract role who can Mint WizardsWonders NFT Car,
function safeMint(
        address to_, 
        string memory  tokenHash_,
        string memory Series_,
        string memory Type_,
        string memory Rarity_,
        string memory Faction_,
        uint256  PointValue_,
        bool OP_
        ) public onlyMinter
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

 -->
* UPGRADE_ROLE
<!--UPGRADE_ROLE
Upgrade role is WizardsWonders contract role who can upgrade WizardsWonders NFT Raity ,
function changeCardRarity(uint256 tokenId_, RarityType rarityUpgrade_) public onlyUpgrade
 -->


# ICO
* PAUSE_ROLE
<!--PAUSE_ROLE
PAUSE role is ICO contract role who can Pause All contract,
 -->

# LootBox
* PAUSE_ROLE
<!--PAUSE_ROLE
PAUSE role is LootBox contract role who can pause or unpause All contract,
whenNotPaused
 -->
* SETTER_ROLE
<!--PAUSE_ROLE
PAUSE role is LootBox contract role who can pause or unpause All contract,
function setFeeTo(address _feeTo) public onlySetter
function setPrice(uint256 _price) public onlySetter
function setBootBoxList(
        LootBoxListS[] memory _lootLists
    ) public onlySetter
function changeBootBoxListInfo(
        uint256 _index,
        LootBoxListS memory _lootList
    ) public onlySetter
 -->

