// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ICollectible.sol";

contract MiniCollectibles is ICollectible {
    string public name = "Mini Collectibles";
    string public symbol = "MCOL";
    
    uint256 public constant MINT_PRICE = 0.000012 ether;
    uint256 private _tokenIdCounter;
    address public owner;
    
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => CollectibleType) private _collectibleTypes;
    mapping(uint256 => string) private _tokenURIs;
    
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
}
