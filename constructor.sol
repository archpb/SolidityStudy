// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyConstructor{
    uint public storedDate;
    address public owner;

    constructor(uint x){
        require(x > 100, "deploy shoud > 100");
        owner = msg.sender;
        storedDate = x;
    }

    function setData(uint x) external {
        storedDate = x;
    }

}