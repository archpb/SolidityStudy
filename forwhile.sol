// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract forwhile {
    function summation(uint n) external  pure returns(uint){
        uint sum = 0;
        for(uint i = 1; i<=n; ++i){
            sum += i;
        }
        return sum;
    }

}