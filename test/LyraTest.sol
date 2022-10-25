// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Test.sol";
import "../src/Lyra.sol";

contract LyraTest is Test {
    Lyra lyra;
    address owner;

    function setUp() public {
        owner = address(this);
        lyra = new Lyra();
    }

    function testMintSuccess() public {
        vm.deal(msg.sender, 1 ether);
        lyra.mint{value: 0.002 ether}(2);
        assertEq(address(lyra).balance, 0.002 ether);
        assertEq(lyra.balanceOf(address(this)), 2);
    }

    function testMintOverflow() public {
        vm.deal(msg.sender, 1 ether);
        lyra.mint{value: 0.332 ether}(332);
        assertEq(lyra.totalSupply(), 332);
        vm.expectRevert("Maximum supply exceeded");
        lyra.mint{value: 0.002 ether}(2);
    }

    function testWithdrawAsOwner() public {
        vm.deal(msg.sender, 1 ether);
        lyra.mint{value: 0.002 ether}(2);
        lyra.withdraw(0.001 ether);
    }
}
