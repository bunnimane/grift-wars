// SPDX-License-Identifier: UNLICENSEDfugitivesfugitives
pragma solidity ^0.8.12;

import "../lib/forge-std/src/Test.sol";
import "../src/Remilio64.sol";
import "../src/RemWar.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract FomoFugitiveTest is Test {
    Remilio64 _Remilio64;
    RemWar _RemWar;
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
        _RemWar = new RemWar(address(_Remilio64));
        vm.deal(_RemWar.owner(), 200000 ether);
        vm.deal(_Remilio64.owner(), 200000 ether);
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
        uint256 quantity = 4;
        _Remilio64.mint{value: 0.002 ether * quantity}(quantity);
        assertEq(address(_Remilio64).balance, 0.002 ether * quantity);
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
        for (uint256 i = 0; i <= 4999; i++) {
            _Remilio64.mint{value: prices[0]}(1);
        }

        // Second Tier
        for (uint256 i = 5000; i <= 9999; i++) {
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
        _Remilio64.setWlStatus(true);
        _Remilio64.wl_mint(1);
        assertEq(_Remilio64.getFreeTokens(), 999);
    }

    function testWlMintLimit() public {
        _Remilio64.setWlStatus(true);
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

    function testFreeMintPerWallet() public {
        for (uint256 i = 0; i <= 999; i++) {
            someUser = vm.addr(i + 1);
            vm.deal(someUser, 0.001 ether);
            vm.prank(someUser);
            _Remilio64.mint{value: 0 ether}(1);
        }
        vm.expectRevert();
        someUser = vm.addr(10000);
        vm.deal(someUser, 0.001 ether);
        vm.prank(someUser);
        vm.expectRevert("No Free Mints Left");
        _Remilio64.mint{value: 0 ether}(1);
    }

    function testFreeMintCollision() public {
        for (uint256 i = 0; i <= 2; i++) {
            someUser = vm.addr(i + 1);
            vm.deal(someUser, 0.001 ether);
            vm.prank(someUser);
            _Remilio64.mint{value: 0 ether}(1);
        }
        someUser = vm.addr(1);
        vm.deal(someUser, 0.001 ether);
        vm.prank(someUser);
        vm.expectRevert("Free Mint Unavailable");
        _Remilio64.mint{value: 0 ether}(1);
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
        _Remilio64.mint{value: 0.002 ether}(1);
        _Remilio64.setFaction(0, 3);
        assertEq(_Remilio64.getFaction(0), 3);
        _Remilio64.setFaction(0, 2);
        assertEq(_Remilio64.getFaction(0), 2);
    }

    function testSetFactionAsNotOwner() public {
        _Remilio64.mint{value: 0.002 ether}(1);
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
        _Remilio64.mint{value: 0.002 ether * quantity}(quantity);
        _Remilio64.withdraw();
        assertEq(address(this).balance, oldBalance + contractBalance);
        assertEq(address(_Remilio64).balance, 0);
    }

    function testWithdrawAsNotOwner() public {
        uint256 quantity = 6;
        _Remilio64.mint{value: 0.002 ether * quantity}(quantity);
        vm.prank(someUser);
        vm.expectRevert("Ownable: caller is not the owner");
        _Remilio64.withdraw();
        assertEq(address(_Remilio64).balance, 0.002 ether * quantity);
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
        _Remilio64.mint{value: 0.002 ether * 7}(7);
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
            assertEq(_RemWar.getRemDead(i), false);
        }
    }

    function testAllRemsBounties() public {
        testMintOverflow(); // mint max
        for (uint256 i = 0; i < 9999; ++i) {
            assertEq(_RemWar.getRemBounty(i), 0);
        }
    }

    function testKillRem() public {
        testMintOverflow(); // mint max
        _RemWar.killRem(1);
        for (uint256 i = 0; i < 9999; ++i) {
            if (i == 1) {
                assertEq(_RemWar.getRemDead(i), true);
            } else {
                assertEq(_RemWar.getRemDead(i), false);
            }
        }
    }

    function testRemKillNew() public {
        testMintSuccess();
        _RemWar.startWar(block.timestamp + 382738273834734);
        _RemWar.shootRem{value: 0.001 ether}(0, 1);
        assertEq(_RemWar.getRemBounty(0), 0.001 ether);
        assertEq(_RemWar.getRemDead(1), true);
        assertEq(_RemWar.getRemDead(0), false);
        uint256 faction = _Remilio64.getFaction(0);
        assertEq(_RemWar.getFactionBounty(faction), 0.001 ether);
    }

    ///----------------------------------
    /// SHOT GAS TESTS 🔫
    ///----------------------------------
    function testKillNaked() public {
        uint256 shotAmount = 0.001 ether;
        _RemWar.startWar(block.timestamp + 382738273834734);
        testMintSuccess();
        _RemWar.shootRem{value: shotAmount}(0, 1);
        assertEq(_RemWar.getRemDead(1), true);
        assertEq(_RemWar.getRemDead(0), false);
    }

    ///----------------------------------
    /// STATIC SHOT TESTS 🔫
    ///----------------------------------

    function testHeadShotWithBounty() public {
        uint256 shotAmount = 0.001 ether;
        testMintOverflow();
        _RemWar.startWar(block.timestamp + 382738273834734);
        _RemWar.shootRem{value: shotAmount}(0, 1);
        _RemWar.shootRem{value: shotAmount}(2, 0);
        assertEq(_RemWar.getRemBounty(0), 0 ether);
        assertEq(_RemWar.getRemBounty(1), 0 ether);
        assertEq(_RemWar.getRemDead(1), true);
        assertEq(_RemWar.getRemDead(0), true);
        assertEq(_RemWar.getRemDead(2), false);
        uint256 faction1 = _Remilio64.getFaction(2);
        uint256 faction2 = _Remilio64.getFaction(0);
        assertEq(_RemWar.getFactionBounty(faction1), shotAmount * 2);
        assertEq(_RemWar.getFactionBounty(faction2), 0 ether);
    }

    function testShotNotKill() public {
        // Mint tokens
        testMintOverflow();
        
        // Start war
        _RemWar.startWar(block.timestamp + 382738273834734);

        // Take shots, 0->1, 2->0
        _RemWar.shootRem{value: 0.1 ether}(0, 1);
        _RemWar.shootRem{value: 0.05 ether}(2, 0);

        // Check shotee bounty and faction bounty
        assertEq(_RemWar.getRemBounty(0), 0.075 ether);
        uint256 faction2 = _Remilio64.getFaction(0);
        assertEq(_RemWar.getFactionBounty(faction2), 0.075 ether);

        // Check shotta bounty and faction bounty
        assertEq(_RemWar.getRemBounty(2), 0.075 ether);
        uint256 faction1 = _Remilio64.getFaction(2);
        assertEq(_RemWar.getFactionBounty(faction1), 0.075 ether);

        // Random dead checks
        assertEq(_RemWar.getRemDead(0), false);
        assertEq(_RemWar.getRemDead(1), true);
        assertEq(_RemWar.getRemDead(2), false);
    }

    function testShotNotKillNotRound() public {
        // Mint tokens
        testMintOverflow();
        
        // Start war
        _RemWar.startWar(block.timestamp + 382738273834734);

        // Take shots, 0->1, 2->0
        _RemWar.shootRem{value: 0.33 ether}(0, 1);
        _RemWar.shootRem{value: 0.1 ether}(2, 0);

        //console.logUint(_RemWar.getRemBounty(0));
        //console.logUint(_RemWar.getRemBounty(2));

        // Check shotee bounty and faction bounty
        assertEq(_RemWar.getRemBounty(0), 299696969696969697);
        uint256 faction2 = _Remilio64.getFaction(0);
        assertEq(_RemWar.getFactionBounty(faction2), 299696969696969697);

        // Check shotta bounty and faction bounty
        
        assertEq(_RemWar.getRemBounty(2), 130303030303030303);
        uint256 faction1 = _Remilio64.getFaction(2);
        assertEq(_RemWar.getFactionBounty(faction1), 130303030303030303);

        // Random dead checks
        assertEq(_RemWar.getRemDead(0), false);
        assertEq(_RemWar.getRemDead(1), true);
        assertEq(_RemWar.getRemDead(2), false);
    }

    function testShotInvalidAmount() public {
        testMintSuccess();
        vm.expectRevert();
        _RemWar.shootRem{value: 0.0012 ether}(0, 1);
    }

    ///----------------------------------
    /// FUZZ SHOT TESTS 🔫
    ///----------------------------------

    function testHeadShotWithBountyFuzz(uint256 shotMult) public {
        vm.assume(shotMult < 20000000);
        vm.assume(shotMult > 0);
        uint256 shot = 0.001 ether * shotMult;
        testMintOverflow();
        _RemWar.startWar(block.timestamp + 382738273834734);
        _RemWar.shootRem{value: shot}(0, 1);
        _RemWar.shootRem{value: shot}(2, 0);
        assertEq(_RemWar.getRemBounty(0), 0 ether);
        assertEq(_RemWar.getRemBounty(1), 0 ether);
        assertEq(_RemWar.getRemDead(1), true);
        assertEq(_RemWar.getRemDead(0), true);
        assertEq(_RemWar.getRemDead(2), false);
        uint256 faction1 = _Remilio64.getFaction(2);
        uint256 faction2 = _Remilio64.getFaction(0);
        assertEq(_RemWar.getFactionBounty(faction1), shot * 2);
        assertEq(_RemWar.getFactionBounty(faction2), 0 ether);
    }

    function testShotNotKillNotRound(uint256 a, uint256 b) public {
        vm.assume(a < 20000000);
        vm.assume(a > 0);
        vm.assume(b < 20000000);
        vm.assume(b > 0);

        vm.assume(b < a);

        uint256 shot1 = 0.001 ether * a;
        uint256 shot2 = 0.001 ether * b;

        // Mint tokens
        testMintOverflow();
        
        // Start war
        _RemWar.startWar(block.timestamp + 382738273834734);

        // Take shots, 0->1, 2->0
        _RemWar.shootRem{value: shot1}(0, 1);
        _RemWar.shootRem{value: shot2}(2, 0);

        //console.logUint(_RemWar.getRemBounty(0));
        //console.logUint(_RemWar.getRemBounty(2));

        // Check shotee bounty and faction bounty
        uint256 damage =  Math.mulDiv(shot2, shot2, shot1);

        assertEq(_RemWar.getRemBounty(0), shot1 - damage );
        uint256 faction2 = _Remilio64.getFaction(0);
        assertEq(_RemWar.getFactionBounty(faction2), shot1 - damage);

        // Check shotta bounty and faction bounty
        
        assertEq(_RemWar.getRemBounty(2), shot2 + damage);
        uint256 faction1 = _Remilio64.getFaction(2);
        assertEq(_RemWar.getFactionBounty(faction1), shot2 + damage);

        // Random dead checks
        assertEq(_RemWar.getRemDead(0), false);
        assertEq(_RemWar.getRemDead(1), true);
        assertEq(_RemWar.getRemDead(2), false);
    }

    ///----------------------------------
    /// FRIENDLY FIRE TEST 🔫
    ///----------------------------------

    function testFriendlyFire() public {
        _RemWar.startWar(block.timestamp + 382738273834734);
        testMintOverflow();
        uint256 faction1 = _Remilio64.getFaction(0);

        uint256 secondToken;

        for (uint256 i = 0; i < 9999; ++i) {
            if (_Remilio64.getFaction(i) == faction1) {
                secondToken = i;
                break;
            }
        }

        vm.expectRevert(NoFriendlyFire.selector);
        _RemWar.shootRem(secondToken, 0);
    }

    ///----------------------------------
    /// WITHDRAWAL TESTS 🔫
    ///----------------------------------

    ///----------------------------------
    /// DEV WITHDRAWL 🔫
    ///----------------------------------

    function testDevWithdrawl() public {
        testShotNotKillNotRound();
        // 0.43 total ether in contract
        uint256 oldBalance = address(this).balance;
        uint256 contractBalance = address(_RemWar).balance;

        vm.warp(block.timestamp + 782738273834739);
        _RemWar.endWarOfficially();
        _RemWar.withdrawDevWarProceeds();
        uint256 newBalance = address(this).balance;

        uint256 difference = newBalance - oldBalance;
        assertEq(difference, 0.1419 ether);
        assertEq(difference, Math.mulDiv(contractBalance, 33, 100));
    }

    // Dev double withdrawl
    function testDevDoubleWithdrawl() public {
        testDevWithdrawl();
        vm.expectRevert("Already Claimed");
        _RemWar.withdrawDevWarProceeds();

    }

    ///----------------------------------
    /// SHOOTER WITHDRAWL
    ///----------------------------------

    // Test withdrawing shooter withdrawal
    function testShooterWithdrawal() public {
        testShotNotKillNotRound();
        // 0.43 total ether in contract
        uint256 oldBalance = address(this).balance;

        vm.warp(block.timestamp + 782738273834739);
        _RemWar.endWarOfficially();
        _RemWar.shooterClaim(0);
        uint256 newBalance = address(this).balance;

        uint256 difference = newBalance - oldBalance;
        assertEq(difference, 0.043 ether);
    }

    function testShooterDoubleClaim() public {
        testShooterWithdrawal();
        vm.expectRevert("Already Claimed");
        _RemWar.shooterClaim(0);

    }

    // Test withdrawing losing faction
    function testLosingShooterWithdrawl() public {
        testShotNotKillNotRound();

        vm.warp(block.timestamp + 782738273834739);
        _RemWar.endWarOfficially();
        vm.expectRevert("Faction didn't win");
        _RemWar.shooterClaim(2);
    }

    ///----------------------------------
    /// SOLDIER WITHDRAWL
    ///----------------------------------

    // Soldier single claim
    function testSoldierWithdrawal() public {
        testShotNotKillNotRound();
        // 0.43 total ether in contract
        uint256 oldBalance = address(this).balance;

        vm.warp(block.timestamp + 782738273834739);
        _RemWar.endWarOfficially();
        _RemWar.soldierClaim(0);
        uint256 newBalance = address(this).balance;

        uint256 difference = newBalance - oldBalance;
        assertEq(difference, 0.2451 ether);
    }

    // Soldier double claim
    function testSoldierDoubleClaim() public {
        testSoldierWithdrawal();
        vm.expectRevert("Soldier already claimed");
        _RemWar.soldierClaim(0);
    }

    function testSoldierDidntWin() public {
        testShotNotKillNotRound();
        vm.warp(block.timestamp + 782738273834739);
        _RemWar.endWarOfficially();
        vm.expectRevert("Faction didn't win");
        _RemWar.soldierClaim(2);
    }

    ///----------------------------------
    /// TOTAL WITHDRAWL
    ///----------------------------------

    function testTotalWithdrawl() public {
        testShotNotKillNotRound();        

        vm.warp(block.timestamp + 782738273834739);
        _RemWar.endWarOfficially();
        _RemWar.withdrawDevWarProceeds();
        _RemWar.soldierClaim(0);
        _RemWar.shooterClaim(0);
        uint256 contractBalance = address(_RemWar).balance;

        assertEq(contractBalance, 0 ether);
    }

    ///----------------------------------
    /// Test Ties
    ///----------------------------------

    function testDraw() public {
        // Mint tokens
        testMintOverflow();
        
        // Start war
        _RemWar.startWar(block.timestamp + 382738273834734);

        // Take shots, 0->1, 2->0
        _RemWar.shootRem{value: 0.001 ether}(0, 1);
        _RemWar.shootRem{value: 0.001 ether}(2, 3);
        _RemWar.shootRem{value: 0.001 ether}(4, 10);
        _RemWar.shootRem{value: 0.001 ether}(5, 11);

        console.logUint(_RemWar.getPotentialWinnings(5));

        vm.warp(block.timestamp + 782738273834739);
        _RemWar.endWarOfficially();
        console.logUint(_Remilio64.getFaction(0));
        console.logUint(_Remilio64.getFaction(2));
        console.logUint(_RemWar.getWinningFactionCount());

        // test withdrawls of 0
        uint256 oldBalance = address(this).balance;
        _RemWar.soldierClaim(0);
        uint256 newBalance = address(this).balance;
        uint256 difference = newBalance - oldBalance;
        assertEq(difference, 0.000570 ether);

        // test withdrawls of 2
        oldBalance = address(this).balance;
        _RemWar.soldierClaim(2);
        newBalance = address(this).balance;
        difference = newBalance - oldBalance;
        assertEq(difference, 0.000570 ether);
    }

    ///----------------------------------
    /// Test Not Owner
    ///----------------------------------

    function testShooterNotOwned() public {
        testMintOverflow();
        _RemWar.startWar(block.timestamp + 382738273834734);
        vm.prank(someUser);
        vm.deal(someUser, 10 ether);
        vm.expectRevert("not owner of");
        _RemWar.shootRem{value: 0.001 ether}(0, 1);
    }

    function testTotalWithdrawlNoOwner() public {
        testShotNotKillNotRound();        

        vm.warp(block.timestamp + 782738273834739);
        _RemWar.endWarOfficially();
        vm.prank(someUser);
        vm.deal(someUser, 10 ether);
        
        vm.expectRevert("Ownable: caller is not the owner");
        _RemWar.withdrawDevWarProceeds();

        vm.prank(someUser);
        vm.expectRevert("not owner of");
        _RemWar.soldierClaim(0);

        vm.prank(someUser);
        vm.expectRevert("not owner of");
        _RemWar.shooterClaim(0);
    }
}
