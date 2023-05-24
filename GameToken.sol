// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

interface IRandom {
    function requestRandomWords() external returns (uint256);

    function getRequestStatus() external view returns (uint256);
    
}

contract GameToken is  ERC20,ConfirmedOwner  {

    uint private count;

    uint public winnerIndex;

    mapping(uint256 => address) public whitelist;

   
    
    
    constructor() ERC20("BLockTone","BT") ConfirmedOwner(msg.sender){
        count = 0;
        _mint(msg.sender,10000 * 10 ** 18); // decical -- 18
        // 1 * 10 ** 18;
    }

    function generateRandomNum()public onlyOwner {
        IRandom(0xD730CFd9ab76322DC0CC3615d9A8e7Af779fA700).requestRandomWords();
    }


    function setWhiteList(address participants) public {
        count++;
        whitelist[count] = participants;
    
    }

    function getWinnerIndex()public onlyOwner{
        winnerIndex = IRandom(0xD730CFd9ab76322DC0CC3615d9A8e7Af779fA700).getRequestStatus();
    }

    
    function airdropToken() public onlyOwner returns(address){
        transfer(whitelist[winnerIndex],100 * 10 ** 18);
        return whitelist[winnerIndex];
    }

}

//----- 0xD5d3FcD84cacd0f9bc26e6F7D2a9B0619dB87F93