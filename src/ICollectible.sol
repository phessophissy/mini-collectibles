// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ICollectible {
    enum CollectibleType {
        COMMON,
        RARE,
        EPIC,
        LEGENDARY
    }

    event CollectibleMinted(
        address indexed owner,
        uint256 indexed tokenId,
        CollectibleType collectibleType
    );

    function mint(CollectibleType collectibleType) external payable;
    function getMintPrice() external view returns (uint256);
    function getCollectibleType(uint256 tokenId) external view returns (CollectibleType);
}
