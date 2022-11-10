// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@ERC721A/ERC721A.sol";
import "@ERC721A/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lyra is ERC721A, Ownable, ERC721AQueryable {
    // Placeholder price
    uint256 public price = 0.001 ether;

    string private baseURI =
        "https://lyraweb.ngrok.io/creature_tokens/chain/goerli/";

    uint64 public immutable _maxSupply = 333;

    constructor(uint256 _price) ERC721A("LYRA", "LYRA") {
        price = _price;
    }

    /*///////////////////////////////////
                    Mint
    //////////////////////////////////*/

    function mint(uint256 quantity) external payable {
        require(msg.value == price * quantity, "The price is invalid");
        require(
            totalSupply() + quantity <= _maxSupply,
            "Maximum supply exceeded"
        );
        _mint(msg.sender, quantity);
    }

    /*/////////////////////////////////////////////////////////////////////////////
        Below is the base URI stuff, it will point to the lyra server, which will
        be a proxy for more permanent storage solutions such as IPFS.
    /////////////////////////////////////////////////////////////////////////////*/

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _baseUri) public onlyOwner {
        baseURI = _baseUri;
    }

    /*///////////////////////////////////////////////////////////
        Withdraw function to get ether out of the contract
    ///////////////////////////////////////////////////////////*/

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }

    function withdrawAny(uint256 _amount) public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success);
    }
}
