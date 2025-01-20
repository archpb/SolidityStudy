// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

// 0xb09aa5aeb3702cfd50b6b62bc4532604938f21248a27a1d5ca736082b6819cc1  PROPOSER_ROLE = keccak256("PROPOSER_ROLE");
// 0xd8aa0f3194971a2a116679f7c2090f6939c8d4e01a2a8d7e41d55e5351469e63    keccak256("EXECUTOR_ROLE");
// 0x03204b633303d6b68cf82345d62a6c9397b7bb32f587d7acf428ae747ccbfaa5    keccak256("CANCELLER_ROLE");

// 0xacd1e58dec2094c825c4d44ec5cea3ede410581aa38005e35fa0da68f34a5393   description: keccak256("addcount");
// 45860104970045476609266204502792691353725495072535407933881148115530495350461  id

contract MyTimeLockGovernor is
    Governor,
    GovernorVotes,
    GovernorCountingSimple,
    GovernorTimelockControl,
    GovernorVotesQuorumFraction
{
    constructor (address tokenAddre, address timelock) 
    Governor("MyGovernor")
    GovernorVotes(IVotes(tokenAddre))
    GovernorTimelockControl(TimelockController(payable (timelock)))
    GovernorVotesQuorumFraction(4){

    }

    /**
     * @inheritdoc IGovernor
     */
    function votingDelay() public view  override returns (uint256){
        return 2;   // after 2 blocks 
    }

    /**
     * @inheritdoc IGovernor
     */
    function votingPeriod() public view  override returns (uint256){
        return 4; // duration is 2 blocks
    }

  
    // }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal  override(GovernorTimelockControl, Governor) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executeOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal  override(GovernorTimelockControl, Governor) {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    /**
     * @dev Address through which the governor executes action. Will be overloaded by module that execute actions
     * through another contract such as a timelock.
     */
    function _executor() internal view  override(GovernorTimelockControl, Governor) returns (address) {
        return super._executor();
    }

       /**
     * @dev Internal queuing mechanism. Can be overridden (without a super call) to modify the way queuing is
     * performed (for example adding a vault/timelock).
     *
     * This is empty by default, and must be overridden to implement queuing.
     *
     * This function returns a timestamp that describes the expected ETA for execution. If the returned value is 0
     * (which is the default value), the core will consider queueing did not succeed, and the public {queue} function
     * will revert.
     *
     * NOTE: Calling this function directly will NOT check the current state of the proposal, or emit the
     * `ProposalQueued` event. Queuing a proposal should be done using {queue}.
     */
    function _queueOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal  override(GovernorTimelockControl, Governor) returns (uint48) {
        return super._queueOperations(
             proposalId,
             targets,
             values,
             calldatas,
             descriptionHash
        );
    }

    /**
     * @dev See {IGovernor-proposalNeedsQueuing}.
     */
    function proposalNeedsQueuing(uint256) public view virtual override(GovernorTimelockControl, Governor) returns (bool) {
        return true;
    }

    /**
     * @dev See {IGovernor-state}.
     */
    function state(uint256 proposalId) public view virtual override(GovernorTimelockControl, Governor) returns (ProposalState) {
        return super.state(proposalId);
    }
}
