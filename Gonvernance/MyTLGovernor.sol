// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

contract MyTimelockGovernor is Governor, GovernorCountingSimple, GovernorTimelockControl, GovernorVotes, GovernorVotesQuorumFraction {
    constructor(
        IVotes _token, // 投票ERC20代币
        TimelockController _timelock,
        uint256 _quorumPercentage // 提案通过所需的票数百分比
    )
        Governor("MyTimelockGovernor") // 设置治理合约名称
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(_quorumPercentage)
        GovernorTimelockControl(_timelock)
    {}

    // 定义投票的延迟（以区块数为单位）
    function votingDelay() public pure override returns (uint256) {
        return 1; // 1 个区块延迟
    }

    // 定义投票的持续时间（以区块数为单位）
    function votingPeriod() public pure override returns (uint256) {
        return 45818; // 大约一周（以每秒13.14秒/块计算）
    }

    // 定义提案通过所需的最低票数
    function quorum(uint256 blockNumber)
        public
        view
        override(Governor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    // 支持Interface查询
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // 提案状态，用于时间锁兼容
    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    // 提案方法
    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    )
        public
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super.propose(targets, values, calldatas, description);
    }

    // 执行提案
    function execute(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        public
        payable
        override(Governor, GovernorTimelockControl)
        returns (uint256)
    {
        return super.execute(targets, values, calldatas, descriptionHash);
    }

    // 取消提案
    function cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        public
        override(GovernorTimelockControl)
    {
        return super.cancel(targets, values, calldatas, descriptionHash);
    }

    
    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal virtual override(GovernorTimelockControl, Governor) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executeOperations(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal virtual override(GovernorTimelockControl, Governor) {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    /**
     * @dev Address through which the governor executes action. Will be overloaded by module that execute actions
     * through another contract such as a timelock.
     */
    function _executor() internal view virtual override(GovernorTimelockControl, Governor) returns (address) {
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
    ) internal virtual override(GovernorTimelockControl, Governor) returns (uint48) {
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
