pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
//import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Giveth {
    
    struct Giveaway {
        uint giveawayId;
        address creator;
        uint reward; 
        uint expires; 
        address[] players;
        bool execute;
    }
    
    Giveaway[] public giveaways;

    uint nonce = 0;

    mapping (uint => Giveaway) public IdToGiveaway;
    
    function createGiveaway(uint _expires) public payable {
        
      address[] memory players;
      giveaways.push(Giveaway(nonce, msg.sender, msg.value, _expires, players, true));

      IdToGiveaway[nonce] = giveaways[giveaways.length - 1];

      nonce++;

    }

    function joinGiveaway(uint _id) public { 

      require(msg.sender != IdToGiveaway[_id].creator, "Creator is an invalid participant!"); 
      IdToGiveaway[_id].players.push(msg.sender);

    }
    
}


