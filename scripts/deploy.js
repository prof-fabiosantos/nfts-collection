const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory('MyNftsCollection');
  const gameContract = await gameContractFactory.deploy(
    ["Robô 1", "Robô 2", "Robô 3"],       // Names
    ["https://gateway.pinata.cloud/ipfs/QmQToKaXYmETMvhgAAvWPeQvHFPRrz4ffnxUo35eR5yySm", // Images
    "https://gateway.pinata.cloud/ipfs/QmUYxxxmzhBxdiJPZUB2i1NRdFN4W34Air7rvNgaYQaDNF", 
    "https://gateway.pinata.cloud/ipfs/QmdvyhmHHACCxCQwwLYyQTQXVzusHzQrcULoc1ryLEKeCN"]
    );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);
  
  let txn;
  txn = await gameContract.mintCharacterNFT(0);
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #2");

  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();
  console.log("Minted NFT #3");
  
  console.log("Done deploying and minting!");

  // Get the value of the NFT's URI.
  let returnedTokenUri = await gameContract.tokenURI(1);
  console.log("Token URI:", returnedTokenUri);

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();