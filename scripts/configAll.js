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

  const usdtAddr = ""
  const LootBox1Addr = ""
  const LootBox2Addr = ""
  const LootBox3Addr = ""
  const LootBox4Addr = ""
  const LootBox5Addr = ""

  const getUSdt = "0x1fAddAe4a9bD8E2AD29B38e30CCd1983b7d666a1"

  const usdtTest = await hre.ethers.getContractAt("USDTTest", usdtAddr);

  try{
    tx = await usdtTest.mint(getUSdt,"1000000000000000000000000");
    while(tx.blockNumber==null) {
        sleep();
        tx =  await hre.ethers.provider.getTransaction(tx.hash);
    }
    }catch (error) {
        console.log("---error 1.1 usdtTest miner .addMinter(:----");
    }
    console.log("1.1 usdtTest mint");
    
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
