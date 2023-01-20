// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@ERC721A/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/* 
    ⠀⣤⣤⠀⠀⠀⠀⠀⠀⢠⣤⠀⠀⠀⠀⠀⠀⠀⠀ ⣤⡄⠀⠀⠀⠀⠀⠀⣤⣤⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀ ⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣠⣾⣿⣿⣷⣄⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⣿⣿⣿⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⣿⣿⣿⣿⣿ ⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⣿⣿⣿⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⢿⣿⣿⣿⣿⡿⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⣙⣛⣛⣋⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⠸⠿⠀⣿⣿⣿⣿⣿⣿ ⠿⠇⠀⠀⠀⠀⠀ ⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⢠⣶⡖⠂⠈⢻⣿⣿⡿⠁⠐⢲⣶⡄⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡟⠛⠃⢸⣿⣿⡇⠘⠛⢻⣿⣿⠀⠀   ⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⢀⠘⢿⣿⠟⢁⣼⣿⣿⣷⡀⠻⣿⡿⠃⡀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⣸⡇⢠⣤⠀⣿⣿⣿⣿⣿⣿⠀⣤⡄⢸⣇⠀⠀⠀ ⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⣿⡇⢸⣿⠀⣿⣿⣿⣿⣿⣿⠀⣿⡇⢸⣿⠀⠀⠀⠀⣿⣿⠀
    ⠀⠛⠛⠀⠀⠀⠀⠛⠃⠘⠛⠀⠛⠛⠛⠛⠛⠛⠀⠛⠃⠘⠛⠀⠀⠀⠀⠛⠛⠀

    10,000 unique fugitives on the block chain

    10 factions of fugitives, divided equally.

    /// -------------------------------------
    /// 🪙 MINTING 
    /// -------------------------------------


    - 0.006Ξ~ avg mint
        - first  2000 mints are FRΞΞ
        - middle 6000 mints are 0.006Ξ
        - last   2000 mints are 0.012Ξ
        - max 10 per tx

    **GAME BEGINS WHEN MINTED OUT**

    /// -------------------------------------
    /// 🎮 GAME MECHANICS 
    /// -------------------------------------

    • Every 2 days there is a vote to kill
      off one of the factions. 🔫

    • Each fugitive is eligible to lock in 1
      vote.

    • Each vote costs 0.006Ξ + 0.001Ξ * round.

    *************************************************
    *             ! !  IMPORTANT ! !                *
    *************************************************
    ** IF A FUGITIVE IS TRADED AFTER IT HAS VOTED  **
    **  IT'S VOTE WILL BE RESET AND THE NEW OWNER  **
    **      WILL BE ABLE TO PLACE A NEW VOTE       **    
    *************************************************

    • AFTER 18 days (IF NO TIES), there will be 
      one faction left. They will be able to split 
      the VOTING POOL amongst themselves.

    *************************************************
    *             ! !  IMPORTANT ! !                *
    *************************************************
    ** IF TWO OR MORE FACTIONS ARE TIED FOR VOTES  **
    **       THE GAME IS EXTENDED BY 2 DAYS        **    
    *************************************************

    ℹ️ - For a player who wants to vote every round,
          this will cost UP TO (0.069Ξ + 0.006Ξ)
                = 0.075Ξ per fugitive

    /// -------------------------------------
    /// ✔️ VOTING POOL
    /// ------------------------------------- 

    The Voting pool consists of 67% of the total 
    Ether collected from voting. The remaining 
    33% is transferred to the development team.


    THEORETICAL VOTING POOL:

     9                   
    ___           
    ╲     
    ╱   (0.006 + 0.0002*n)*(10000-1000*n) ~= 363Ξ
    ‾‾‾        
    i = 0                 

    OR

    sum(0.006*(10000-1000*n)) where n=0 to 9 ~= 363Ξ

    = 364Ξ * 0.67 ~= 243Ξ

    ! TOTAL MAX POSSIBLE PRIZE POOL IS AROUND 243Ξ !

    ℹ️ - This means each remaining fugitive could be worth
        around ~0.224Ξ. This would make it about a ~3x 
        from a 0.075 cost to fully play or a ~30x from player 
        who just mints at avg cost.

*/

contract FomoFugitive is ERC721A, Ownable {
    uint64 public immutable _maxSupply = 10000;
    uint256 public price = 0.006 ether;
    uint256 public maxPerMint = 10;
    bool public mintOpened = false;

    // image ipfs: ipfs://bafybeig44calwgq463zey2xycojswdxnm4efjgi7mckfr4vkstfy7oazoe/
    // json ipfs: ipfs://bafybeic3zfaptjliooe75ahpgjudssskm5p4tzpcwd3pozegvo2s7myfp4

    string private baseURI =
        "ipfs://bafybeic3zfaptjliooe75ahpgjudssskm5p4tzpcwd3pozegvo2s7myfp4/";

    constructor() ERC721A("FOMO FUGITIVES", "FUGI") {}

    /// -------------------------------------
    /// 🪙 MINTING
    /// -------------------------------------
    // - 0.006Ξ~ avg mint
    //     - first  2000 mints are FRΞΞ
    //     - middle 6000 mints are 0.006Ξ
    //     - last   2000 mints are 0.012Ξ
    //     - max 10 per tx
    //
    // ℹ️ - Be aware that some minters could
    //     could get fugitives at the prev
    //     tier price, if they are mitning
    //     over the boundries. Consider
    //     this an intended gift should it
    //     occur.

    function mint(uint256 quantity) external payable {
        // MINT MUST BE OPENED
        require(mintOpened == true, "THE MINT IS NOT LIVE");

        // SUPPLY BASED TIERS see ℹ️
        if (totalSupply() <= 1999) {
            // no require here, it's FRΞΞ!
        } else if (totalSupply() > 1999) {
            require(msg.value == price * quantity, "The price is invalid");
        } else if (totalSupply() > 7999) {
            require(msg.value == price * quantity * 2, "The price is invalid");
        }

        // QUANTITY RELATED
        require(quantity <= maxPerMint, "Too Many Minted");
        require(
            totalSupply() + quantity <= _maxSupply,
            "Maximum supply exceeded"
        );

        // GO TIME
        _mint(msg.sender, quantity);
    }

    /// -------------------------------------
    /// 🪙 OWNER MINT - One time use.
    /// -------------------------------------

    bool public ownerMinted = false;

    function ownerMint() external payable onlyOwner {
        require(ownerMinted == false, "OWNER U ALREADY MINTED U IDIOT");
        require(totalSupply() + 100 <= _maxSupply, "Maximum supply exceeded");
        ownerMinted = true;
        _mint(msg.sender, 100);
    }

    /// -------------------------------------
    /// 🏦 Withdraw
    /// -------------------------------------

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "Nothing to release");
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "withdraw failed");
    }

    /// -------------------------------------
    /// 💰 Price
    ///
    /// Hopefully this stuff will not be
    /// needed, but may have to reduce price
    /// if players aren't minting.
    /// -------------------------------------

    function getPrice() public view returns (uint256) {
        return price;
    }

    function changePrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    /// -------------------------------------
    /// 🔗 BASE URI and TOKEN URI
    /// -------------------------------------

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _baseUri) public onlyOwner {
        baseURI = _baseUri;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return string(abi.encodePacked(super.tokenURI(_tokenId), ".json"));
    }
}
