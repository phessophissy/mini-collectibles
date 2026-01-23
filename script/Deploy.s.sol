// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/MiniCollectibles.sol";

/// @title Deploy Script for Mini Collectibles
/// @notice Deploys the MiniCollectibles contract to Base Chain
contract DeployScript {
    MiniCollectibles public collectibles;
    
    function run() external returns (MiniCollectibles) {
        collectibles = new MiniCollectibles();
        return collectibles;
    }
    
    function deployWithBaseURI(string memory baseURI) external returns (MiniCollectibles) {
        collectibles = new MiniCollectibles();
        collectibles.setBaseURI(baseURI);
        return collectibles;
    }
}
