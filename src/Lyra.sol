// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/ERC721A/contracts/ERC721A.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Lyra is ERC721A {
    constructor() ERC721A("LYRA", "LYRA") {}

    function mint(uint256 quantity) external payable {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        _mint(msg.sender, quantity);
    }
}
