// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract testClock{
    function getBlockNo() public returns(uint){
        return block.number;
    }
}