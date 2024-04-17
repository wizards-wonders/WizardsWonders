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

  const sleep = () => new Promise( (res, rej) => setTimeout(res, 5000));
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
  const HexoreAddress="0x0C872aAE79431615d2A3cc923aa39D2Eb379392B"
  const LootBox1Addr = "0xC3d8d029Ff2ab0b9503571b5C466A90EE146EF55"
  const LootBox2Addr = "0xc15D6cF6d4B6Cf691629956054fc9E81daCA7Df0"
  const LootBox3Addr = "0xe84908C503FBcfe0707705271c79e7575059D466"
  const LootBox4Addr = "0x32F6B45D3811daAada608aFb0132DDAf0972408D"
  const LootBox5Addr = "0xB975dF12FcaD82506Db57A40a3B0646Ac0544EFF"

  
  const owner = "0x0C69BF377905395af43E3f455C098e66f12bA345"
  const getUSdt = "0x1fAddAe4a9bD8E2AD29B38e30CCd1983b7d666a1"

  const priceVaule1 = "1000000000000000000"
  const LootBoxFeeTo1  = "0x0C69BF377905395af43E3f455C098e66f12bA345"

  const usdtTest = await hre.ethers.getContractAt("USDTTest", usdtAddr);
  const HexoreC = await hre.ethers.getContractAt("Hexore", HexoreAddress);
  const WizardsWondersNFT = await hre.ethers.getContractAt("WizardsWonders", WizardsWondersAddr);
  const LootBox1C = await hre.ethers.getContractAt("LootBox", LootBox1Addr);

  
  try{
    tx = await usdtTest.approve(LootBox1Addr,"10000000000000000000");
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 2.1 usdtTest approve (:----");
    }
    console.log("2.1 WizardsWondersNFT safeMint");
    
        

try{
            tx = await LootBox1C.buyLootBox();
            while(tx.blockNumber==null) {
                sleep();
                tx =  await hre.ethers.provider.getTransaction(tx.hash);
            }
            }catch (error) {
                console.log("---error 2.3 LootBox1C buyLootBox (:----");
            }
            console.log("2.3 LootBox1C buyLootBox");

            
    

        
    

    
    
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
