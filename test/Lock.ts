import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("Multisig", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployMultisig() {

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount, account1, account2] = await hre.ethers.getSigners();

    const Multisig = await hre.ethers.getContractFactory("Multisisg");
    const multisig = await Multisig.deploy();

    return { multisig, owner, otherAccount, account1, account2 };
  }

  describe("Deployment", function () {
    it("Should submit transaction correctly", async function () {
      const { multisig, owner, otherAccount, account1} = await loadFixture(deployMultisig);
      

      const amount = 20;
      const transaction = await multisig.submitTransaction(account1, )
    });
  });
});
