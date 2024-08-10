require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");
require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/f-OgAmP4OcuK3e1qUVkeldR4FcKggkHN`,
      accounts: [process.env.WALLET_SECRET_KEY],
      gasPrice: 20000000000, // 20 Gwei
      gas: 5000000, // Gas limit
    },
  },
  etherscan: {
    apiKey: process.env.ETHER_SCAN_SECRET,
  },
};
