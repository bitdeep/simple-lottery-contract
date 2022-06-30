const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Main", function () {
  it("all", async function () {
    const [ dev ] = await ethers.getSigners();
    const HermesToken = await ethers.getContractFactory("HermesToken");
    const IrisToken = await ethers.getContractFactory("IrisToken");
    const HermesBar = await ethers.getContractFactory("HermesBar");
    const Main = await ethers.getContractFactory("Main");

    const hermes = await HermesToken.deploy();
    await hermes.deployed();

    const iris = await IrisToken.deploy();
    await iris.deployed();

    const xhrms = await HermesBar.deploy(hermes.address);
    await xhrms.deployed();

    const main = await Main.deploy(iris.address, xhrms.address);
    await main.deployed();

    await hermes.mint(dev.address, 20);
    await hermes.approve(xhrms.address, 20);
    await xhrms.enter(20);
    await xhrms.transfer(main.address, 20);

    await iris.mint(dev.address, 2);
    await iris.approve(main.address, 20);
    await main.convert(2);
    // await main.convert(1);

  });
});
