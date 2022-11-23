const hre = require("hardhat");

async function main() {

  const ArtGalleryContract = await hre.ethers.getContractFactory("NFTArtGallery");
  const _artGalleryContract = await ArtGalleryContract.deploy("Web3 Gallery", "W3G");

  await _artGalleryContract.deployed();

  console.log("ERC721 deployed to: ", _artGalleryContract.address);
}


main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});