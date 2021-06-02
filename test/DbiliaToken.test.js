const { expect } = require("chai");

const bigNum = num=>(num + '0'.repeat(18))

describe("DbiliaToken contract", function () {

    before(async function () {
        [
            this.owner, 
            this.alice,
            this.dbilia,
            ...addrs
        ] = await ethers.getSigners();
        this.DbiliaToken = await ethers.getContractFactory("DbiliaToken");
        this.dbiliaToken = await this.DbiliaToken.deploy("Dbilia", "DT", this.dbilia.address);
    });

    it("Only dbilia address should call mintWithUSD", async function() {
        try {
            await this.dbiliaToken.mintWithUSD(this.dbilia.address, 1, 1, "");
        } catch (err) {
            expect(err.message).to.equal("VM Exception while processing transaction: revert Dbilia: not dbilia");
        }
    });

    it("should mint with usd successfully", async function() {
        await this.dbiliaToken.connect(this.dbilia).mintWithUSD(this.dbilia.address, 1, 1, "tokena");
        expect((await this.dbiliaToken.balanceOf(this.dbilia.address)).toString()).to.equal("1");
        expect(await this.dbiliaToken.ownerOf(1)).to.be.equal(this.dbilia.address);
        expect(await this.dbiliaToken.tokenURI(1)).to.be.equal("tokena");
        expect(await this.dbiliaToken.editions(1)).to.be.equal(1);
    });

    it("user should be able to call mintWithETH successfully", async function() {
        try {
            await this.dbiliaToken.connect(this.alice).mintWithETH(1, 1, "", {value: bigNum(1)});
        } catch (err) {
            expect(err.message).to.equal("VM Exception while processing transaction: revert Dbilia: CardId exists");
        }

        await this.dbiliaToken.connect(this.alice).mintWithETH(2, 1, "tokenb", {value: bigNum(1)});
        expect((await this.dbiliaToken.balanceOf(this.alice.address)).toString()).to.equal("1");
        console.log(await this.dbiliaToken.ownerOf(2));
        expect(await this.dbiliaToken.ownerOf(2)).to.be.equal(this.alice.address);
        expect(await this.dbiliaToken.tokenURI(2)).to.be.equal("tokenb");
        expect(await this.dbiliaToken.editions(2)).to.be.equal(1);
    });
});