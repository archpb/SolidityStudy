// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ViewPureFunc {
    int public StateVar = 10;

    function PureFuncMiltiply(int a, int b) external pure returns(int){
        return a * b;
    }

    function ViewFuncStateVar()  external view returns(int){
        return StateVar;
    }
}