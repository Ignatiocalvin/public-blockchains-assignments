require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");

const path = require("path");

let pathToDotEnv = path.join(__dirname, "..", "..", ".env");
require("dotenv").config({path : pathToDotEnv});

const MM_PRIVATE_KEY = process.env.METAMASK_PRIVATE_KEY;
const MM_PRIVATE_KEY_2 = process.env.METAMASK_PRIVATE_KEY_2;
const NOT_UNIMA_RPC_URL = process.env.NOT_UNIMA_URL_1;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    unima: {
      url: NOT_UNIMA_RPC_URL,
      accounts: [ MM_PRIVATE_KEY, MM_PRIVATE_KEY_2],
    }
  }
};