// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "../lib/forge-std/src/Test.sol";
import "../src/Lyra.sol";

contract LyraTest is Test {
    Lyra lyra;
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
        price = 0.001 ether;
        lyra = new Lyra(price);
        vm.deal(lyra.owner(), 1 ether);
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
        lyra.mint{value: price * quantity}(quantity);
        assertEq(address(lyra).balance, price * quantity);
        assertEq(lyra.balanceOf(address(this)), quantity);
    }

    function testMintOverflow() public {
        uint256 quantity = 332;
        lyra.mint{value: price * quantity}(quantity);
        assertEq(lyra.totalSupply(), quantity);
        vm.expectRevert("Maximum supply exceeded");
        lyra.mint{value: price * 2}(2);
    }

    /// -----------------------------------------------------------------------
    /// WITHDRAWALS
    /// -----------------------------------------------------------------------

    function testWithdrawAsOwner() public {
        uint256 quantity = 3;
        lyra.mint{value: price * quantity}(quantity);
        lyra.withdraw();
        assertEq(address(this).balance, 1 ether);
    }

    function testWithdrawAsNotOwner() public {
        uint256 quantity = 6;
        lyra.mint{value: price * quantity}(quantity);
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        lyra.withdraw();
        assertEq(address(lyra).balance, price * quantity);
    }

    /// -----------------------------------------------------------------------
    /// PRICE
    /// -----------------------------------------------------------------------

    function testChangePrice() public {
        uint256 oldPrice = price;
        uint256 newPrice = 0.01888 ether;
        // Test constructor setting price
        assertEq(lyra.getPrice(), price);
        // Change price as owner
        lyra.changePrice(newPrice);
        assertEq(lyra.getPrice(), newPrice);
        // Check that only owner can change price
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        lyra.changePrice(0.001 ether);
        // Check a mint with new price
        uint256 quantity = 6;
        vm.expectRevert("The price is invalid");
        lyra.mint{value: oldPrice * quantity}(quantity);
    }
}
