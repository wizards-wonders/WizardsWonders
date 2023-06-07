require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");
require("hardhat-deploy");
require("hardhat-deploy-ethers");

const env = require("./constants");

module.exports = {
  solidity: "0.6.12",
  networks: {
    hardhat: {
      blockGasLimit: 80000000000,
      saveDeployments: true,
      accounts: {
        mnemonic: "test test test test test test test test test test test junk",
        accountsBalance: "1000000000000000000000000000"
      }
    },
    abey: {
      url: "https://rpc.abeychain.com",
      chainId: 179,
      accounts: [env.PRIVATE_KEY]
    }
  },
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false,
  },
  gasReporter: {
    currency: 'USD',
    gasPrice: 1
  },
  mocha: {
    timeout: 400000
  }
};
