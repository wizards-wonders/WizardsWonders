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

  const sleep = () => new Promise( (res, rej) => setTimeout(res, 15000));
  console.log("---start")

  const baseURI = "http://test/";

  // Glostone
  const GlostoneContract = await hre.ethers.getContractFactory("Glostone");
  const GlostoneC= await GlostoneContract.deploy();
  await GlostoneC.deployed();
  console.log("[INFO] Glostone deployed to: \033[1;35m%s\033[0m", GlostoneC.address);
  sleep();

  // Hexore
  const HexoreContract = await hre.ethers.getContractFactory("Hexore");
  const HexoreC= await HexoreContract.deploy();
  const GlostoneCTx = await GlostoneC.deployed();
  console.log("[INFO] Hexore deployed to: \033[1;35m%s\033[0m", HexoreC.address);
  sleep();
  //await GlostoneCTx.wait();

  // USDTTest
  const USDTTestContract = await hre.ethers.getContractFactory("USDTTest");
  const USDTTestC= await USDTTestContract.deploy("10000000000000000000000");
  await USDTTestC.deployed();
  console.log("[INFO] USDTTest deployed to: \033[1;35m%s\033[0m", USDTTestC.address);
  sleep();
  //const testUSDT = "0x43B0AA2206136346dfd2f4F2338CD2A273d94205"


    
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
