// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";


contract MyGovernor is
    Governor,
    GovernorVotes,
    GovernorCountingSimple,
    GovernorVotesQuorumFraction
{
    constructor (address tokenAddre) 
    Governor("MyGovernor")
    GovernorVotes(IVotes(tokenAddre))
    GovernorVotesQuorumFraction(4){

    }

    /**
     * @inheritdoc IGovernor
     */
    function votingDelay() public view virtual override returns (uint256){
        return 2;   // after 2 blocks 
    }

    /**
     * @inheritdoc IGovernor
     */
    function votingPeriod() public view virtual override returns (uint256){
        return 2; // duration is 2 blocks
    }

    /**
     * @inheritdoc IGovernor
     */
    // function quorum(uint256 timepoint) public view virtual override returns (uint256){

    // }
}
