const {
    loadFixture, impersonateAccount,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Token contract", function () {
    let swapper;
    let owner;
    let addr1;
    let addr2;
    let addrs;
    let impersonatedSigner;
    let wethContract;
    let usdtContract;
    let zyberRouterContract;
    let woofiRouterContract;
    const kyberRouter = "0xF9c2b5746c946EF883ab2660BbbB1f10A5bdeAb4";
    const zyberRouter = "0x16e71B13fE6079B4312063F7E81F76d165Ad32Ad";
    const woofiRouter = "0x9aEd3A8896A85FE9a8CAc52C9B402D092B629a30";
    const ITJRouter = "0xb4315e873dBcf96Ffd0acd8EA43f689D8c20fB30";
    const weth = "0x82af49447d8a07e3bd95bd0d56f35241523fbab1";
    const usdt = "0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9";
    const erc20abi = require("../artifacts/contracts/interface/IERC20.sol/IERC20.json").abi;
    const zyberRouterAbi = require("../artifacts/contracts/interface/IZyberRouter.sol/IZyberRouter.json").abi;


    beforeEach(async function () {
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        impersonatedSigner = await ethers.getImpersonatedSigner("0x0df5dfd95966753f01cb80e76dc20ea958238c46")
        wethContract = new ethers.Contract(weth, erc20abi, impersonatedSigner);
        usdtContract = new ethers.Contract(usdt, erc20abi, impersonatedSigner);
        zyberRouterContract = new ethers.Contract(zyberRouter, zyberRouterAbi);
        await network.provider.send("hardhat_setBalance", [
            impersonatedSigner.address,
            "0x3635C9ADC5DEA00000"
        ]);
    });
    // it("Should return the right name", async function () {

    //     console.log(await wethContract.name());
    //     console.log(await usdtContract.name());
    //     const result = await zyberRouterContract.connect(impersonatedSigner).getAmountsOut(ethers.parseUnits("1", "ether"), [weth, usdt]);
    //     const minAmount = Number(result[1]);
    //     const timestamp = Math.floor(Date.now() / 1000);
    //     const deadline = timestamp + 60 * 60;
    //     console.log(timestamp, deadline);
    //     console.log("balance before", await usdtContract.balanceOf(impersonatedSigner.address));
    //     await zyberRouterContract.connect(impersonatedSigner).swapExactETHForTokens(minAmount, [weth, usdt], impersonatedSigner.address, deadline, { value: ethers.parseUnits("4", "ether") });
    //     console.log("balance after", await usdtContract.balanceOf(impersonatedSigner.address));


    // });

    it.only("should swap the amount in Kyberswap Elastic", async () => {
        const swapperContract = await ethers.deployContract("swapper", [kyberRouter, zyberRouter, woofiRouter, ITJRouter, weth, usdt]);
        await swapperContract.connect(impersonatedSigner)._swapKyberSwap(ethers.parseUnits("4", "ether"), { value: ethers.parseUnits("4", "ether") });
    })

    it("should swap the amount in zyberswap", async () => {
        const swapperContract = await ethers.deployContract("swapper", [kyberRouter, zyberRouter, woofiRouter, ITJRouter, weth, usdt]);
        await swapperContract.connect(impersonatedSigner)._swapZyberSwap(ethers.parseUnits("4", "ether"), { value: ethers.parseUnits("4", "ether") });
    })
    it("should swap the amount in WoofiV2", async () => {
        const swapperContract = await ethers.deployContract("swapper", [kyberRouter, zyberRouter, woofiRouter, ITJRouter, weth, usdt]);
        await swapperContract.connect(impersonatedSigner)._swapWoofiV2(ethers.parseUnits("4", "ether"), { value: ethers.parseUnits("4", "ether") });
    });
    it("should swap the amount in WoofiV2", async () => {
        const swapperContract = await ethers.deployContract("swapper", [zyberRouter, woofiRouter, ITJRouter, weth, usdt]);
        await swapperContract.connect(impersonatedSigner)._swapTraderJoeV2_1(ethers.parseUnits("4", "ether"), { value: ethers.parseUnits("4", "ether") });
    });

});