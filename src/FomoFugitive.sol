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

    10,000 unique remilio64 fugitives on the 
    block chain. The grift thickens.

    10 factions of fugitives, divided equally.
    Faction assigned randomly to remilios.

    **GAME BEGINS WHEN MINTED OUT**

    /// -------------------------------------
    /// 🪙 MINTING 
    /// -------------------------------------

    - 0.007Ξ~ avg mint
        - first  1000 mints are FRΞΞ
        - middle 7000 mints are 0.007Ξ
        - last   2000 mints are 0.014Ξ
        - max 10 per tx

    /// -------------------------------------
    /// 🎮 GAME MECHANICS 
    /// -------------------------------------

    • Every 2 days there is a vote to kill
      off one of the factions. 🔫
tokenFaction
    • Each fugitive is eligible to lock in 1
      vote for a faction to kill off.

    • Each vote costs 0.006Ξ + (0.002Ξ * round)

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

    sum((0.006 + 0.0002*n)*(10000-1000*n)) where n=0 to 9 ~= 363Ξ

    = 364Ξ * 0.67 ~= 243Ξ

    ! TOTAL MAX POSSIBLE PRIZE POOL IS AROUND 243Ξ !

    ℹ️ - This means each remaining fugitive could be worth
        around ~0.224Ξ. This would make it about a ~3x 
        from a 0.075 cost to fully play or a ~30x from player 
        who just mints at avg cost.

*/

contract FomoFugitive is ERC721A, Ownable {
    uint64 public immutable _maxSupply = 10000;
    uint256 public price = 0.007 ether;
    uint256 public maxPerMint = 10;
    bool public mintOpened = false;

    // FACTIONS SET UP
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

    mapping(uint256 => string) public factionNames;

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

    string private baseURI =
        "ipfs://bafybeig7jmw2nbbmbjhthyhscleq66gab5ivliwdlu6kwnetrxiemktll4/";

    constructor() ERC721A("FOMO FUGITIVES", "FUGI") {
        factionNames[0] = "ItalianMafia";
        factionNames[1] = "RussianMafia";
        factionNames[2] = "ChineseTriads";
        factionNames[3] = "ColombianNarcos";
        factionNames[4] = "MexicanCartels";
        factionNames[5] = "Yakuza";
        factionNames[6] = "CosaNostra";
        factionNames[7] = "IrishMob";
        factionNames[8] = "AlbanianMafia";
        factionNames[9] = "HellsAngels";
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
    //     could get fugitives at the prev
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
    /// 🪙 CREATE DNA -
    ///    Assigns a faction to newly minted
    ///    R64. Also tokenURI function to
    ///    return the faction and image.
    /// -------------------------------------

    mapping(uint256 => uint256) public tokenFaction;

    function setValue(uint256 key, uint256 value) public {
        tokenFaction[key] = value;
    }

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
                            baseURI,
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
}
