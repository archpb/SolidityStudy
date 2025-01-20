// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
/* 
Governor: The core contract that contains all the logic and primitives. It is abstract and requires choosing 
one of each of the modules below, or custom ones.

Votes modules determine the source of voting power, and sometimes quorum number.
GovernorVotes: Extracts voting weight from an ERC20Votes, or since v4.5 an ERC721Votes token.
GovernorVotesQuorumFraction: Combines with GovernorVotes to set the quorum as a fraction of the total token supply.

Counting modules determine valid voting options.
GovernorCountingSimple: Simple voting mechanism with 3 voting options: Against, For and Abstain.
GovernorCountingFractional: A more modular voting system that allows a user to vote with only part of its voting power, 
and to split that weight arbitrarily between the 3 different options (Against, For and Abstain).
*/
// Core:
import "@openzeppelin/contracts/governance/Governor.sol";
// Voting module:
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
// Counting Module:
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";

//extension:
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

// time lock
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

// others
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";


