// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "../lib/forge-std/src/Test.sol";
import "../src/Dloot.sol";

contract LyraTest is Test {
    Dloot dloot;
    address owner;
    address someUser;
    uint256 public price;

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    /// -----------------------------------------------------------------------
    /// SETUP
    /// -----------------------------------------------------------------------

    function setUp() public {
        owner = address(this);
        price = 0.003 ether;
        dloot = new Dloot();
        vm.deal(dloot.owner(), 10 ether);
        string
            memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey = vm.deriveKey(mnemonic, 0);
        someUser = vm.addr(privateKey);
    }

    /// -----------------------------------------------------------------------
    /// MINTING
    /// -----------------------------------------------------------------------

    function testMintSuccess() public {
        uint256 quantity = 2;
        dloot.mint{value: price * quantity}(quantity);
        assertEq(address(dloot).balance, price * quantity);
        assertEq(dloot.balanceOf(address(this)), quantity);
    }

    function testMintTooMany() public {
        uint256 quantity = 11;
        vm.expectRevert("Too Many Minted");
        dloot.mint{value: price * quantity}(quantity);
    }

    function testMintOverflow() public {
        uint256 quantity = 10;
        for (uint256 i = 0; i < 15; i++) {
            dloot.mint{value: price * quantity}(quantity);
        }
        assertEq(dloot.totalSupply(), 150);
        vm.expectRevert("Maximum supply exceeded");
        dloot.mint{value: price * 10}(10);
    }

    /// -----------------------------------------------------------------------
    /// Owner MINTING
    /// -----------------------------------------------------------------------

    function testOwnerMintSuccess() public {
        uint256 quantity = 50;
        dloot.ownerMint{value: 0}(quantity);
        assertEq(dloot.totalSupply(), quantity);
    }

    function testOwnerMintAsNotOwner() public {
        vm.prank(someUser);
        uint256 quantity = 50;
        vm.expectRevert("Ownable: caller is not the owner");
        dloot.ownerMint{value: 0}(quantity);
        assertEq(dloot.totalSupply(), 0);
    }

    function testOwnerMintOverflow() public {
        uint256 quantity = 10;
        for (uint256 i = 0; i < 15; i++) {
            dloot.ownerMint{value: 0}(quantity);
        }
        assertEq(dloot.totalSupply(), 150);
        vm.expectRevert("Maximum supply exceeded");
        dloot.ownerMint{value: 0}(10);
    }

    /// -----------------------------------------------------------------------
    /// WITHDRAWALS
    /// -----------------------------------------------------------------------

    function testWithdrawAsOwner() public {
        uint256 quantity = 3;
        dloot.mint{value: price * quantity}(quantity);
        dloot.withdraw();
        assertEq(address(this).balance, 10 ether);
    }

    function testWithdrawAsNotOwner() public {
        uint256 quantity = 6;
        dloot.mint{value: price * quantity}(quantity);
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        dloot.withdraw();
        assertEq(address(dloot).balance, price * quantity);
    }

    /// -----------------------------------------------------------------------
    /// PRICE
    /// -----------------------------------------------------------------------

    function testChangePrice() public {
        uint256 oldPrice = price;
        uint256 newPrice = 0.01888 ether;
        // Test constructor setting price
        assertEq(dloot.getPrice(), price);
        // Change price as owner
        dloot.changePrice(newPrice);
        assertEq(dloot.getPrice(), newPrice);
        // Check that only owner can change price
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        dloot.changePrice(0.001 ether);
        // Check a mint with new price
        uint256 quantity = 6;
        vm.expectRevert("The price is invalid");
        dloot.mint{value: oldPrice * quantity}(quantity);
    }

    /// -----------------------------------------------------------------------
    /// TOKEN URI
    /// -----------------------------------------------------------------------

    function testTokenURI() public {
        dloot.mint{value: price * 10}(10);
        string memory uri = dloot.tokenURI(2);
        assertEq(
            uri,
            "ipfs://bafybeifcca6qpeiups6gzqalh6etwpq6h5y3cakrv7s6zxr2mz3aderjdi/2.json"
        );
    }
}
