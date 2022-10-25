// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/ERC721A/contracts/ERC721A.sol";
import "../lib/ERC721A/contracts/extensions/ERC721AQueryable.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Lyra is ERC721A, Ownable, ERC721AQueryable {
    uint256 public Price = 0.001 ether;
    string private baseURI =
        "https://lyraweb.ngrok.io/creature_tokens/chain/goerli/";
    uint64 public immutable _maxSupply = 333;

    constructor() ERC721A("LYRA", "LYRA") {}

    function mint(uint256 quantity) external payable {
        require(msg.value == Price * quantity, "The price is invalid");
        require(
            totalSupply() + quantity <= _maxSupply,
            "Maximum supply exceeded"
        );
        _mint(msg.sender, quantity);
    }

    /**
     * Below is the base URI stuff, it will point to the lyra server, which will
     * be a proxy for more permanent storage solutions such as IPFS.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _baseUri) public onlyOwner {
        baseURI = _baseUri;
    }

    /**
     * Withdraw function to get ether out of the contract
     */

    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient Funds");
        payable(msg.sender).transfer(amount);
    }
}
