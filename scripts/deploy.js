// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

const kyberRouter = "0xF9c2b5746c946EF883ab2660BbbB1f10A5bdeAb4";
const zyberRouter = "0x16e71B13fE6079B4312063F7E81F76d165Ad32Ad";
const woofiRouter = "0x9aEd3A8896A85FE9a8CAc52C9B402D092B629a30";
const TJRouter = "0xb4315e873dBcf96Ffd0acd8EA43f689D8c20fB30";
const weth = "0x82af49447d8a07e3bd95bd0d56f35241523fbab1";
const usdt = "0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9";

async function main() {


  const swapper = await ethers.deployContract("swapper", [kyberRouter, zyberRouter, woofiRouter, TJRouter]);

  await swapper.waitForDeployment();

  console.log("swapper deployed to:", swapper.address);
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
