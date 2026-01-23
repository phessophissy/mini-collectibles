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
    
    function testInitialSupply() public view {
        assert(collectibles.totalSupply() == 0);
    }
    
    function testName() public view {
        assert(keccak256(bytes(collectibles.name())) == keccak256(bytes("Mini Collectibles")));
    }
    
    function testSymbol() public view {
        assert(keccak256(bytes(collectibles.symbol())) == keccak256(bytes("MCOL")));
    }
}
