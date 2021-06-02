const hre = require("hardhat")

async function main() {
    const [deployer] = await ethers.getSigners()

    console.log(
        "Deploying contracts with the account:",
        deployer.address
    )

    console.log("Account balance:", (await deployer.getBalance()).toString())

    const DbiliaToken = await ethers.getContractFactory("DbiliaToken");

    const dbiliaToken = await DbiliaToken.deploy("Dbilia", "DT", deployer.address)

    console.log("DbiliaToken address:", dbiliaToken.address)
    await dbiliaToken.deployed()
    await hre.run("verify:verify", {
        address: dbiliaToken.address,
        constructorArguments: [
            "Dbilia",
            "DT",
            deployer.address
        ],
      })
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
