// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ICollectible.sol";

contract MiniCollectibles is ICollectible {
    string public name = "Mini Collectibles";
    string public symbol = "MCOL";
    string public baseURI;
    
    uint256 public constant MINT_PRICE = 0.000012 ether;
    uint256 private _tokenIdCounter;
    address public owner;
    
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => CollectibleType) private _collectibleTypes;
    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => address) private _tokenApprovals;
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event Withdrawal(address indexed to, uint256 amount);
    event BaseURIUpdated(string newBaseURI);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    function ownerOf(uint256 tokenId) public view returns (address) {
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        return tokenOwner;
    }
    
    function balanceOf(address account) public view returns (uint256) {
        require(account != address(0), "Zero address");
        return _balances[account];
    }
    
    function getMintPrice() external pure returns (uint256) {
        return MINT_PRICE;
    }
    
    function getCollectibleType(uint256 tokenId) external view returns (CollectibleType) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _collectibleTypes[tokenId];
    }
    
    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }
    
    function _determineType(uint256 tokenId) internal pure returns (CollectibleType) {
        uint256 rand = uint256(keccak256(abi.encodePacked(tokenId))) % 100;
        if (rand < 50) return CollectibleType.COMMON;
        if (rand < 80) return CollectibleType.RARE;
        if (rand < 95) return CollectibleType.EPIC;
        return CollectibleType.LEGENDARY;
    }
    
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
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    function mint() external payable returns (uint256) {
        require(msg.value == MINT_PRICE, "Incorrect mint price");
        
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        
        _owners[tokenId] = msg.sender;
        _balances[msg.sender]++;
        _collectibleTypes[tokenId] = _determineType(tokenId);
        
        emit CollectibleMinted(msg.sender, tokenId, _collectibleTypes[tokenId]);
        emit Transfer(address(0), msg.sender, tokenId);
        
        return tokenId;
    }
    
    function approve(address to, uint256 tokenId) external {
        address tokenOwner = ownerOf(tokenId);
        require(msg.sender == tokenOwner, "Not token owner");
        require(to != tokenOwner, "Cannot approve self");
        
        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);
    }
    
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _tokenApprovals[tokenId];
    }
    
    function transferFrom(address from, address to, uint256 tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or owner");
        require(ownerOf(tokenId) == from, "From is not owner");
        require(to != address(0), "Cannot transfer to zero address");
        
        _tokenApprovals[tokenId] = address(0);
        _balances[from]--;
        _balances[to]++;
        _owners[tokenId] = to;
        
        emit Transfer(from, to, tokenId);
    }
    
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address tokenOwner = ownerOf(tokenId);
        return (spender == tokenOwner || getApproved(tokenId) == spender);
    }
    
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return string(abi.encodePacked(baseURI, _toString(tokenId)));
    }
    
    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
        emit BaseURIUpdated(newBaseURI);
    }
    
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Withdrawal failed");
        
        emit Withdrawal(owner, balance);
    }
}
