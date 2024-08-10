import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: `https://eth-holesky.g.alchemy.com/v2/${process.env.ALCHEMY_SECRET_KEY}`,
      accounts: [process.env.WALLET_SECRET_KEY as string],
    },
  },
  etherscan: {
    apiKey: process.env.ETHER_SCAN_SECRET,
  },
};

export default config;
