// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyStorage{
    struct  Test{
        string testStr;
        uint[] testArray;
    }

    Test public tt;
    string public a;

    function setStr(string memory _str)public {
        // string memory tmpStr = _str;
        // string storage t = tmpStr;
        // _setStr(_str); 
        a = _str;
        _setStr(a);  
        // tt.testStr = _str; 
    }

    function _setStr(string storage _str) internal {
        tt.testStr = _str;
    }
    function getArray(uint[] calldata _a) external pure returns(uint[] calldata){
        uint[] calldata tmparray = _a;
        return tmparray;
    }


}