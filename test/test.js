const { expect } = require("chai");
const { get, execute, read, getArtifact, deploy } = deployments;

describe("Test", () => {
  let ico;
  let glo;

  const fund20000000 = ethers.utils.parseUnits('20000000');
  const fund25000000 = ethers.utils.parseUnits('25000000');
  const fund30000000 = ethers.utils.parseUnits('30000000');
  const fund40000000 = ethers.utils.parseUnits('40000000');
  const fund50000000 = ethers.utils.parseUnits('50000000');
  const fund60000000 = ethers.utils.parseUnits('60000000');
  const fund75000000 = ethers.utils.parseUnits('75000000');
  const fund100000000 = ethers.utils.parseUnits('100000000');

  const fund200000 = ethers.utils.parseUnits('200000');
  const fund300000 = ethers.utils.parseUnits('300000');
  const fund1300000 = ethers.utils.parseUnits('1300000');
  const fund2500000 = ethers.utils.parseUnits('2500000');
  const fund3000000 = ethers.utils.parseUnits('3000000');
  const fund5100000 = ethers.utils.parseUnits('5100000');
  const fund15100000 = ethers.utils.parseUnits('15100000');
  const fund15500000 = ethers.utils.parseUnits('15500000');


  beforeEach(async () => {
    await deployments.fixture();

    const [ deployer ] = await ethers.getSigners();

    const ICO = await get('ICO');
    ico = await ethers.getContractAt(ICO.abi, ICO.address, deployer);

    const GLO = await get('Glostone');
    glo = await ethers.getContractAt(GLO.abi, GLO.address, deployer);
  });

  it('Check the ICO token ok', async () => {
    let total_supply = await ico.totalSupply();
    expect(total_supply.toString()).to.equal(fund100000000);

    let tokens_available = await ico.tokensAvailable();
    expect(tokens_available.toString()).to.equal(fund100000000);

    let sale_token_amount = await ico.saleTokenAmount();
    expect(sale_token_amount.toString()).to.equal("0");
  });

  it('Check the ICO config ok', async () => {
    let config_len = await ico.getPriceIntervalLength();
    expect(config_len.toString()).to.equal("3");

    console.log("check ico config");
    for (let i=0; i<config_len.toString(); i++){
      let config = await ico.priceInterval(i);
      console.log(config.intervalEnd.toString(), config.price.toString());
    }
    console.log("----------------");

  });

  it('Check the ICO price ok', async () => {
    // s     e
    // +-----------+-----+-----+
    let total0 = await ico.calcTokenPrice("0", fund20000000);
    expect(total0.toString()).to.equal(fund200000);

    //    s     e
    // +-----------+-----+-----+
    let total1 = await ico.calcTokenPrice(fund20000000, fund20000000);
    expect(total1.toString()).to.equal(fund200000);

    //    s        e
    // +-----------+-----+-----+
    let total2 = await ico.calcTokenPrice(fund20000000, fund30000000);
    expect(total2.toString()).to.equal(fund300000);

    //    s           e
    // +-----------+-----+-----+
    let total3 = await ico.calcTokenPrice(fund20000000, fund40000000);
    expect(total3.toString()).to.equal(fund1300000);

    //             s     e
    // +-----------+-----+-----+
    let total4 = await ico.calcTokenPrice(fund50000000, fund25000000);
    expect(total4.toString()).to.equal(fund2500000);

    // s                 e
    // +-----------+-----+-----+
    let total5 = await ico.calcTokenPrice("0", fund75000000);
    expect(total5.toString()).to.equal(fund3000000);

    //           s         e
    // +-----------+-----+-----+
    let total6 = await ico.calcTokenPrice(fund40000000, fund40000000);
    expect(total6.toString()).to.equal(fund5100000);

    //           s             e
    // +-----------+-----+-----+
    let total7 = await ico.calcTokenPrice(fund40000000, fund60000000);
    expect(total7.toString()).to.equal(fund15100000);

    // s                       e
    // +-----------+-----+-----+
    let total8 = await ico.calcTokenPrice("0", fund100000000);
    expect(total8.toString()).to.equal(fund15500000);

    //                         s     e
    // +-----------+-----+-----+
    let total9 = await ico.calcTokenPrice(fund100000000, fund100000000);
    expect(total9.toString()).to.equal(fund50000000);
  });

  it('Check the ICO buy token ok', async () => {
    const [ user1, user2 ] = await ethers.getUnnamedSigners();

    let glo_balance = await glo.balanceOf(user2.address);
    expect(glo_balance.toString()).to.equal("0");

    let abey_balance = await user2.getBalance();
    console.log("user abey balance 1: ", abey_balance.toString()); // 1000000000

    await ico.connect(user2).buyTokens(
        fund20000000,
        { value: fund200000 }
    );

    glo_balance = await glo.balanceOf(user2.address);
    expect(glo_balance.toString()).to.equal(fund20000000);

    abey_balance = await user2.getBalance();
    console.log("user abey balance 2: ", abey_balance.toString()); // 999800000

    await ico.connect(user2).buyTokens(
        fund40000000,
        { value: fund1300000 }
    );

    abey_balance = await user2.getBalance();
    console.log("user abey balance 3: ", abey_balance.toString()); // 998500000

    let total_supply = await ico.totalSupply();
    console.log("total supply: ", total_supply.toString());

    let available = await ico.tokensAvailable();
    console.log("available: ", available.toString());

    let balanceBefore = await user1.getBalance();
    console.log("admin abey balance before: ", balanceBefore.toString()); // 1000000000

    let tokenBefore = await glo.balanceOf(user1.address);
    console.log("admin token balance before: ", tokenBefore.toString()); // 9900000000

    await ico.connect(user1).endSale();

    console.log("endSale!!!")

    available = await ico.tokensAvailable();
    console.log("available after: ", available.toString());

    let balanceAfter = await user1.getBalance();
    console.log("admin abey balance after: ", balanceAfter.toString()); // 1001500000

    let tokenAfter = await glo.balanceOf(user1.address); // 9940000000
    console.log("admin balance after: ", tokenAfter.toString());
  });

});