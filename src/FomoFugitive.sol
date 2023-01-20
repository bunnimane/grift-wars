// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@ERC721A/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/* 
    ⠀⣤⣤⠀⠀⠀⠀⠀⠀⢠⣤⠀⠀⠀⠀⠀⠀⠀⠀ ⣤⡄⠀⠀⠀⠀⠀⠀⣤⣤⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀ ⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣠⣾⣿⣿⣷⣄⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⣿⣿⣿⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿🦹⣿🦹⣿⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⣿⣿⣿⣿⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⢿⣿⣿⣿⣿⡿⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⣙⣛⣛⣋⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⠀⠸⠿⠀⣿⣿⣿⣿⣿⣿ ⠿⠇⠀⠀⠀⠀⠀ ⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⢠⣶⡖⠂⠈⢻⣿⣿⡿⠁⠐⢲⣶⡄⠀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⠀⣿👮⡟⠛⠃⢸⣿⣿⡇⠘⠛⢻👮⣿⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⢀⠘⢿⣿⠟⢁⣼⣿⣿⣷⡀⠻⣿⡿⠃⡀⠀⠀⠀⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⣸⡇⢠⣤⠀⣿⣿⣿⣿⣿⣿⠀⣤⡄⢸⣇⠀⠀⠀ ⣿⣿⠀
    ⠀⣿⣿⠀⠀⠀⠀⣿⡇⢸⣿⠀⣿⣿⣿⣿⣿⣿⠀⣿⡇⢸⣿⠀⠀⠀⠀⣿⣿⠀
    ⠀⠛⠛⠀⠀⠀⠀⠛⠃⠘⠛⠀⠛⠛⠛⠛⠛⠛⠀⠛⠃⠘⠛⠀⠀⠀⠀⠛⠛⠀

    10,000 unique fugitives on the block chain

    10 factions of fugitives, divided equally.

    /// -------------------------------------
    /// 🪙 MINTING 
    /// -------------------------------------

    0.006Ξ mint
        - first 2000 mints are 0.003Ξ
        - last 2000 mints are 0.009Ξ
        - max 10 per tx

    **GAME STARTS WHEN MINTED OUT**

    /// -------------------------------------
    /// 🎮 GAME MECHANICS 
    /// -------------------------------------

    • Every 2 days there is a vote to kill
      off one of the factions. 🔫

    • Each vote costs 0.005Ξ.

    • AFTER 18 days (IF NO TIES), there will be 
      one faction left. They will be able to split 
      the VOTING POOL amongst themselves.

    *************************************************
    *             ⚠️⚠️IMPORTANT⚠️⚠️️                *
    *************************************************
    ** IF TWO OR MORE FACTIONS ARE TIED FOR VOTES  **
    **       THE GAME IS EXTENDED BY 2 DAYS        **    
    *************************************************

    ℹ️ - For a player who wants to vote every round,
          this will cost UP TO (0.045Ξ + 0.005Ξ)
                        = 0.05Ξ


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
    ╱    0.005*(10000-1000*n) ~= 275Ξ
    ‾‾‾        
    i = 0                 

    OR

    sum(0.005*(10000-1000*n)) where n=0 to 9 ~= 275Ξ

    = 275Ξ * 0.67 = 184.25Ξ

    ⚠️ TOTAL MAX POSSIBLE PRIZE POOL IS AROUND 184.25Ξ ⚠️

    ℹ️ - This means each remaining fugitive could be worth
        around ~0.184Ξ. This would make it about a ~3x 
        from a 0.05 cost to fully play or a ~30x from player 
        who just mints.

*/

contract FomoFugitive is ERC721A, Ownable {
    uint64 public immutable _maxSupply = 777;
    uint256 public price = 0.007 ether;
    uint256 public maxPerMint = 7;

    // image ipfs: ipfs://bafybeig44calwgq463zey2xycojswdxnm4efjgi7mckfr4vkstfy7oazoe/
    // json ipfs: ipfs://bafybeic3zfaptjliooe75ahpgjudssskm5p4tzpcwd3pozegvo2s7myfp4

    string private baseURI =
        "ipfs://bafybeic3zfaptjliooe75ahpgjudssskm5p4tzpcwd3pozegvo2s7myfp4/";

    constructor() ERC721A("FOMO FUGITIVES", unicode"FOMO 🦹") {}

    /*///////////////////////////////////
                    Mint
    //////////////////////////////////*/

    function mint(uint256 quantity) external payable {
        require(msg.value == price * quantity, "The price is invalid");
        require(quantity <= maxPerMint, "Too Many Minted");
        require(
            totalSupply() + quantity <= _maxSupply,
            "Maximum supply exceeded"
        );
        _mint(msg.sender, quantity);
    }

    function ownerMint(uint256 quantity) external payable onlyOwner {
        require(quantity <= maxPerMint * 5, "The price is invalid");
        require(
            totalSupply() + quantity <= _maxSupply,
            "Maximum supply exceeded"
        );
        _mint(msg.sender, quantity);
    }

    /*/////////////////////////////////////////////////////////////////////////////
        Below is the base URI stuff, it will point to the lyra server, which will
        be a proxy for more permanent storage solutions such as IPFS.
    /////////////////////////////////////////////////////////////////////////////*/

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _baseUri) public onlyOwner {
        baseURI = _baseUri;
    }

    /*///////////////////////////////////////////////////////////
        Withdraw function to get ether out of the contract
    ///////////////////////////////////////////////////////////*/

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "Nothing to release");
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "withdraw failed");
    }

    /*///////////////////////////////////////////////////////////
        Price
    ///////////////////////////////////////////////////////////*/

    function getPrice() public view returns (uint256) {
        return price;
    }

    function changePrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    /*///////////////////////////////////////////////////////////
        Token URI
    ///////////////////////////////////////////////////////////*/
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
