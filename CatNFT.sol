// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CATnft is ERC721,Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _addressId;

    uint private whitelistPrice = 0.005 ether;


    mapping(address => bool) whitelist;

    event Claimed(address _claimer,uint tokenId);

    constructor() ERC721("CatsNFT", "CAT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.io/ipfs/bafybeicwfsjdswjvij56ivr3juktwt4v5vxgeajvgnhrozx65ed3beyo64/";
    }


    function setWhiteList() public payable{
        require(!whitelist[msg.sender], "Already Whitelisted");
        require(msg.value == whitelistPrice,"Not enough money!");
        _addressId.increment();
        uint256 newaddresId = _addressId.current();
        require(newaddresId <= 5,"Maximum whitelisted user");
        whitelist[msg.sender] = true;

    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721)
    {
        super._burn(tokenId);
    }

    function claimNFT() public {
        require(whitelist[msg.sender], "Recipient must be whitelisted");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        require(newItemId <= 5,"Can't mint more token");
        _mint(msg.sender, newItemId);
        whitelist[msg.sender] = false;
        emit Claimed(msg.sender,newItemId);
    }

    function withdrawMoney() public onlyOwner{
        payable(msg.sender).transfer(address(this).balance);
    }


    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
    }

}
