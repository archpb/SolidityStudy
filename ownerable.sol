// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyOwnerShip {
    uint public CallCount;
    address public Owner;

    constructor(){
        CallCount = 0;
        Owner = msg.sender;
    }

    modifier OnlyOwner(){
        require(Owner == msg.sender, "Only the owner can call this function.");
        _;
    }
    function OnlyOwnerCall() external OnlyOwner{
        //
    }
    function AnyOneCall() external pure{
        //
    }
    function transferOwnership(address newOwner) external OnlyOwner {
        require(newOwner != address(0), "NewOwner address can't be 0");
        require(newOwner != Owner, "NewOwner is the same as the old owner");
        Owner = newOwner;
    }
    function CallCountInc(bool resetCount) external {
        CallCount++;
        if(msg.sender == Owner  && resetCount == true){
            // require(Owner == msg.sender, "Only the owner can Reset the CallCount.");
            CallCount = 0;
        }
    }
}