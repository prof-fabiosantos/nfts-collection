// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


import "hardhat/console.sol";

// Helper we wrote to encode in Base64
import "./libraries/Base64.sol";


// Our contract inherits from ERC721, which is the standard NFT contract!
contract MyNftsCollection is ERC721 {

  struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;      
  }

  // The tokenId is the NFTs unique identifier, it's just a number that goes
  // 0, 1, 2, 3, etc.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  CharacterAttributes[] defaultCharacters;

  // We create a mapping from the nft's tokenId => that NFTs attributes.
  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

  // A mapping from an address => the NFTs tokenId. Gives me an ez way
  // to store the owner of the NFT and reference it later.
  mapping(address => uint256) public nftHolders;

  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs    
  )
    ERC721("Robos", "ROBO")
  {
    for(uint i = 0; i < characterNames.length; i += 1) {
      defaultCharacters.push(CharacterAttributes({
        characterIndex: i,
        name: characterNames[i],
        imageURI: characterImageURIs[i]
      }));

      CharacterAttributes memory c = defaultCharacters[i];
      
      // Hardhat's use of console.log() allows up to 4 parameters in any order of following types: uint, string, bool, address
      console.log("Done initializing %s , img %s", c.name, c.imageURI);
    }

    // I increment _tokenIds here so that my first NFT has an ID of 1.
    // More on this in the lesson!
    _tokenIds.increment();
  }

  // Users would be able to hit this function and get their NFT based on the
  // characterId they send in!
  function mintCharacterNFT(uint _characterIndex) external {
    // Get current tokenId (starts at 1 since we incremented in the constructor).
    uint256 newItemId = _tokenIds.current();

    // The magical function! Assigns the tokenId to the caller's wallet address.
    _safeMint(msg.sender, newItemId);

    // We map the tokenId => their character attributes. More on this in
    // the lesson below.
    nftHolderAttributes[newItemId] = CharacterAttributes({
      characterIndex: _characterIndex,
      name: defaultCharacters[_characterIndex].name,
      imageURI: defaultCharacters[_characterIndex].imageURI      
    });

    console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);
    
    // Keep an easy way to see who owns what NFT.
    nftHolders[msg.sender] = newItemId;

    // Increment the tokenId for the next person that uses it.
    _tokenIds.increment();
  }
  
  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
	  CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];
	 

	  string memory json = Base64.encode(
		abi.encodePacked(
		  '{"name": "',
		  charAttributes.name,
		  ' -- NFT #: ',
		  Strings.toString(_tokenId),
		  '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
		  charAttributes.imageURI,'"}'
		)
	  );

	  string memory output = string(
		abi.encodePacked("data:application/json;base64,", json)
	  );
	  
	  return output;
}
  
  
}