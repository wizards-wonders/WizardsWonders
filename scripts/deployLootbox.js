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

  const baseURI = "http://test/";

  

  // USDTTest
  /*const USDTTestContract = await hre.ethers.getContractFactory("USDTTest");
  const USDTTestC= await USDTTestContract.deploy("10000000000000000000000");
  await USDTTestC.deployed();
  console.log("[INFO] USDTTest deployed to: \033[1;35m%s\033[0m", USDTTestC.address);
  sleep();*/
  const testUSDT = "0x43B0AA2206136346dfd2f4F2338CD2A273d94205"
  const GlostoneCAddr = "0xe412387B5DDc03c0549e3B1A06bF74b0d01EFe3c"
  const HexoreCAddr = "0x0C872aAE79431615d2A3cc923aa39D2Eb379392B"
  const WizardsAddr = "0x51F8452d8D80Fc93a04C1391d56aD5872B815B0D"
  

  

  //LootBox
  //enum carType {None, CoreSet, Commander, Wonder, ActionCard, Unit}
  const LootBoxContract = await hre.ethers.getContractFactory("LootBox");
  const LootBoxC1= await LootBoxContract.deploy(WizardsAddr,testUSDT,HexoreCAddr,1);
  await LootBoxC1.deployed();
  console.log("[INFO] LootBox CoreSet deployed to: \033[1;35m%s\033[0m", LootBoxC1.address);
  sleep();

  const LootBoxC2= await LootBoxContract.deploy(WizardsAddr,testUSDT,HexoreCAddr,2);
  await LootBoxC2.deployed();
  console.log("[INFO] LootBox Commander deployed to: \033[1;35m%s\033[0m", LootBoxC2.address);
  sleep();


  const LootBoxC3= await LootBoxContract.deploy(WizardsAddr,testUSDT,HexoreCAddr,3);
  await LootBoxC3.deployed();
  console.log("[INFO] LootBox Wonder deployed to: \033[1;35m%s\033[0m", LootBoxC3.address);
  sleep();


  const LootBoxC4= await LootBoxContract.deploy(WizardsAddr,testUSDT,HexoreCAddr,4);
  await LootBoxC4.deployed();
  console.log("[INFO] LootBox ActionCard deployed to: \033[1;35m%s\033[0m", LootBoxC4.address);
  sleep();

  const LootBoxC5= await LootBoxContract.deploy(WizardsAddr,testUSDT,HexoreCAddr,5);
  await LootBoxC5.deployed();
  console.log("[INFO] LootBox Unit deployed to: \033[1;35m%s\033[0m", LootBoxC5.address);
  sleep();

    
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
