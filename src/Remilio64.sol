// SPDX-tokenFactionLicense-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@ERC721A/ERC721A.sol";
import "@ERC721A/IERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@solady/utils/Base64.sol";

// Minting Errors
error MaxSupplyExceeded();
error TooManyMinted();
error PublicMintClosed();

// Game Ownership
error GameOwnerRevoked();

// Rem alive status
error RemDead();

// Shot Price Checker
error InvalidShotPrice();
error PaidTooMuch();

// War not started
error WarNotStarted();
error WarStarted();
error WarOver();

contract Remilio64 is ERC721A, Ownable {
    // Contracts for free mints
    address dollady = 0x233580FE8E1985127D1DaCF2a9EE342049b0Dad8;
    address remilio = 0xD3D9ddd0CF0A5F0BFB8f7fcEAe075DF687eAEBaB;
    IERC721A dolladyContract = IERC721A(dollady);
    IERC721A remilioContract = IERC721A(remilio);

    // Supply and Price info
    uint64 public immutable _maxSupply = 10000;
    uint256 public price = 0.007 ether;
    uint256 public maxPerMint = 30;

    /// -------------------------------------
    /// 🦹 FACTIONS
    ///
    ///    TEN FACTIONS that will be randomly
    ///    assigned on mint to the remilio 64s.
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
        return 1000 - ItalianMafia;
    }

    function getRussianMafia() public view returns (uint256) {
        return 1000 - RussianMafia;
    }

    function getChineseTriads() public view returns (uint256) {
        return 1000 - ChineseTriads;
    }

    function getColombianNarcos() public view returns (uint256) {
        return 1000 - ColombianNarcos;
    }

    function getMexicanCartels() public view returns (uint256) {
        return 1000 - MexicanCartels;
    }

    function getYakuza() public view returns (uint256) {
        return 1000 - Yakuza;
    }

    function getCosaNostra() public view returns (uint256) {
        return 1000 - CosaNostra;
    }

    function getIrishMob() public view returns (uint256) {
        return 1000 - IrishMob;
    }

    function getAlbanianMafia() public view returns (uint256) {
        return 1000 - AlbanianMafia;
    }

    function getHellsAngels() public view returns (uint256) {
        return 1000 - HellsAngels;
    }

    // This variable gets initialized in the constructor
    // and populated with the faction names.
    mapping(uint256 => string) public factionNames;

    function getFactionName(uint256 key) public view returns (string memory) {
        return factionNames[key];
    }

    // Int mapping of tokenID to faction ID
    mapping(uint256 => uint256) public tokenFaction;

    function getFaction(uint256 tokenId) public view returns (uint256) {
        return tokenFaction[tokenId];
    }

    // Human readable
    function getFactionString(uint256 key) public view returns (string memory) {
        return getFactionName(getFaction(key));
    }

    // This function uses pseudorandomness to choose
    // a faction that has remaining availability
    // and remove 1 from the availability and return
    // it to the CREATE DNA function, which assigns
    // the faction to the tokenFaction map.
    // the big 🧠 play is this function will MOST LIKELY
    // give a somewhat equal distribution of factions to a
    // minter. This means FACTION MAXI's will have to go to
    // secondary to get factions they want.
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
                            totalminted + i //we iterate
                        )
                    )
                ) %
                10;
        }
    }

    string private imgURI =
        "ipfs://bafybeig7jmw2nbbmbjhthyhscleq66gab5ivliwdlu6kwnetrxiemktll4/";
    string private baseURI = "http://127.0.0.1:8000/json/";

    constructor() ERC721A("Remilio64", "R64") {
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
    //    - 0.0046Ξ~ avg mint
    //      - Twitter interactions WL'd
    //      - Dollady holders get 5 free per dollady in wallet.
    //      - Remilio holders get up to 1 free per remilio in wallet.
    //      - first  1000 mints are 0.001Ξ
    //      - last 9000 mints are 0.005Ξ
    //      - max 30 per tx
    //
    // ℹ️ - Be aware that some minters could
    //     could get remilio64s at the prev
    //     tier price, if they are minting
    //     over the boundries. Consider
    //     this an intended gift should it
    //     occur.

    /// -------------------------------------
    /// 🪙 MINT MODIFIERS
    /// -------------------------------------

    modifier quantityCheck(uint256 quantity) {
        if (quantity > maxPerMint) {
            revert TooManyMinted();
        }
        _;
    }

    modifier maxSupplyCheck(uint256 quantity) {
        if (totalSupply() + quantity > _maxSupply) {
            revert MaxSupplyExceeded();
        }
        _;
    }

    modifier publicMintCheck() {
        if (mintOpened != true) {
            revert PublicMintClosed();
        }
        _;
    }

    /// -------------------------------------
    /// 🪙 PUBLIC MINT
    /// -------------------------------------
    bool public mintOpened = false;

    function getMintOpened() public view returns (bool) {
        return mintOpened;
    }

    function setMintOpened(bool tf) public onlyOwner {
        mintOpened = tf;
    }

    function mint(uint256 quantity)
        external
        payable
        quantityCheck(quantity)
        maxSupplyCheck(quantity)
        publicMintCheck
    {
        if (totalSupply() <= 999) {
            require(
                msg.value == 0.001 ether * quantity,
                "The price is invalid"
            );
        } else if (totalSupply() > 999) {
            require(msg.value == price * quantity, "The price is invalid");
        }

        mint_and_gen(quantity);
    }

    /// -------------------------------------
    /// 🪆 DOLLADY
    /// -------------------------------------

    mapping(address => bool) public dolladyMinted;

    bool public dolladyMintOpened = true;

    function getDolladyMintOpened() public view returns (bool) {
        return dolladyMintOpened;
    }

    function setDolladyMintOpened(bool tf) public onlyOwner {
        dolladyMintOpened = tf;
    }

    function mint_with_dollady() external payable {
        require(dolladyMinted[msg.sender] != true, "Wallet Already Minted");
        // get quantity
        uint256 quantity = remilioContract.balanceOf(msg.sender);
        require(quantity * 4 <= maxPerMint, "Too Many Minted");
        if (totalSupply() + quantity > _maxSupply) {
            revert MaxSupplyExceeded();
        }

        mint_and_gen(quantity * 2);
        dolladyMinted[msg.sender] = true;
    }

    /// -------------------------------------
    /// 🪙 REMILIO
    ///     I put a flag here to turn off
    ///     remilio minting, they said
    ///     they would promo if I allow it,
    ///     but if that falls through I turn
    ///     it off 🧀🐀 never truss an anon 🐍
    ///     https://imgur.com/a/32uVYSI
    /// -------------------------------------

    mapping(address => bool) public remilioMinted;

    bool public remilioMintOpened = true;

    function getRemilioMintOpened() public view returns (bool) {
        return remilioMintOpened;
    }

    function setRemilioMintOpened(bool tf) public onlyOwner {
        remilioMintOpened = tf;
    }

    function mint_with_remilio() external payable publicMintCheck {
        require(remilioMintOpened == true, "Remilio Mint Closed");
        require(remilioMinted[msg.sender] != true, "Wallet Already Minted");
        // get quantity
        uint256 quantity = remilioContract.balanceOf(msg.sender);
        require(quantity <= maxPerMint, "Too Many Minted");
        if (totalSupply() + quantity > _maxSupply) {
            revert MaxSupplyExceeded();
        }

        mint_and_gen(quantity);
        remilioMinted[msg.sender] = true;
    }

    /// -------------------------------------
    /// 🪙 MINT AND GEN FACTION
    /// -------------------------------------

    function mint_and_gen(uint256 quantity) private {
        uint256 totalminted = _totalMinted();
        uint256 newSupply = totalminted + quantity;
        _mint(msg.sender, quantity);
        for (; totalminted < newSupply; ++totalminted) {
            createDNA(totalminted);
        }
    }

    /// -------------------------------------
    /// 🪙 OWNER MINT
    /// -------------------------------------

    bool public ownerMinted = false;

    function ownerMint(uint256 quantity)
        external
        onlyOwner
        maxSupplyCheck(quantity)
    {
        // Mint and Generate Faction
        mint_and_gen(quantity);
    }

    /// -------------------------------------
    /// 🧬 CREATE DNA
    ///    Assigns a faction to newly minted
    ///    R64. Also tokenURI function to
    ///    return the faction and image.
    /// -------------------------------------

    function createDNA(uint256 totalminted) private {
        tokenFaction[totalminted] = subtractFromRandomFaction(totalminted);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721A)
        returns (string memory)
    {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
        string storage factionName = factionNames[tokenFaction[tokenId]];
        return
            string(
                abi.encodePacked(baseURI, factionName, "/", _toString(tokenId))
            );
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
