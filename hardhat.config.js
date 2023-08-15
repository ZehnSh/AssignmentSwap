require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.19"
      },
      {
        version: "0.6.12"

      }
    ],
  },
  networks: {
    hardhat: {
      forking: {
        enabled: true,
        url: `https://arb-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      },
      chainId: 42161,
    }
  }
};
