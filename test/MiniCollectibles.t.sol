// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/MiniCollectibles.sol";

contract MiniCollectiblesTest {
    MiniCollectibles public collectibles;
    
    function setUp() public {
        collectibles = new MiniCollectibles();
    }
}
