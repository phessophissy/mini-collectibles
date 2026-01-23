// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Mini Collectibles - Flattened for Remix Deployment
/// @notice Deploy this on Base Mainnet with minting fee of 0.000012 ETH
/// @dev Copy this entire file into Remix IDE

// ============ Interface ============
interface ICollectible {
    enum CollectibleType { COMMON, RARE, EPIC, LEGENDARY }
    
    event CollectibleMinted(address indexed owner, uint256 indexed tokenId, CollectibleType collectibleType);
    
    function mint() external payable returns (uint256);
    function getMintPrice() external view returns (uint256);
    function getCollectibleType(uint256 tokenId) external view returns (CollectibleType);
}

// ============ Main Contract ============
contract MiniCollectibles is ICollectible {
    // Constants
    uint256 public constant MINT_PRICE = 0.000012 ether;
    
    // Token metadata
    string public name = "Mini Collectibles";
    string public symbol = "MCOL";
    string private _baseURI;
    
    // Token tracking
    uint256 private _tokenIdCounter;
    address public owner;
    
    // Mappings
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(uint256 => CollectibleType) private _collectibleTypes;
    
    // Events
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event Withdrawal(address indexed to, uint256 amount);
    event BaseURIUpdated(string newBaseURI);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        _baseURI = "";
    }
    
    // ============ Minting ============
    function mint() external payable override returns (uint256) {
        require(msg.value >= MINT_PRICE, "Insufficient payment");
        
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        
        _owners[tokenId] = msg.sender;
        _balances[msg.sender]++;
        
        CollectibleType cType = _determineType(tokenId);
        _collectibleTypes[tokenId] = cType;
        
        emit Transfer(address(0), msg.sender, tokenId);
        emit CollectibleMinted(msg.sender, tokenId, cType);
        
        // Refund excess payment
        if (msg.value > MINT_PRICE) {
            payable(msg.sender).transfer(msg.value - MINT_PRICE);
        }
        
        return tokenId;
    }
    
    function _determineType(uint256 tokenId) internal view returns (CollectibleType) {
        uint256 rand = uint256(keccak256(abi.encodePacked(
            block.timestamp,
            block.prevrandao,
            msg.sender,
            tokenId
        ))) % 100;
        
        if (rand < 50) return CollectibleType.COMMON;      // 50%
        if (rand < 80) return CollectibleType.RARE;        // 30%
        if (rand < 95) return CollectibleType.EPIC;        // 15%
        return CollectibleType.LEGENDARY;                   // 5%
    }
    
    // ============ View Functions ============
    function getMintPrice() external pure override returns (uint256) {
        return MINT_PRICE;
    }
    
    function getCollectibleType(uint256 tokenId) external view override returns (CollectibleType) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _collectibleTypes[tokenId];
    }
    
    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }
    
    function balanceOf(address account) external view returns (uint256) {
        require(account != address(0), "Zero address");
        return _balances[account];
    }
    
    function ownerOf(uint256 tokenId) external view returns (address) {
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        return tokenOwner;
    }
    
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return string(abi.encodePacked(_baseURI, _toString(tokenId)));
    }
    
    function getApproved(uint256 tokenId) external view returns (address) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _tokenApprovals[tokenId];
    }
    
    // ============ Transfer Functions ============
    function approve(address to, uint256 tokenId) external {
        address tokenOwner = _owners[tokenId];
        require(msg.sender == tokenOwner, "Not token owner");
        require(to != tokenOwner, "Cannot approve self");
        
        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);
    }
    
    function transferFrom(address from, address to, uint256 tokenId) external {
        require(_owners[tokenId] == from, "Not token owner");
        require(to != address(0), "Zero address");
        require(
            msg.sender == from || _tokenApprovals[tokenId] == msg.sender,
            "Not authorized"
        );
        
        _tokenApprovals[tokenId] = address(0);
        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;
        
        emit Transfer(from, to, tokenId);
    }
    
    // ============ Admin Functions ============
    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        _baseURI = newBaseURI;
        emit BaseURIUpdated(newBaseURI);
    }
    
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        
        payable(owner).transfer(balance);
        emit Withdrawal(owner, balance);
    }
    
    // ============ Internal Helpers ============
    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + value % 10));
            value /= 10;
        }
        
        return string(buffer);
    }
    
    receive() external payable {}
}
