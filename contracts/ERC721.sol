// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ERC721Contract is Ownable, ERC721Enumerable, ERC721URIStorage, ERC721Royalty{

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){}

    function _mint(string memory _tokenURI, uint96 _feeNumerator) public onlyOwner returns (uint256){
        uint256 _tokenID = totalSupply();
        _mint(msg.sender, _tokenID);
        _setTokenURI(_tokenID, _tokenURI);
        _setTokenRoyalty(_tokenID, msg.sender, _feeNumerator);
        return _tokenID;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage, ERC721Royalty){
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Royalty,ERC721Enumerable,ERC721) returns (bool){
        return super.supportsInterface(interfaceId);
    }
}