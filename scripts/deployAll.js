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
  await GlostoneC.deployed();
  console.log("[INFO] Hexore deployed to: \033[1;35m%s\033[0m", HexoreC.address);
  sleep();

  // USDTTest
  const USDTTestContract = await hre.ethers.getContractFactory("USDTTest");
  const USDTTestC= await USDTTestContract.deploy();
  await USDTTestC.deployed();
  console.log("[INFO] USDTTest deployed to: \033[1;35m%s\033[0m", USDTTestC.address);
  sleep();

  //ICO
  let ico_config = [
    {"intervalEnd": "50000000000000000000000000", "price": "10000000000000000"},
    {"intervalEnd": "75000000000000000000000000", "price": "100000000000000000"},
    {"intervalEnd": "100000000000000000000000000", "price": "500000000000000000"}
  ] 
  const ICOContract = await hre.ethers.getContractFactory("ICO");
  const ICOC= await ICOContract.deploy(GlostoneC.address,USDTTestC.address,ico_config);
  await ICOC.deployed();
  console.log("[INFO] ICO deployed to: \033[1;35m%s\033[0m", ICOC.address);
  sleep();

  //WizardsWonders
  const WizardsContract = await hre.ethers.getContractFactory("WizardsWonders");
  const WizardsC= await WizardsContract.deploy(baseURI);
  await WizardsC.deployed();
  console.log("[INFO] WizardsWonders deployed to: \033[1;35m%s\033[0m", WizardsC.address);
  sleep();

  //LootBox
  //enum carType {None, CoreSet, Commander, Wonder, ActionCard, Unit}
  const LootBoxContract = await hre.ethers.getContractFactory("WizardsWonders");
  const LootBoxC1= await WizardsContract.deploy(WizardsC.address,USDTTestC.address,HexoreC.address,1);
  await LootBoxC1.deployed();
  console.log("[INFO] LootBox CoreSet deployed to: \033[1;35m%s\033[0m", LootBoxC1.address);
  sleep();

  const LootBoxC2= await WizardsContract.deploy(WizardsC.address,USDTTestC.address,HexoreC.address,2);
  await LootBoxC2.deployed();
  console.log("[INFO] LootBox Commander deployed to: \033[1;35m%s\033[0m", LootBoxC2.address);
  sleep();


  const LootBoxC3= await WizardsContract.deploy(WizardsC.address,USDTTestC.address,HexoreC.address,3);
  await LootBoxC3.deployed();
  console.log("[INFO] LootBox Wonder deployed to: \033[1;35m%s\033[0m", LootBoxC3.address);
  sleep();


  const LootBoxC4= await WizardsContract.deploy(WizardsC.address,USDTTestC.address,HexoreC.address,4);
  await LootBoxC4.deployed();
  console.log("[INFO] LootBox ActionCard deployed to: \033[1;35m%s\033[0m", LootBoxC4.address);
  sleep();

  const LootBoxC5= await WizardsContract.deploy(WizardsC.address,USDTTestC.address,HexoreC.address,5);
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
