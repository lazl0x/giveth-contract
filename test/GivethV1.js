const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Giveth Contract", () => {
  
  let GivethFactory;
  let owner; 
  let addr1;
  let addr2; 
  let addrs;
  let giveth;

  beforeEach(async () => {
    
    GivethFactory = await ethers.getContractFactory("GivethV1");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    giveth = await GivethFactory.deploy();


  });

  describe("Deployment", () => {
  
    it("Should set the right deployment owner", async () => {
      expect(await giveth.owner()).to.equal(owner.address);
    });

  });

  describe("Transications", () => {
  
    it("Should allow Giveaway creations", async () => {
      //giveth.changeEtherBalances([addr1.address, addr2.address] = [25, 25]);
      giveth.transfer(giveth.owner(), 25).createGiveaway(ethers.utils.formatBytes32String("Test Note1"), 1);
      //await giveth
        //      .connect(addr1)
              //.transfer(10)
          //    .createGiveaway(ethers.utils.formatBytes32String("Test Note2"), 1);
      //await giveth
      //        .connect(addr2)
              //.transfer(25)
      //        .createGiveaway(ethers.utils.formatBytes32String("Test Note3"), 1);

      expect(giveth.giveaways.length == 1);
    });

  });

});
