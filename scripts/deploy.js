const func = async ({ deployments, network }) => {
  const { deploy, get } = deployments;
  const [ deployer ] = await ethers.getSigners();

  const owner = deployer.address;

  if (!network.live || network.config.chainId === 179) {
    console.log("-- deploy start! --");

    console.log("|deployer      |", deployer.address);
    console.log("|owner         |", owner);

    let glo = await deploy('Glostone', {
      from: deployer.address,
      args: []
    }).then(s => ethers.getContractAt(s.abi, s.address, deployer));
    console.log("deploy Glostone -----------------> Address: ", glo.address);

    let xore = await deploy('Hexore', {
      from: deployer.address,
      args: []
    }).then(s => ethers.getContractAt(s.abi, s.address, deployer));
    console.log("deploy Hexore -----------------> Address: ", xore.address);

    let wiz = await deploy('WizardsWonders', {
      from: deployer.address,
      args: ["http://test.com/"]
    }).then(s => ethers.getContractAt(s.abi, s.address, deployer));
    console.log("deploy WizardsWonders -----------------> Address: ", wiz.address);

    let ico_config = [
      {"intervalEnd": "50000000000000000000000000", "price": "10000000000000000"},
      {"intervalEnd": "75000000000000000000000000", "price": "100000000000000000"},
      {"intervalEnd": "100000000000000000000000000", "price": "500000000000000000"}
    ]
    let ico = await deploy('ICO', {
      from: deployer.address,
      args: [glo.address, "0x0000000000000000000000000000000000000001", ico_config]
    }).then(s => ethers.getContractAt(s.abi, s.address, deployer));
    console.log("deploy ICO -----------------> Address: ", ico.address);

    let transfer_in_amount = "100000000000000000000000000";
    let tx = await glo.approve(ico.address, transfer_in_amount);
    console.log("glo approve ico -----------------> TxHash: ", tx.hash);

    tx = await ico.transferInToken(transfer_in_amount);
    console.log("glo transfer in ico 100000000000000000000000000 -----------------> TxHash: ", tx.hash);

    let loot_box_config = [
      {"intervalEnd": "7500", "price": "119000000000000000000"},
      {"intervalEnd": "12500", "price": "149000000000000000000"},
      {"intervalEnd": "15000", "price": "199000000000000000000"},
      {"intervalEnd": "15180", "price": "400000000000000000000"}
    ]
    let lootBox = await deploy('LootBoxV2', {
      from: deployer.address,
      args: [wiz.address, "0x0000000000000000000000000000000000000001", loot_box_config]
    }).then(s => ethers.getContractAt(s.abi, s.address, deployer));
    console.log("deploy LootBox -----------------> Address: ", lootBox.address);
  }
}

func.id = 'deploy';
module.exports = func;