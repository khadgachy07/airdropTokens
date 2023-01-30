// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GameToken is ERC20 {

    address private owner;

    mapping(address => bool) public whitelist;
    
    
    constructor() ERC20("Birtamod","BT"){
        owner = msg.sender;
        _mint(owner,10000 * 10 ** 18);
    }


    function setWhiteList() public {
        require(!whitelist[msg.sender],"Already Whitelisted");
        whitelist[msg.sender] = true;
    }

    function claimToken() public {
        require(whitelist[msg.sender],"You are not whitelisted or already claimed the token");
        _mint(msg.sender,100 * 10 ** 18);
        whitelist[msg.sender] = false;
    }

    function airdropToken(address _recipient) public {
        require(msg.sender == owner,"Caller must be owner");
        require(whitelist[_recipient],"This person isn't whitelisted");
        transfer(_recipient,100 * 10 ** 18);
        whitelist[_recipient] = false;
    }

}