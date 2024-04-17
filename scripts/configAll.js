// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  const accounts = await ethers.provider.listAccounts();
  const account = accounts[0];

  const sleep = () => new Promise( (res, rej) => setTimeout(res, 30000));
  console.log("---start")

/*
Aaron/Dylan address
0x49dd878fac5b2D042D161db9FD0F7200068b004B
0xb37548183D876e04D1Fdd338a1277b9567E9B438
0x267cAEbDAF946c965a57403D59eb35359FEf444b
0xCD163B62D11b4BF1a74C6d0b39f3007C6A6B55a7
*/
  
  const usdtAddr = "0x43B0AA2206136346dfd2f4F2338CD2A273d94205"
  const WizardsWondersAddr = "0x51F8452d8D80Fc93a04C1391d56aD5872B815B0D"
  const LootBox1Addr = "0xC241f76e8B3DEf17452fEc1aBfc07736a9103Eb9"
  const LootBox2Addr = "0x6b4b87E5437C5DcA97E9EE80D4090ccDb96Bfb91"
  const LootBox3Addr = "0xae1d4cDAB9aaFDc8cB84790e4dE7947b153Dd56B"
  const LootBox4Addr = "0xbA4dCa66E3932B9387831e62Ec1627D98a15A381"
  const LootBox5Addr = "0x6577855c25A5ef1eEd339eCF09bbCCA95E67c798"
  const GlostoneAddr = "0xe412387B5DDc03c0549e3B1A06bF74b0d01EFe3c"
  const ICOAddr =  "0x3370a9E833E38Ab9Ffe1b89F4Ca04cC935d25307"
  const HexoreAddr = "0x0C872aAE79431615d2A3cc923aa39D2Eb379392B"
  
  const owner = "0x0C69BF377905395af43E3f455C098e66f12bA345"
  const getUSdt = "0x1fAddAe4a9bD8E2AD29B38e30CCd1983b7d666a1"

  const usdtTest = await hre.ethers.getContractAt("USDTTest", usdtAddr);
  const WizardsWondersNFT = await hre.ethers.getContractAt("WizardsWonders", WizardsWondersAddr);
  const GlostoneC = await hre.ethers.getContractAt("Glostone", GlostoneAddr);
  const ICOAC = await hre.ethers.getContractAt("ICO", ICOAddr);
  const HexoreC = await hre.ethers.getContractAt("Hexore", HexoreAddr);
  const LootBox1C = await hre.ethers.getContractAt("LootBox", LootBox1Addr);
  const LootBox2C = await hre.ethers.getContractAt("LootBox", LootBox2Addr);
  const LootBox3C = await hre.ethers.getContractAt("LootBox", LootBox3Addr);
  const LootBox4C = await hre.ethers.getContractAt("LootBox", LootBox4Addr);
  const LootBox5C = await hre.ethers.getContractAt("LootBox", LootBox5Addr);

  try{
    tx = await usdtTest.mint(getUSdt,"1000000000000000000000000");
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 1.1 usdtTest miner (:----");
    }
    console.log("1.1 usdtTest mint");

    try{
        tx = await usdtTest.mint(owner,"1000000000000000000000000");
        while(tx.blockNumber==null) {
            sleep();
            tx =  await hre.ethers.provider.getTransaction(tx.hash);
        }
        }catch (error) {
            console.log("---error 1.1 usdtTest miner (:----");
        }
        console.log("1.2 usdtTest mint");
    


        /**
         * Permissions
Hexore
DEFAULT_ADMIN_ROLE  0xf06a5bbe0a35c48D5e840F0Aa56672772775149B
MINTER_ROLE             0x49dd878fac5b2D042D161db9FD0F7200068b004B
BURNER_ROLE             0x18e88f21918f867254A83eD3df5d1BB04a88dd73

Glo
DEFAULT_ADMIN_ROLE  0xf06a5bbe0a35c48D5e840F0Aa56672772775149B

WizardsWonders
DEFAULT_ADMIN_ROLE  0xf06a5bbe0a35c48D5e840F0Aa56672772775149B
MINTER_ROLE             0x49dd878fac5b2D042D161db9FD0F7200068b004B
UPGRADE_ROLE            TBD - this will be done via contract when we get to this stage

ICO
DEFAULT_ADMIN_ROLE  0xf06a5bbe0a35c48D5e840F0Aa56672772775149B
PAUSE_ROLE              0xf06a5bbe0a35c48D5e840F0Aa56672772775149B

LootBox
DEFAULT_ADMIN_ROLE  0xf06a5bbe0a35c48D5e840F0Aa56672772775149B
PAUSE_ROLE              0xf06a5bbe0a35c48D5e840F0Aa56672772775149B
CREATOR_ROLE            0x49dd878fac5b2D042D161db9FD0F7200068b004B
SETTER_ROLE             0x18e88f21918f867254A83eD3df5d1BB04a88dd73
         */
    

// 1 Hexore
const BURNER_ROLE =  "0x3c11d16cbaffd01df69ce1c404f6340ee057498f5f00246190ea54220576a848"
const MINTER_ROLE =  "0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6"
const BURNER_ROLE_Addr =  "0x18e88f21918f867254A83eD3df5d1BB04a88dd73"
const MINTER_ROLE_Addr =  "0x49dd878fac5b2D042D161db9FD0F7200068b004B"
try{
    tx = await HexoreC.grantRole(BURNER_ROLE,BURNER_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 1 BURNER_ROLE:----");
    }
    console.log("1 BURNER_ROLE");

try{
    tx = await HexoreC.grantRole(MINTER_ROLE,MINTER_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 2 MINTER_ROLE:----");
    }
    console.log("2 MINTER_ROLE");


// WizardsWonders
const WMINTER_ROLE = "0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6"
const WMINTER_ROLE_Addr = "0x49dd878fac5b2D042D161db9FD0F7200068b004B"
try{
    tx = await WizardsWondersNFT.grantRole(WMINTER_ROLE,WMINTER_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 3 WMINTER_ROLE:----");
    }
    console.log("3 WMINTER_ROLE");

//ICO
const IPAUSE_ROLE = "0x139c2898040ef16910dc9f44dc697df79363da767d8bc92f2e310312b816e46d"
const IPAUSE_ROLE_Addr = "0xf06a5bbe0a35c48D5e840F0Aa56672772775149B"
try{
    tx = await ICOAC.grantRole(IPAUSE_ROLE,IPAUSE_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 4 IPAUSE_ROLE:----");
    }
    console.log("4 IPAUSE_ROLE");

//LootBox
const SETTER_ROLE = "0x61c92169ef077349011ff0b1383c894d86c5f0b41d986366b58a6cf31e93beda"
const  PAUSE_ROLE = "0x139c2898040ef16910dc9f44dc697df79363da767d8bc92f2e310312b816e46d"
const SETTER_ROLE_Addr = "0x18e88f21918f867254A83eD3df5d1BB04a88dd73"
const PAUSE_ROLE_Addr = "0xf06a5bbe0a35c48D5e840F0Aa56672772775149B"

//LootBox1C
try{
    tx = await LootBox1C.grantRole(SETTER_ROLE,SETTER_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.1 SETTER_ROLE:----");
    }
    console.log("5.1 SETTER_ROLE");

try{
    tx = await LootBox1C.grantRole(PAUSE_ROLE,PAUSE_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.1 PAUSE_ROLE:----");
    }
    console.log("5.1 PAUSE_ROLE");

    //LootBox2C
try{
    tx = await LootBox2C.grantRole(SETTER_ROLE,SETTER_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.2 SETTER_ROLE:----");
    }
    console.log("5.2 SETTER_ROLE");

try{
    tx = await LootBox2C.grantRole(PAUSE_ROLE,PAUSE_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.2 PAUSE_ROLE:----");
    }
    console.log("5.2 PAUSE_ROLE");

    //LootBox3C
try{
    tx = await LootBox3C.grantRole(SETTER_ROLE,SETTER_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.3 SETTER_ROLE:----");
    }
    console.log("5.3 SETTER_ROLE");

try{
    tx = await LootBox3C.grantRole(PAUSE_ROLE,PAUSE_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.3 PAUSE_ROLE:----");
    }
    console.log("5.3 PAUSE_ROLE");

    //LootBox4C

try{
    tx = await LootBox4C.grantRole(SETTER_ROLE,SETTER_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.4 SETTER_ROLE:----");
    }
    console.log("5.4 SETTER_ROLE");

try{
    tx = await LootBox4C.grantRole(PAUSE_ROLE,PAUSE_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.4 PAUSE_ROLE:----");
    }
    console.log("5.4 PAUSE_ROLE");

    //LootBox5C

try{
    tx = await LootBox5C.grantRole(SETTER_ROLE,SETTER_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.5 SETTER_ROLE:----");
    }
    console.log("5.5 SETTER_ROLE");

try{
    tx = await LootBox5C.grantRole(PAUSE_ROLE,PAUSE_ROLE_Addr);
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 5.5 PAUSE_ROLE:----");
    }
    console.log("5.5 PAUSE_ROLE");



    
    
// npx hardhat run scripts/deploy_all.js --network bsc_testnet
    console.log("-----Finish--------");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});
