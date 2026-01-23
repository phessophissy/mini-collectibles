// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/MiniCollectibles.sol";

contract DeployScript {
    function run() external returns (MiniCollectibles) {
        MiniCollectibles collectibles = new MiniCollectibles();
        return collectibles;
    }
}
