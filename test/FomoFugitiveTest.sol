// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "../lib/forge-std/src/Test.sol";
import "../src/FomoFugitive.sol";

contract FomoFugitiveTest is Test {
    FomoFugitive fugitives;
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
        price = 0.007 ether;
        fugitives = new FomoFugitive();
        vm.deal(fugitives.owner(), 10 ether);
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
        fugitives.mint{value: price * quantity}(quantity);
        assertEq(address(fugitives).balance, price * quantity);
        assertEq(fugitives.balanceOf(address(this)), quantity);
    }

    function testMintTooMany() public {
        uint256 quantity = 11;
        vm.expectRevert("Too Many Minted");
        fugitives.mint{value: price * quantity}(quantity);
    }

    function testMintOverflow() public {
        uint256 quantity = 7;
        for (uint256 i = 0; i < 110; i++) {
            fugitives.mint{value: price * quantity}(quantity);
        }
        fugitives.mint{value: price * 7}(7);
        assertEq(fugitives.totalSupply(), 777);
        vm.expectRevert("Maximum supply exceeded");
        fugitives.mint{value: price * 7}(7);
    }

    /// -----------------------------------------------------------------------
    /// Owner MINTING
    /// -----------------------------------------------------------------------

    function testOwnerMintSuccess() public {
        uint256 quantity = 35;
        fugitives.ownerMint{value: 0}();
        assertEq(fugitives.totalSupply(), quantity);
    }

    function testOwnerMintAsNotOwner() public {
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        fugitives.ownerMint{value: 0}();
        assertEq(fugitives.totalSupply(), 0);
    }

    function testOwnerMintOverflow() public {
        for (uint256 i = 0; i < 77; i++) {
            fugitives.ownerMint{value: 0}();
        }
        assertEq(fugitives.totalSupply(), 770);
        vm.expectRevert("Maximum supply exceeded");
        fugitives.ownerMint{value: 0}();
    }

    /// -----------------------------------------------------------------------
    /// WITHDRAWALS
    /// -----------------------------------------------------------------------

    function testWithdrawAsOwner() public {
        uint256 quantity = 3;
        fugitives.mint{value: price * quantity}(quantity);
        fugitives.withdraw();
        assertEq(address(this).balance, 10 ether);
    }

    function testWithdrawAsNotOwner() public {
        uint256 quantity = 6;
        fugitives.mint{value: price * quantity}(quantity);
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        fugitives.withdraw();
        assertEq(address(fugitives).balance, price * quantity);
    }

    /// -----------------------------------------------------------------------
    /// PRICE
    /// -----------------------------------------------------------------------

    function testChangePrice() public {
        uint256 oldPrice = price;
        uint256 newPrice = 0.01888 ether;
        // Test constructor setting price
        assertEq(fugitives.getPrice(), price);
        // Change price as owner
        fugitives.changePrice(newPrice);
        assertEq(fugitives.getPrice(), newPrice);
        // Check that only owner can change price
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        fugitives.changePrice(0.001 ether);
        // Check a mint with new price
        uint256 quantity = 6;
        vm.expectRevert("The price is invalid");
        fugitives.mint{value: oldPrice * quantity}(quantity);
    }

    /// -----------------------------------------------------------------------
    /// TOKEN URI
    /// -----------------------------------------------------------------------

    function testTokenURI() public {
        fugitives.mint{value: price * 7}(7);
        string memory uri = fugitives.tokenURI(2);
        assertEq(
            uri,
            "ipfs://bafybeic3zfaptjliooe75ahpgjudssskm5p4tzpcwd3pozegvo2s7myfp4/2.json"
        );
    }
}
