pragma solidity ^0.7.0;

import "hardhat/console.sol";

contract GivethV1 {

  address public owner;

  constructor() {
    
    owner = msg.sender;

  }
  
  // Giveaway 
  struct Giveaway {
    bytes32   id;          // Unique giveaway hash id
    address   creator;    // Giveaway creator (sender)
    bytes32   note;       // 32-byte note string
    uint256   reward;     // Ether reward
    address[] players;  // Playing players
    //struct Options options;     // Additional options
  }

  struct Options { 
      uint256 expire;     // Expire time
      uint8 playersMin; 
      uint8 playersMax;
      uint8 nWinners;
  }


  Giveaway[] public giveaways; // PUBLIC contests Giveaway array 

  mapping(bytes32 => Giveaway) public idToGiveaway; 
  mapping(address => bytes32[]) public addressToIds;
  
  uint private nonce = 0;
  
  // Giveaway ID hash function 
  function hashId(address _address) private returns (bytes32) {

    bytes32 hash = keccak256(abi.encodePacked(nonce, _address)); // TODO: Reduce length
    nonce++; 

    return hash;

  }

  // New Giveaway
  function _newGiveaway(address _from, uint256 _reward, bytes32 _note) private returns (Giveaway memory) {
  
    bytes32 _hash = hashId(_from);
    address[] memory _players;

    addressToIds[_from].push(_hash);

    idToGiveaway[_hash] = Giveaway(
      {
        id: _hash, 
        creator: _from,
        note: _note,
        reward: _reward,
        players: _players
      }
    );

    return idToGiveaway[_hash];

  }

  // Create A Giveaway
  function createGiveaway(bytes32 _note, uint256 _duration) public payable {
    
    require(msg.value >  0,        "Void: requires > 0 ETH"      ); 
    require(_duration >= 60 * 60,  "Duration: requires >= 3600"  );
    require(_duration <= 108000,   "Duration: requires <= 108000");
    
    console.log(msg.value);
    // calculate expiration(?)
    uint256 expire = block.timestamp + _duration;

    giveaways.push(_newGiveaway(msg.sender, msg.value, _note));
  
  }

  // Join A Giveaway
  function joinGiveaway(bytes32 _id) public {

    require(msg.sender != idToGiveaway[_id].creator, "Void: Creator cannot join self");
    
    idToGiveaway[_id].players.push(msg.sender); 

  }

}

