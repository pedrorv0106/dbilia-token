// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DbiliaToken is ERC721 {
    using SafeMath for uint256;

    address public dbilia;

    struct Card {
        address user;
        uint256 edition;
        string tokenURI;
    }

    mapping(uint256 => Card) cards; 

    uint256 private currentTokenId = 0;

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

    function mintWithUSD(address user, uint256 cardId, uint256 edition, string memory tokenURI) public onlyDbilia {
        require(cards[cardId].user == address(0), "Dbilia: CardId exists");
        require(user != address(0), "Dbilia: wrong address");

        uint256 newTokenId = _newTokenId();
        _mint(user, newTokenId);
        uris[newTokenId] = tokenURI;
        editions[cardId] = edition;
        
        cards[cardId].user = user;
        cards[cardId].edition = edition;
        cards[cardId].tokenURI = tokenURI;
        emit MintWithUSD(user, newTokenId);
    }

    function mintWithETH(uint256 cardId, uint256 edition, string memory tokenURI) public payable {
        require(cards[cardId].user == address(0), "Dbilia: CardId exists");
        require(msg.value > 1e9, "Dbilia: insufficient amount"); // minimum eth amount for minting toekn is 1e9 wei
        
        uint256 newTokenId = _newTokenId();
        _mint(msg.sender, newTokenId);
        uris[newTokenId] = tokenURI;
        editions[cardId] = edition;

        cards[cardId].user = msg.sender;
        cards[cardId].edition = edition;
        cards[cardId].tokenURI = tokenURI;

        emit MintWithETH(msg.sender, newTokenId);
    }

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

    function _newTokenId() internal returns (uint256) {
        return ++currentTokenId;
    }
}