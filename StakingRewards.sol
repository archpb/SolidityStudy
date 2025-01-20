// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyStaking{
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public immutable owner;         // owner can add/remove rewords tokens
    uint public stakingTokensTotalSupply;   // sum of all the users' staking tokens

    uint public duration;       // rewords duration
    uint public updateAt;       // contract last update  time, in seconds
    uint public finishAt;       // rewords end time, in seconds    
    uint public rewardsRate;    // global rewards per second, TBD
    uint public rewardsPerTokenStored;      // RPT global rewords per token per  second, = rewardsRate / stakingTokens
                                            // every user has his own RPT, and RTP changes once staking poor changes. TBD
    mapping (address => uint) userRewardsPerTokenPaid;      // every user's RPT
    mapping (address => uint) userRewards;                  // every user's rewards earned.
    mapping (address => uint) userStakingTokens;            // every user's staking tokens.   balance

    constructor(address _stakingToken, address _rewardsToken){
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    modifier OnlyOwner(){
        require(owner == msg.sender, "Only owner is allowed.");
        _;
    }
    modifier NotDuringRewarding(){
        require(block.timestamp >= finishAt, " it can't be set during rewarding");
        _;
    }
    modifier updateRewards(address _account){
        rewardsPerTokenStored = rewardsPerToken();
        updateAt = _min(block.timestamp, finishAt);
        if(_account != address(0)){
            userRewards[_account] = earned(_account);
            userRewardsPerTokenPaid[_account] = rewardsPerTokenStored;
        }

        _;
    }


    /* owner set the rewards duration */
    /* only when rewards is expired, duration can be set*/
    function setDuration(uint _duration) external OnlyOwner NotDuringRewarding{
        duration = _duration;
    }

    /* owner set the total rewords tokens, caculater our rewards Rate*/
    /* it can be called, during rewarding or out of rewarding */
    /* duration should be set prior to this call */ 
    function setRewards(uint _rewordsAmount) external OnlyOwner updateRewards(address(0)){
        // check duration should have been set != 0
        uint newDuration = duration;
        require(newDuration != 0, "setRewards: set the duration first.");
        require(_rewordsAmount > 0, "setRewards: rewords amount = 0");
        
        // transfer rewwarding token in, 
        rewardsToken.transferFrom(owner, address(this), _rewordsAmount);
        uint balanceOfRewards = rewardsToken.balanceOf(address(this));


        // set rewardsRate, and check it > 0
        uint nowtime = block.timestamp;
        uint finishTime = finishAt;
        if (nowtime >= finishTime){
            rewardsRate = _rewordsAmount / newDuration;        
        }else {
            // rewardsRate = balanceOfRewards / (finishTime - nowtime);     // wrong: can't use balanceOf, because balanceOf contains 
                                                                            // the rewards which generated but not withdrawed
                                                                            // And, the duration time will be re-calculated and restarted,  
                                                                            // each time this function is called.
            rewardsRate = (rewardsRate * (finishTime - nowtime) +  _rewordsAmount ) / newDuration;      // last rewarding not finished
                                                                                                        // remaining rewards + newAddRewards
        }
        require(rewardsRate > 0, "setRewards: reword rate = 0");            // seems these 2 requires are impossible.
        require(rewardsRate * newDuration <= balanceOfRewards, "setRewards: rewards < balance");               


        // set finish time and start rewarding 
        // if (nowtime >= finishAt){
        //     finishTime = nowtime + duration;
        // }else{
        //     // finishTime = finishAt - nowtime + duration;           // wrong: Even if last rewarding not finished
        //                                                              // the finished time will be set for duration 
        //                                                              // from now on. 
        // }
        finishTime = nowtime + duration;

        // update reword
        finishAt = finishTime;
        updateAt = nowtime;
        // set global RPT
        // rewardsPerTokenStored = balanceOfRewards / stakingTokensTotalSupply / duration;     // TBD
        


    }

    /* user stake tokens*/
    function stake(uint _amount) external updateRewards(msg.sender){
        // check amount > 0
        // check now < finishAt
        // transfer staking token in
        // update total staking 
        // update user staking tokens balance
        // update user rewords 
        // update user rewards per token paid

        // update update At
        // 
        require(_amount > 0, "amount = 0");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        userStakingTokens[msg.sender] += _amount;
        stakingTokensTotalSupply += _amount;
    }

    /* user withdraw staking tokens*/
    function withdraw(uint _amount) external updateRewards(msg.sender) {
        // check amount > 0
        // transfer staking token out
        // update user staking tokens(balance)
        // update staking total supply

        // update user rewords paid
        // update user rewards per token paid
        // update updateAt

        require(_amount > 0, "amount = 0");
        userStakingTokens[msg.sender] -= _amount;
        stakingTokensTotalSupply -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function _min(uint x, uint y) private pure returns(uint z){
        return z = (x <= y) ? x : y;
    }
    function rewardsPerToken() public view returns(uint){
        if(stakingTokensTotalSupply == 0){
            return stakingTokensTotalSupply;
        }
        // userRewardsPerTokenPaid + R/T * (Time_end - Time_lastupdate)
        return rewardsPerTokenStored + (rewardsRate * (_min(finishAt, block.timestamp) - updateAt) / stakingTokensTotalSupply * 1e18);
        
    } 
    /* user query his own rewards tokens */
    function earned(address _account) public view returns(uint){
        // endtime Rj= min(now, finished)
        // earned duration  = lastupdate time (R0)- endtime(Rj)
        // earned = userStakingTokenBalance *（RewardsPerToken - RewardsPerTokenPaid[account]）+ userRewards[account]
        return userStakingTokens[_account] * (rewardsPerToken() - userRewardsPerTokenPaid[_account]) / 1e18 + userRewards[_account];
    }

    /* user withdraw his own rewords tokes */
    function getRewards() external updateRewards(msg.sender){
        uint rewards = userRewards[msg.sender];
        if(rewards > 0){
            rewardsToken.transfer(msg.sender, rewards);
            userRewards[msg.sender] = 0;
        }

    }

}