// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface IRandom {
    function requestRandomWords() external returns (uint256);

    function getRequestStatus() external view returns (uint256);
    
}

contract WarframeTK is ERC1155, Ownable, ERC1155Supply {
    using Counters for Counters.Counter;

    Counters.Counter private _count;

    uint256 private constant swordBlueprint = 1;
    uint256 private constant axeBlueprint = 2;
    uint256 private constant swordExcalibur = 3;
    uint256 private constant axeStormbreaker = 4;

    uint private whitelistPrice = 0.05 ether;

    uint public winnerIndex;

    uint[] private id = [swordBlueprint,axeBlueprint,swordExcalibur,axeStormbreaker];
    uint[] private supplies = [20,20,1,1];

    mapping(uint => address) public whitelist;

    constructor() ERC1155("https://ipfs.io/ipfs/bafybeihw3enczry66duwwo7ghgfvn2fa5cvmsu2jiijzuc4dus76ujteau/") {  }


    function setWhiteList(address participants) public payable{
        require(msg.value == whitelistPrice,"Not enough money!");
        _count.increment();
        uint count = _count.current();
        whitelist[count] = participants;
    }

    function generateRandomNum()public onlyOwner {
        IRandom(0xD730CFd9ab76322DC0CC3615d9A8e7Af779fA700).requestRandomWords();
    }

    function getWinnerIndex()public onlyOwner{
        winnerIndex = IRandom(0xD730CFd9ab76322DC0CC3615d9A8e7Af779fA700).getRequestStatus();
    }


    function uri(uint256 _id) public view virtual override returns (string memory){
        require(exists(_id),"URI: nonexistent token");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
    }

    function airdropTokens() public onlyOwner{
        _mintBatch(whitelist[winnerIndex], id, supplies, "");
        whitelist[winnerIndex]=address(0);
    }

    function withdrawMoney() public onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    
}

//  0x6bBD0c46383Ef8439a487A58b99224d9305b3108











