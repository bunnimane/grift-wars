// SPDX-tokenFactionLicense-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@ERC721A/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@solady/utils/Base64.sol";

/* 
    ⠀⣤⣤⠀⠀⠀⠀⠀⠀⢠⣤⠀⠀⠀⠀⠀⠀⠀⠀ ⣤⡄⠀⠀⠀⠀⠀⠀⣤⣤⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀ ⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣠⣾⣿⣿⣷⣄⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⣿⣿⣿⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿O⣿⣿O⣿  ⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
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

    10,000 unique rogue remilio64  on the 
    block chain. The grift thickens.

    10 factions of rogues, divided equally.
    Faction assigned randomly to remilios.

    **GAME BEGINS WHEN MINTED OUT**

    /// -------------------------------------
    /// 🪙 MINTING - Phase 1
    /// -------------------------------------

    - 0.0053Ξ~ avg mint
        - Twitter interactions WL'd
        - Dollady holders get 2 free per dollady.
        - Remilio holders get up to 1 free per wallet.
        - first  1000 mints are FRΞΞ
        - middle 7000 mints are 0.005Ξ
        - last   2000 mints are 0.009Ξ
        - max 20 per tx

        WL period will be about 2 days.
        Then public mint will open.
        

    /// -------------------------------------
    /// 🎮 VOTING GAME - Phase 2
    /// -------------------------------------

    • Days period X will be figured out by 
      twitter vote.

    • Every X days there is a vote to kill
      off one of the factions. 🔫

    • Each rogue is eligible to lock in 1
      vote for a faction to kill off.

    *************************************************
    *             ! !  IMPORTANT ! !                *
    *************************************************
    ** IF TWO OR MORE FACTIONS ARE TIED FOR VOTES  **
    **       THE GAME IS EXTENDED BY 2 DAYS        **    
    *************************************************

    • Each vote costs 0.004Ξ + (0.002Ξ * round).

    *************************************************
    *             ! !  IMPORTANT ! !                *
    *************************************************
    ** IF A ROGUE IS TRADED AFTER IT HAS VOTED     **
    **  IT'S VOTE WILL BE RESET AND THE NEW OWNER  **
    **    WILL BE ABLE TO PLACE A NEW VOTE. THE    **
    ** PREVIOUS OWNER WILL NOT BE ISSUED A REFUND. **    
    *************************************************

    • AFTER 9 rounds (IF NO TIES), there will be 
      ONE faction left. THIS IS THE CHOSEN FACTION
      WHO WILL HAVE ONE FINAL VOTE ON WHICH % OF
      THE SWEEP POOL GOES TO EACH MILADY 
      COLLECTION TO SWEEP.

    ℹ️ - For a player who wants to vote every round,
          this will cost UP TO (0.036Ξ + 0.005Ξ)
                = 0.041Ξ per rogue.

    /// -------------------------------------
    /// ✔️ SWEEP POOL - Phase 3
    /// ------------------------------------- 

    The SWEEP POOL consists of 67% of the total 
    Ether collected from VOTING. The remaining 
    33% is transferred to the development team.

    THEORETICAL SWEEP POOL:

     9                   
    ___           
    ╲     
    ╱   (0.004 + 0.0002*n)*(10000-1000*n) ~= 253Ξ
    ‾‾‾        
    i = 0                 

    OR

    sum((0.004 + 0.0002*n)*(10000-1000*n)) where n=0 to 9 ~= 253Ξ

    = 253Ξ * 0.67 ~= 169Ξ

    -> TOTAL MAX POSSIBLE SWEEP POOL IS APPROX 169Ξ

    ℹ️ - In reality it will likely be much lower since
        many tokens will not vote every single round. 

    ℹ️ - This means each remaining rogue has a max buying 
        power around ~0.169Ξ. This would make it about a ~4x 
        from a 0.041 cost to fully play or a ~35x from player 
        who just mints at avg cost.

    /// -------------------------------------
    /// 🧹 THE SWEEP - Phase 4
    /// ------------------------------------- 

    After 9 round of voting, there will be one
    faction left that's responsible to vote* on 
    this FINAL PROPOSAL. The options of the
    final proposal will be between the following 
    collections:

        - Milady Maker
        - Redacted Remilio Babies
        - Pixelady Maker
        - Ghiblady
        - Milady Station
        - Radbros
    
    *This vote will be free (minus cost of gas).

    *************************************************
    *             ! !  IMPORTANT ! !                *
    *************************************************
    ** IF A ROGUE IS TRADED AFTER IT HAS VOTED     **
    **  IT'S VOTE WILL BE RESET AND THE NEW OWNER  **
    **    WILL BE ABLE TO PLACE A NEW VOTE.        **
    *************************************************

    The percentage of votes for any option will directly
    map to the percentage of the SWEEP POOL used to 
    sweep that collection. This means multiple collections
    will be sweeped with various amounts of ether from
    the SWEEP POOL.

    Example: final votes look as follows

        - Milady Maker - 5%
        - RRB          - 30%
        - PL           - 10%
        - Ghiblady     - 10%
        - Milady Sta   - 20%
        - Radbros      - 25%

    And the sweep pool is theoretical max of ~169Ξ. This
    means each the above collections will get swept with:

        - Milady Maker - 8.45Ξ
        - RRB          - 50Ξ
        - PL           - 16.9Ξ
        - Ghiblady     - 16.9Ξ
        - Milady Sta   - 33.8Ξ
        - Radbros      - 42.25Ξ


    The NFT's that are swept will be locked in the contract
    account and unable to go back into circulation. So 
    effectively sweep floor + perma lock supply.


*/

contract FomoFugitive is ERC721A, Ownable {
    uint64 public immutable _maxSupply = 10000;
    uint256 public price = 0.007 ether;
    uint256 public maxPerMint = 10;
    bool public mintOpened = false;

    /// -------------------------------------
    /// 🦹 FACTIONS
    ///
    ///    TEN FACTIONS that will be randomly
    ///    assigned on mint to the rogue
    ///    remilio 64s.
    /// -------------------------------------

    uint256 public ItalianMafia = 1000;
    uint256 public RussianMafia = 1000;
    uint256 public ChineseTriads = 1000;
    uint256 public ColombianNarcos = 1000;
    uint256 public MexicanCartels = 1000;
    uint256 public Yakuza = 1000;
    uint256 public CosaNostra = 1000;
    uint256 public IrishMob = 1000;
    uint256 public AlbanianMafia = 1000;
    uint256 public HellsAngels = 1000;

    function getItalianMafia() public view returns (uint256) {
        return ItalianMafia;
    }

    function getRussianMafia() public view returns (uint256) {
        return RussianMafia;
    }

    function getChineseTriads() public view returns (uint256) {
        return ChineseTriads;
    }

    function getColombianNarcos() public view returns (uint256) {
        return ColombianNarcos;
    }

    function getMexicanCartels() public view returns (uint256) {
        return MexicanCartels;
    }

    function getYakuza() public view returns (uint256) {
        return Yakuza;
    }

    function getCosaNostra() public view returns (uint256) {
        return CosaNostra;
    }

    function getIrishMob() public view returns (uint256) {
        return IrishMob;
    }

    function getAlbanianMafia() public view returns (uint256) {
        return AlbanianMafia;
    }

    function getHellsAngels() public view returns (uint256) {
        return HellsAngels;
    }

    // This variable gets initialized in the constructor
    // and populated with the faction names.
    mapping(uint256 => string) public factionNames;

    // This function uses pseudorandomness to choose
    // a faction that has remaining availability
    // and remove 1 from the availability and return
    // it to the CREATE DNA function, which assigns
    // the faction to the tokenFaction map.
    function subtractFromRandomFaction(uint256 totalminted)
        public
        returns (uint256 faction)
    {
        uint256 randomIndex = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, totalminted)
            )
        ) % 10;
        uint256 i = 0;
        while (true) {
            if (randomIndex == 0 && ItalianMafia != 0) {
                ItalianMafia--;
                return randomIndex;
            } else if (randomIndex == 1 && RussianMafia != 0) {
                RussianMafia--;
                return randomIndex;
            } else if (randomIndex == 2 && ChineseTriads != 0) {
                ChineseTriads--;
                return randomIndex;
            } else if (randomIndex == 3 && ColombianNarcos != 0) {
                ColombianNarcos--;
                return randomIndex;
            } else if (randomIndex == 4 && MexicanCartels != 0) {
                MexicanCartels--;
                return randomIndex;
            } else if (randomIndex == 5 && Yakuza != 0) {
                Yakuza--;
                return randomIndex;
            } else if (randomIndex == 6 && CosaNostra != 0) {
                CosaNostra--;
                return randomIndex;
            } else if (randomIndex == 7 && IrishMob != 0) {
                IrishMob--;
                return randomIndex;
            } else if (randomIndex == 8 && AlbanianMafia != 0) {
                AlbanianMafia--;
                return randomIndex;
            } else if (randomIndex == 9 && HellsAngels != 0) {
                HellsAngels--;
                return randomIndex;
            }
            ++i;
            randomIndex =
                uint256(
                    keccak256(
                        abi.encodePacked(
                            block.timestamp,
                            block.difficulty,
                            totalminted + i
                        )
                    )
                ) %
                10;
        }
    }

    string private imgURI =
        "ipfs://bafybeig7jmw2nbbmbjhthyhscleq66gab5ivliwdlu6kwnetrxiemktll4/";
    string private baseURI =
        "ipfs://bafybeig7jmw2nbbmbjhthyhscleq66gab5ivliwdlu6kwnetrxiemktll4/";

    constructor() ERC721A("FOMO FUGITIVES", "FUGI") {
        // Set Faction names for readability
        factionNames[0] = "Italian Mafia";
        factionNames[1] = "Russian Mafia";
        factionNames[2] = "Chinese Triads";
        factionNames[3] = "Colombian Narcos";
        factionNames[4] = "Mexican Cartels";
        factionNames[5] = "Yakuza";
        factionNames[6] = "Cosa Nostra";
        factionNames[7] = "Irish Mob";
        factionNames[8] = "Albanian Mafia";
        factionNames[9] = "Hells Angels";
    }

    /// -------------------------------------
    /// 🪙 MINTING
    /// -------------------------------------
    // - 0.007Ξ~ avg mint
    //     - first  1000 mints are FRΞΞ
    //     - middle 7000 mints are 0.007Ξ
    //     - last   2000 mints are 0.014Ξ
    //     - max 10 per tx
    //
    // ℹ️ - Be aware that some minters could
    //     could get rogues at the prev
    //     tier price, if they are mitning
    //     over the boundries. Consider
    //     this an intended gift should it
    //     occur.

    function mint(uint256 quantity) external payable {
        // MINT MUST BE OPENED
        //require(mintOpened == true, "THE MINT IS NOT LIVE");

        // Whitelist logic goes here 🪆

        // SUPPLY BASED TIERS see ℹ️
        if (totalSupply() <= 999) {
            // no require here, it's FRΞΞ!
        } else if (totalSupply() > 999) {
            require(msg.value == price * quantity, "The price is invalid");
        } else if (totalSupply() > 7999) {
            require(msg.value == price * quantity * 2, "The price is invalid");
        }

        // QUANTITY RELATED
        //require(quantity <= maxPerMint, "Too Many Minted");
        require(
            totalSupply() + quantity <= _maxSupply,
            "Maximum supply exceeded"
        );

        // GO TIME
        uint256 totalminted = _totalMinted();
        uint256 newSupply = totalminted + quantity;
        _mint(msg.sender, quantity);
        for (; totalminted < newSupply; ++totalminted) {
            createDNA(totalminted);
        }
    }

    /// -------------------------------------
    /// 🧬 CREATE DNA -
    ///    Assigns a faction to newly minted
    ///    R64. Also tokenURI function to
    ///    return the faction and image.
    /// -------------------------------------

    mapping(uint256 => uint256) public tokenFaction;

    function getValue(uint256 key) public view returns (uint256) {
        return tokenFaction[key];
    }

    function createDNA(uint256 totalminted) private {
        tokenFaction[totalminted] = subtractFromRandomFaction(totalminted);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721A)
        returns (string memory)
    {
        string storage factionName = factionNames[tokenFaction[tokenId]];
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            '{"name": "#',
                            _toString(tokenId),
                            '", "image": "',
                            imgURI,
                            _toString(tokenId),
                            ".png",
                            '",',
                            '"attributes": [',
                            '{"faction": "',
                            factionName,
                            '"',
                            "}]}"
                        )
                    )
                )
            );
    }

    /// -------------------------------------
    /// 🪙 OWNER MINT - One time use.
    /// -------------------------------------

    bool public ownerMinted = false;

    function ownerMint() external payable onlyOwner {
        // Set Quantity
        uint256 quantity = 200;

        require(ownerMinted == false, "OWNER U ALREADY MINTED U IDIOT");
        require(
            totalSupply() + quantity <= _maxSupply,
            "Maximum supply exceeded"
        );

        // Mint and Generate Faction
        uint256 totalminted = _totalMinted();
        uint256 newSupply = totalminted + quantity;
        _mint(msg.sender, quantity);
        for (; totalminted < newSupply; ++totalminted) {
            createDNA(totalminted);
        }
        ownerMinted = true;
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
}
