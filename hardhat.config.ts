import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_URL || "",
      accounts:
        process.env.RINKEBY_PRIVATE_KEY !== undefined ? [process.env.RINKEBY_PRIVATE_KEY] : [],
    },
  }
};

export default config;
