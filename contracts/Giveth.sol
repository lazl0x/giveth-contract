pragma solidity >=0.7.0 <0.9.0;
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


    /*
    */
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

    function releaseGiveaway(uint _id) public {

      require(msg.sender == IdToGiveaway[_id].creator, "Only giveaway creator can release!"); 

      address winner = _chooseGiveawayWinner(IdToGiveaway[_id]);

      //(bool sent, bytes memory data) = 
      _rewardGiveawayWinner(IdToGiveaway[_id], winner);

    }

    function _chooseGiveawayWinner(Giveaway storage _giveaway) private returns (address) {
       // Select player to send reward
      address payable winner = payable(_giveaway.players[0]);
      return winner; 
    }

    function _rewardGiveawayWinner(Giveaway storage _giveaway, address _to) private returns (bool, bytes memory) {
      return _to.call{value: _giveaway.reward}("Transication");
    }
    
}




