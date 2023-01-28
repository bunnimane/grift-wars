// SPDX-License-Identifier: MIT
// RemWar Contracts v0.2

pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IRem64.sol";

// Game Ownership
error TestModeOff();

// Rem alive status
error RemDead();

// Shot Price Checker
error InvalidShotPrice();
error PaidTooMuch();

// War not started
error WarNotStarted();
error WarStarted();
error WarOver();

contract RemWar is Ownable {
    /*
    /// -------------------------------------
    /// 🔫 Grift Wars
    /// -------------------------------------

    Premise: 
    
    - Each Remilio64 starts as ALIVE.

    - Each Remilio64 starts with a bounty of 0.

    - Each ALIVE Remilio64 can shoot someone with ether.

    - MIN bullet cost is 0.0005Ξ FOR SANITY.

    - NO friendly fire.

    - IF an ALIVE Remilio64 (A) is shot by an ALIVE REMILIO (B):
        - IF A's bounty is 0, it is DEAD. B's bounty increases
        to X where X is the amount of ETHER B shot A with.

        - IF A's bounty is not 0, A's bounty is subtracted by
        X * (X/A's bounty) where X is the the amount of ETHER B shot A with and
        added to B's bounty.
            SO:
            - B's bounty increases to X * (X/A's bounty).
            - IF A's new bounty is 0, it is DEAD.
            - IF A's new bounty is >0, it is still ALIVE with
            with old_bounty - (X * (X/A's bounty)).

            NOTE: The reason behind the shot not just subtracting,
            but instead subtracting a percentage is because 'whales' would 
            be to susceptible to getting ganged up on and there is 
            NO INCENTIVE for them. This makes it harder to take 
            down 'whales', but still provides value to higher
            valued shots. This seems to be most fair to me.

        - These bounty changes reflected in the FACTION_BOUNTY

        EVERYTIME A REMILIO KILLS ANOTHER REMILIO, IT'S KILL
        COUNT WILL INCREASE BY 1. THIS IS SIMPLY A VANITY METRIC
        BUT A COOL FLEX 💪.

    - There is a CUTOFF datetime when the war ends.

    AFTER THE CUT OFF DATE:

    - Each faction's TOTAL_BOUNTY is calculated.

    - The winning faction will consume the balances of every
    other faction's TOTAL_BOUNTY, leaving it with a FINAL_BOUNTY.

    - The 33% of the FINAL_BOUNTY is transferred to the dev team. 

    - 10% will go to EVERY REM64 on the winning faction who shot someone.

    - Each token in the winning faction's bounty, will serve as a
    claim on the (FINAL_BOUNTY * 0.57), proportional to (TOTAL_BOUNTY/TOKEN_BOUNTY).

    FIN.

    INCENTIVES: 
        - Because 10% of winnings is claimable by ANY shooters dead or alive on the
        winning faction, it encourages people to make at the very least the min shot.
        - Killing Remilio's stimulates gameplay because a dead remilio can't shoot and the holder would need to trade/buy a new one if they want to keep playing.
        - Killing Whale's has the same effect, incentivizes whales to re-enter.
        - People will want to jump factions, this stimulates trading.
        - People work together on a public strategy to kill particular factions.
        - Drives community, creates a lot of engagement, bringing attention to
        the project.
        - EMERGENT METAS FROM COMMUNITY, WHO KNOWS WHAT THESE WILL BE.

    NOTES:
        - The WAR will open with a specific cutoff time and date. This will not
          be modifiable. PERIOD. IT IS PROGRAMMED.
        - NO NEW ACTIONS will be permitted after the CUTOFF DATE.
        - CLAIMS will only be open after the CUTOFF DATE.
        - DEV will ONLY be able to access 33% stake once CUT OFF DATE IS REACHED.
        - Any funds in FINAL_BOUNTY will ONLY be accessible to Rem64 claims. Dev
          can never access these. As such there's a chance some ether is locked away permanently from never be claimed.




    RANDOM IDEAS:
        - If player attacked and not killed, dmg dealt should be 50%. This disincentivizes
          a group of small players from attacking a 'whale'.
        - Should be able to reinforce an ally. This will 'donate' bounty. This is useful for
          protecting whales, or 'storing faction value'.
        - 
    */

    // Initialization and constructor
    IRem64 Rem64;

    constructor(address rem64Address) {
        Rem64 = IRem64(rem64Address);
    }

    /// -------------------------------------
    /// ❌ Test Mode is just for automated
    ///    testing.
    /// -------------------------------------

    bool testModeOff = false;

    modifier notTestMode() {
        if (testModeOff == true) {
            revert TestModeOff();
        }
        _;
    }

    // One way function, rip 🪦
    function disableTestMode() public onlyOwner {
        testModeOff = true;
    }

    /// -------------------------------------
    /// 😵 Alive Or Dead
    /// -------------------------------------

    //ToDo: figure out what default value is and name accordingly;
    mapping(uint256 => bool) public remDead;

    function getRemDead(uint256 tokenId) public view returns (bool) {
        return remDead[tokenId];
    }

    // Owner override for killing Rem64, used for testing.
    function killRem(uint256 tokenId) public onlyOwner notTestMode {
        remDead[tokenId] = true;
    }

    // Function to kill Rem64 fr fr
    function killRemFr(uint256 tokenId) private {
        remDead[tokenId] = true;
    }

    /// -------------------------------------
    /// 💰 Bounties
    /// -------------------------------------

    // Token Bounty
    mapping(uint256 => uint256) public remBounty;

    function getRemBounty(uint256 tokenId) public view returns (uint256) {
        return remBounty[tokenId];
    }

    // Faction Bounty
    uint256[] public factionBounty = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    function getFactionBounty(uint256 index) public view returns (uint256) {
        return factionBounty[index];
    }

    // Owner override for checking RemBounty, used for testing.
    function changeRemBounty(uint256 tokenId, uint256 bounty)
        public
        onlyOwner
        notTestMode
    {
        remBounty[tokenId] = bounty;
    }

    /// -------------------------------------
    /// 🔫 Shooting
    /// -------------------------------------

    event Shot(uint256 shotta, uint256 target, uint256 amount);

    event Killed(uint256 shotta, uint256 target);

    // REMI64 KILL COUNT VANITY METRIC
    mapping(uint256 => uint256) public killCount;

    // MODIFIERS FOR SHOOTING
    modifier checkAlive(uint256 tokenId) {
        if (remDead[tokenId] == true) {
            revert RemDead();
        }
        _;
    }

    modifier minShotPrice(uint256 shotPrice) {
        if (shotPrice < 0.0005 ether) {
            revert InvalidShotPrice();
        }
        _;
    }

    // Helper functions to add/subtract from Rem64 and
    // associated faction.
    function addToBounty(uint256 tokenId, uint256 bounty) private {
        remBounty[tokenId] += bounty;
        factionBounty[Rem64.getFaction(tokenId)] += bounty;
    }

    function subFromBounty(uint256 tokenId, uint256 bounty) private {
        remBounty[tokenId] -= bounty;
        factionBounty[Rem64.getFaction(tokenId)] -= bounty;
    }

    // Helper function to add shooter to has shot list
    // and increment faction shooter counter
    mapping(uint256 => bool) public hasShot;

    uint256[] factionShooters = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    function shottaAdd(uint256 tokenId) private {
        if (hasShot[tokenId] = false) {
            hasShot[tokenId] = true;
            factionShooters[Rem64.getFaction(tokenId)];
        }
    }

    // REAL KILLAS 💧🩸 call this function
    // TODO: add check friendly fire
    function shootRem(uint256 shotta, uint256 target)
        public
        payable
        warOn
        warNotOver
        checkAlive(shotta)
        checkAlive(target)
        minShotPrice(msg.value)
    {
        uint256 shotPrice = msg.value;

        //Split payment
        FINAL_BOUNTY += (shotPrice * 57) / 100;
        SHOOTER_BOUNTY += (shotPrice * 10) / 100;
        DEV_TOTAL += (shotPrice * 33) / 100;

        // Initial check to see if rem
        // is instantly killed.
        if (remBounty[target] == 0) {
            killRemFr(target);
            emit Killed(shotta, target);
            addToBounty(shotta, shotPrice);
            killCount[shotta] += 1;
            shottaAdd(shotta);
            return;
        } else {
            // Branch that deals with real
            // killa logic.

            // Check to make sure you aren't
            // shooting more than the bounty
            // you can collect. This is good
            // guy 👮 code in case someone
            // snipes your target, or you
            // miscalculate.
            if (remBounty[target] < shotPrice) {
                revert PaidTooMuch();
            }

            // He's clapped 👏 but still moving.
            if (remBounty[target] > shotPrice) {
                subFromBounty(target, shotPrice);
                addToBounty(shotta, shotPrice);
                shottaAdd(shotta);
                emit Shot(shotta, target, shotPrice);
                return;
            }

            // Headshot 🎯
            if (remBounty[target] == shotPrice) {
                subFromBounty(target, shotPrice);
                addToBounty(shotta, shotPrice * 2);
                killRemFr(target);
                killCount[shotta] += 1;
                shottaAdd(shotta);
                emit Killed(shotta, target);
                return;
            }
        }
    }

    /// -------------------------------------
    /// 💣 WAR DECLARED
    /// -------------------------------------

    bool war = false;
    uint256 startDate;
    uint256 endDate;

    modifier warOn() {
        if (war == false) {
            revert WarNotStarted();
        }
        _;
    }

    modifier warNotOver() {
        if (war == true && block.timestamp > endDate) {
            revert WarOver();
        }
        _;
    }

    modifier warOff() {
        if (war == true) {
            revert WarStarted();
        }
        _;
    }

    modifier warNeverStarted() {
        if (endDate != 0) {
            revert WarStarted();
        }
        _;
    }

    function startWar(uint256 endingDate)
        public
        onlyOwner
        warOff
        warNeverStarted
    {
        startDate = block.timestamp;
        endDate = endingDate;
        war = true;
    }

    /// -------------------------------------
    /// 💣 WAR ENDED
    /// -------------------------------------

    // Variables to hold the paid totals for withdrawal;
    uint256 public FINAL_BOUNTY;
    uint256 public SHOOTER_BOUNTY;
    uint256 public DEV_TOTAL;

    // PUBLIC function anyone can call to end the
    // war. BUT it has to be called after the
    // official end date, and only if the war
    // is still on going. Consider this a
    // public service should dev team be unable
    // to call off the war.
    function endWarOfficially() public warOn {
        if (war == true && block.timestamp > endDate) {
            war = false;
        }
    }

    // WITHDRAW FOR DEV - 33%
    function withdrawDevWarProceeds() external onlyOwner warOff {
        require(address(this).balance > 0, "Nothing to release");
        (bool success, ) = payable(owner()).call{value: DEV_TOTAL}("");
        require(success, "withdraw failed");
    }

    // Modifier to ensure token's faction
    // won for a claim.
    modifier tokenWon(uint256 tokenId) {
        uint256 faction = Rem64.getFaction(tokenId);
        uint256 factionAmount = factionBounty[faction];

        for (uint256 i = 0; i < factionBounty.length; i++) {
            if (factionBounty[i] > factionAmount) {
                revert("Faction didn't win");
            }
        }
        _;
    }

    // modifier for SHOOTER CLAIM - 10%
    mapping(uint256 => bool) public shooterClaimed;

    modifier shooterClaimedCheck(uint256 tokenId) {
        if (shooterClaimed[tokenId] == true) {
            revert("Soldier already claimed");
        }
        _;
    }

    // modifier for SOLDIER CLAIM
    // FINAL BOUNTY * (FACTION BOUNTY/TOKEN BOUTNY)
    mapping(uint256 => bool) public soldierClaimed;

    modifier soldierClaimedCheck(uint256 tokenId) {
        if (soldierClaimed[tokenId] == true) {
            revert("Soldier already claimed");
        }
        _;
    }

    // Check to make sure caller owns the shooter to claim
    modifier shooterIsOwned(uint256 tokenId, address sender) {
        if (Rem64.ownerOf(tokenId) != sender) {
            revert("not owner of");
        }
        _;
    }

    // Claim 10% for having fired a shot and being on the
    // the winning faction
    function shooterClaim(uint256 tokenId)
        public
        tokenWon(tokenId)
        shooterClaimedCheck(tokenId)
        shooterIsOwned(tokenId, msg.sender)
    {
        uint256 numberOfShooters = factionShooters[Rem64.getFaction(tokenId)];
        uint256 withdrawAmount = ((SHOOTER_BOUNTY * numberOfShooters) / 100);

        (bool success, ) = payable(address(msg.sender)).call{
            value: withdrawAmount
        }("");

        shooterClaimed[tokenId] = true;
        require(success, "withdraw failed");
    }

    // Claim the full bounty the shooter has accumulated
    // throughout play
    function soldierClaim(uint256 tokenId)
        public
        warOff
        tokenWon(tokenId)
        soldierClaimedCheck(tokenId)
        shooterIsOwned(tokenId, msg.sender)
    {
        require(address(this).balance > 0, "Nothing to release");

        uint256 faction = Rem64.getFaction(tokenId);

        uint256 facBounty = factionBounty[faction];

        uint256 claimAmount = ((remBounty[tokenId] * 100) / facBounty);

        uint256 withdrawAmount = ((FINAL_BOUNTY * claimAmount) / 100);

        (bool success, ) = payable(address(msg.sender)).call{
            value: withdrawAmount
        }("");

        soldierClaimed[tokenId] = true;

        require(success, "withdraw failed");
    }
}
