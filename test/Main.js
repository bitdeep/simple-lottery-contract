const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("Main", function () {
    it("test", async function () {
        const [a, b, c, d, e, f, g, h, i, j, l] = await ethers.getSigners();
        const Main = await ethers.getContractFactory("Main");
        const main = await Main.deploy();
        await main.deployed();
        await test();
        await test();
        await test();
        await test();
        await test();
        await test();
        await test();
        await test();
        await test();
        await test();
        async function test(){
            const cost = '1000000000000000000';
            await main.connect(a).buy(1, {value: cost});
            await main.connect(b).buy(1, {value: cost});
            await main.connect(c).buy(1, {value: cost});
            await main.connect(d).buy(1, {value: cost});
            await main.connect(e).buy(1, {value: cost});
            await main.connect(f).buy(1, {value: cost});
            await main.connect(g).buy(1, {value: cost});
            await main.connect(g).buy(1, {value: cost});
            await main.connect(i).buy(1, {value: cost});
            await main.connect(j).buy(1, {value: cost});
            await main.connect(l).buy(1, {value: cost});
            const lastWinnerAddress = await main.lastWinnerAddress();
            const lastWinnerTicket = (await main.lastWinnerTicket()).toString();

            console.log(lastWinnerTicket, lastWinnerAddress);
        }

    });

});
