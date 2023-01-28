// SPDX-License-Identifier: UNLICENSEDfugitivesfugitives
pragma solidity ^0.8.12;

import "../lib/forge-std/src/Test.sol";
import "../src/Remilio64.sol";
import "../src/RemWar.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RemWarTest is Test {
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
        vm.deal(_Remilio64.owner(), 100 ether);
        string
            memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey = vm.deriveKey(mnemonic, 0);
        someUser = vm.addr(privateKey);
        _Remilio64.setMintOpened(true);
        _Remilio64.setTestMode(true);
    }
}
