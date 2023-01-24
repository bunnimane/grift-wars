// SPDX-License-Identifier: UNLICENSEDfugitivesfugitives
pragma solidity ^0.8.12;

import "../lib/forge-std/src/Test.sol";
import "../src/Remilio64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FomoFugitiveTest is Test {
    Remilio64 _Remilio64;
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
        price = 0.005 ether;
        _Remilio64 = new Remilio64();
        vm.deal(_Remilio64.owner(), 300 ether);
        string
            memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey = vm.deriveKey(mnemonic, 0);
        someUser = vm.addr(privateKey);
        _Remilio64.setMintOpened(true);
        // Used to override modifiers
        _Remilio64.setTestMode(true);
    }

    /// -----------------------------------------------------------------------
    /// MINTING
    /// -----------------------------------------------------------------------

    function testMintSuccess() public {
        uint256 quantity = 2;
        _Remilio64.mint{value: 0.001 ether * quantity}(quantity);
        assertEq(address(_Remilio64).balance, 0.001 ether * quantity);
        assertEq(_Remilio64.balanceOf(address(this)), quantity);
    }

    function testMintTooMany() public {
        uint256 quantity = 44;
        vm.expectRevert(TooManyMinted.selector);
        _Remilio64.mint{value: price * quantity}(quantity);
    }

    function testMintOverflow() public {
        uint256[] memory prices = _Remilio64.getPrice();
        // First Tier
        for (uint256 i = 0; i <= 999; i++) {
            _Remilio64.mint{value: prices[0]}(1);
        }

        // Second Tier
        for (uint256 i = 0; i <= 8999; i++) {
            _Remilio64.mint{value: prices[1]}(1);
        }

        assertEq(_Remilio64.totalSupply(), 10000);

        vm.expectRevert(MaxSupplyExceeded.selector);
        _Remilio64.mint{value: 0 ether}(1);
    }

    function testPublicMint() public {
        _Remilio64.setMintOpened(false);

        vm.expectRevert(PublicMintClosed.selector);
        _Remilio64.mint{value: 0 ether}(1);
    }

    function testWlMint() public {
        _Remilio64.wl_mint(1);
        assertEq(_Remilio64.getFreeTokens(), 999);
    }

    function testWlMintLimit() public {
        for (uint256 i = 0; i <= 999; i++) {
            _Remilio64.wl_mint(1);
        }
        assertEq(_Remilio64.getFreeTokens(), 0);
        vm.expectRevert("No Free Mints Left");
        _Remilio64.wl_mint(1);
    }

    function testWlMintNoFriends() public {
        _Remilio64.setTestMode(false);
        vm.expectRevert();
        _Remilio64.wl_mint(1);
    }

    /// -----------------------------------------------------------------------
    /// FACTIONS
    /// -----------------------------------------------------------------------

    function testFactions() public {
        testMintOverflow(); // mint max
        assertEq(_Remilio64.getItalianMafia(), 1000);
        assertEq(_Remilio64.getRussianMafia(), 1000);
        assertEq(_Remilio64.getChineseTriads(), 1000);
        assertEq(_Remilio64.getColombianNarcos(), 1000);
        assertEq(_Remilio64.getMexicanCartels(), 1000);
        assertEq(_Remilio64.getYakuza(), 1000);
        assertEq(_Remilio64.getCosaNostra(), 1000);
        assertEq(_Remilio64.getIrishMob(), 1000);
        assertEq(_Remilio64.getAlbanianMafia(), 1000);
        assertEq(_Remilio64.getHellsAngels(), 1000);
    }

    function testSetFaction() public {
        _Remilio64.mint{value: 0.001 ether}(1);
        _Remilio64.setFaction(0, 3);
        assertEq(_Remilio64.getFaction(0), 3);
        _Remilio64.setFaction(0, 2);
        assertEq(_Remilio64.getFaction(0), 2);
    }

    function testSetFactionAsNotOwner() public {
        _Remilio64.mint{value: 0.001 ether}(1);
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        _Remilio64.setFaction(0, 3);
    }

    /// -----------------------------------------------------------------------
    /// Owner MINTING
    /// -----------------------------------------------------------------------

    function testOwnerMintSuccess() public {
        uint256 quantity = 35;
        _Remilio64.ownerMint(quantity);
        assertEq(_Remilio64.totalSupply(), quantity);
    }

    function testOwnerMintAsNotOwner() public {
        vm.prank(someUser);
        uint256 quantity = 35;
        vm.expectRevert("Ownable: caller is not the owner");
        _Remilio64.ownerMint(quantity);
        assertEq(_Remilio64.totalSupply(), 0);
    }

    function testOwnerMintOverflow() public {
        // First Tier
        for (uint256 i = 0; i <= 9999; i++) {
            _Remilio64.ownerMint(1);
        }

        assertEq(_Remilio64.totalSupply(), 10000);

        vm.expectRevert(MaxSupplyExceeded.selector);
        _Remilio64.ownerMint(1);
    }

    /// -----------------------------------------------------------------------
    /// WITHDRAWALS
    /// -----------------------------------------------------------------------

    function testWithdrawAsOwner() public {
        uint256 oldBalance = address(this).balance;
        uint256 contractBalance = address(_Remilio64).balance;
        uint256 quantity = 3;
        _Remilio64.mint{value: 0.001 ether * quantity}(quantity);
        _Remilio64.withdraw();
        assertEq(address(this).balance, oldBalance + contractBalance);
        assertEq(address(_Remilio64).balance, 0);
    }

    function testWithdrawAsNotOwner() public {
        uint256 quantity = 6;
        _Remilio64.mint{value: 0.001 ether * quantity}(quantity);
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        _Remilio64.withdraw();
        assertEq(address(_Remilio64).balance, 0.001 ether * quantity);
    }

    /// -----------------------------------------------------------------------
    /// PRICE
    /// -----------------------------------------------------------------------

    function testChangePrice() public {
        uint256 newPrice = 0.01888 ether;
        // Change price as owner
        _Remilio64.changePrice(0, newPrice);
        uint256[] memory prices = _Remilio64.getPrice();
        assertEq(prices[0], newPrice);
        _Remilio64.changePrice(1, newPrice * 2);
        prices = _Remilio64.getPrice();
        assertEq(prices[1], newPrice * 2);
        // Check that only owner can change price
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        _Remilio64.changePrice(0, 0.001 ether);
    }

    /// -----------------------------------------------------------------------
    /// TOKEN URI
    /// -----------------------------------------------------------------------

    function testTokenURI() public {
        _Remilio64.mint{value: 0.001 ether * 7}(7);
        string memory uri = _Remilio64.tokenURI(2);
        assertEq(
            uri,
            string.concat(
                "http://127.0.0.1:8000/json/",
                _Remilio64.getFactionString(2),
                "/2"
            )
        );
    }

    /// -------------------------------------
    /// 🔫 Test Mode
    /// -------------------------------------

    function testTestModeAsNotOwner() public {
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        _Remilio64.setTestMode(true);
    }

    /// -------------------------------------
    /// 🔫 Rem64 Wars TESTING SUITE
    /// -------------------------------------

    function testAllRemsAlive() public {
        testMintOverflow(); // mint max
        for (uint256 i = 0; i < 9999; ++i) {
            //assertEq(_Remilio64.getRemAlive(i), true);
        }
    }

    function testAllRemsBounties() public {
        testMintOverflow(); // mint max
        for (uint256 i = 0; i < 9999; ++i) {
            //assertEq(_Remilio64.getRemBounty(i), 0);
        }
    }

    function testKillRem() public {
        testMintOverflow(); // mint max
        //_Remilio64.killRem(1);
        for (uint256 i = 0; i < 9999; ++i) {
            if (i == 1) {
                //assertEq(_Remilio64.getRemAlive(i), false);
            } else {
                //assertEq(_Remilio64.getRemAlive(i), true);
            }
        }
    }
}
