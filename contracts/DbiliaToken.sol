// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// A Simple Custom NFT
contract DbiliaToken is ERC721 {
    // dbilia address
    address public dbilia;

    struct Card {
        address user;
        uint256 edition;
        string tokenURI;
    }
    // card used for payment
    mapping(uint256 => Card) cards; 
    // Id of the current token
    uint256 private currentTokenId;

    mapping(uint256 => string) public uris;
    mapping(uint256 => uint256) public editions;

    event MintWithUSD(address indexed user, uint256 tokenId);
    event MintWithETH(address indexed user, uint256 tokenId);

    constructor(
        string memory _name,
        string memory _symbol,
        address _dbilia
    ) ERC721(_name, _symbol) {
        require(_dbilia != address(0), "Dbilia: wrong address");
        dbilia = _dbilia;
    }

    modifier onlyDbilia() {
        require(msg.sender == dbilia, "Dbilia: not dbilia");
        _;
    }

    // dbilia mints token on the user's behalf
    function mintWithUSD(address user, uint256 cardId, uint256 edition, string memory tokenURI) public onlyDbilia {
        uint256 tokenId = _mintToken(user, cardId, edition, tokenURI);

        emit MintWithUSD(user, tokenId);
    }

    // user mints token
    function mintWithETH(uint256 cardId, uint256 edition, string memory tokenURI) public payable {
        require(msg.value > 1e9, "Dbilia: insufficient amount"); // minimum eth amount for minting toekn is 1e9 wei
        uint256 tokenId = _mintToken(msg.sender, cardId, edition, tokenURI);
    
        emit MintWithETH(msg.sender, tokenId);
    }
    
    // set the dbilia address
    function setDbilia(address _dbilia) public onlyDbilia {
        dbilia = _dbilia;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return uris[tokenId];
    }

    // generate new token id
    function _newTokenId() internal returns (uint256) {
        return ++currentTokenId;
    }

    // mint new token
    function _mintToken(address user, uint256 cardId, uint256 edition, string memory tokenURI) internal returns (uint256 tokenId) {
        require(cards[cardId].user == address(0), "Dbilia: CardId exists");
        require(user != address(0), "Dbilia: wrong address");

        tokenId = _newTokenId();
        _mint(user, tokenId);
        uris[tokenId] = tokenURI;
        editions[cardId] = edition;
        
        cards[cardId].user = user;
        cards[cardId].edition = edition;
        cards[cardId].tokenURI = tokenURI;
    }
}