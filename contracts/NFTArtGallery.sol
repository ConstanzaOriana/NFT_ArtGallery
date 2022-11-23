// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./ERC721.sol";

contract NFTArtGallery is ERC721, Ownable {
   
    ERC721Contract public ERC721ContractTokenInstance;

    constructor(string memory _tokenName, string memory _tokenSymbol) ERC721(_tokenName, _tokenSymbol){
        ERC721ContractTokenInstance = new ERC721Contract("Web3 Art Gallery", "WAG");
    }

    event publishArt(address _owner, uint256 _tokenID);
    event sellNFT(address indexed _buyer, uint256 _price, uint256 _NFT);
    event withdrawEvent(uint256 _amount, uint256 _timestamp);

    mapping(uint256 => uint256) _NFTPrices;


    function _publishArtwork(string memory _tokenURI, uint256 _tokenPrice, uint96 _feeNumerator) public onlyOwner {
        uint256 _newTokenId = ERC721ContractTokenInstance._mint(_tokenURI, _feeNumerator);
        _NFTPrices[_newTokenId] = _tokenPrice;
        emit publishArt(address(this), _newTokenId);
    }

    
    function _setPrice(uint256 _tokenID, uint256 _newPrice) public {
        require(ERC721ContractTokenInstance.ownerOf(_tokenID) == msg.sender, "Cant set a price in NFT you dont own");
        _NFTPrices[_tokenID] = _newPrice;
    }

    function _getPrice(uint256 _tokenID) public view returns (uint256 _NFTPrice){
        _NFTPrice = _NFTPrices[_tokenID];
    }


    function _galleryNFTBalance() public view onlyOwner returns (uint256) {
        uint256 _ArtGalleryNFTS = balanceOf(address(this));
        return _ArtGalleryNFTS;
    }

    function _userBalance(address _userAddress) public view returns (uint256){
        uint256 _userNFTS = balanceOf(_userAddress);
        return _userNFTS;
    }

    
    function _buyNFT(uint256 _tokenID) public payable {
        uint256 _tokenPrice = _NFTPrices[_tokenID];
        require(_tokenPrice > 0, "Cant buy this NFT");
        require(_tokenPrice == msg.value, "Sent amount doesnt match NFT actual price");

        address buyer = msg.sender;
        address seller = ERC721ContractTokenInstance.ownerOf(_tokenID);
        uint256 amountReceived = msg.value;

        ERC721ContractTokenInstance.safeTransferFrom(seller, buyer, _tokenID);

        (, uint256 royaltyAmount) = ERC721ContractTokenInstance.royaltyInfo(_tokenID, _tokenPrice);
        uint256 sellerAmount = amountReceived - royaltyAmount;

        if (seller != address(this)) {
            payable(seller).transfer(sellerAmount);
        }

        _NFTPrices[_tokenID] = 0; 

        emit sellNFT(msg.sender, msg.value, _tokenID);
    }


    function _ethContractBalance() public view onlyOwner returns (uint256) {
        uint256 _balance = address(this).balance;
        return _balance;
    }

    function withdraw() external onlyOwner {
        uint _ethBalance = _ethContractBalance();
        require(address(this).balance > 0, "There are no ethers to withdraw yet");
        payable(msg.sender).transfer(_ethBalance);
        emit withdrawEvent(_ethBalance, block.timestamp);
    }
}