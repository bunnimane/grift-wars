// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "../lib/forge-std/src/Test.sol";
import "../src/Lyra.sol";

contract LyraTest is Test {
    Lyra lyra;
    address owner;

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    /// -----------------------------------------------------------------------
    /// SETUP
    /// -----------------------------------------------------------------------

    function setUp() public {
        owner = address(this);
        lyra = new Lyra(0.001 ether);
    }

    /// -----------------------------------------------------------------------
    /// MINTING
    /// -----------------------------------------------------------------------

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

    /// -----------------------------------------------------------------------
    /// WITHDRAWALS
    /// -----------------------------------------------------------------------

    function testWithdrawAsOwner() public {
        vm.deal(address(this), 1 ether);
        lyra.mint{value: 0.003 ether}(3);
        lyra.withdraw();
        assertEq(address(this).balance, 1 ether);
    }

    function testWithdrawAsNotOwner() public {
        vm.deal(lyra.owner(), 1 ether);
        lyra.mint{value: 0.006 ether}(6);
        string memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey = vm.deriveKey(mnemonic, 0);
        address someUser = vm.addr(privateKey);
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        lyra.withdraw();
        assertEq(address(lyra).balance, 0.006 ether);
    }
}
