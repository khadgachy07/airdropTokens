// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract WarframeTK is ERC1155, Ownable, ERC1155Supply {

    uint256 private constant swordBlueprint = 1;
    uint256 private constant axeBlueprint = 2;
    uint256 private constant swordExcalibur = 3;
    uint256 private constant axeStormbreaker = 4;

    uint private whitelistPrice = 0.05 ether;

    uint[] private id = [swordBlueprint,axeBlueprint,swordExcalibur,axeStormbreaker];
    uint[] private supplies = [20,20,1,1];

    mapping(address => bool) whitelist;

    constructor() ERC1155("https://ipfs.io/ipfs/bafybeihw3enczry66duwwo7ghgfvn2fa5cvmsu2jiijzuc4dus76ujteau/") {  }


    function setWhiteList() public payable{
        require(!whitelist[msg.sender], "Already Whitelisted");
        require(msg.value == whitelistPrice,"Not enough money!");
        whitelist[msg.sender] = true;
    }


    function uri(uint256 _id) public view virtual override returns (string memory){
        require(exists(_id),"URI: nonexistent token");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
    }

    function airdropTokens() public{
        require(whitelist[msg.sender],"Only whitelisted can claim it");
        _mintBatch(msg.sender, id, supplies, "");
        whitelist[msg.sender] = false;
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












