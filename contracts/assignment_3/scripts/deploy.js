// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
require('dotenv').config();
const hre = require("hardhat");

async function main() {
  const [signer1, signer2] = await ethers.getSigners();
  console.log(signer1.address);
  const ERC20_contract = await hre.ethers.getContractFactory("CensorableToken");
  const erc20_contract = await ERC20_contract.deploy("IgnaCoin", "IGC", 10000, signer1.address);
  // await erc20_contract.deployed();
  console.log(
    `ERC20 with 10000 IgnaCoin total amount deployed to: ${erc20_contract.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
