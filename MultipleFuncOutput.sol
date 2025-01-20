// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MultipleFuncOutput{
    int public i;
    bool public b;
    string public s;

    function returnMultiple() public pure returns(int, bool, string memory) {
        return(1, false, "dummy");
    }

    function namedOutput() public pure returns(int ii, bool bb, string memory ss) {
        // return(2, true, "dummy named");
        ii = 2;
        bb = true;
        ss = "dummy named";
    }

    function captureOutputs() public {
        (i, b, s) = returnMultiple();
    }

    function displayOutputs() public view returns(int, bool, string memory){
        return(i, b, s);
    }
}