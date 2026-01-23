// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/MiniCollectibles.sol";

contract MiniCollectiblesTest {
    MiniCollectibles public collectibles;
    
    function setUp() public {
        collectibles = new MiniCollectibles();
    }
    
    function testMintPrice() public view {
        assert(collectibles.getMintPrice() == 0.000012 ether);
    }
}
