// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HelloWord {
    string public myStr = "Hi";
    string public myStr2;
    int[] public myArray = new int[](3);
    int public IntStateVar = 100;
    string public StrStateVar = "abc";

    // // function test(int _int, string memory _str, int[] memory _array) public returns(int){
    //     function test(string calldata _str) public returns(int[] memory){
    //     // int aa = _int;
    //     myStr =  _str;      // memory => stateVar(storage)  ok
    //     string memory memstr = myStr;   // storage => memory  ok
    //     myStr2 = myStr;     //  storage => storage  ok
    //     // int[] myArray 
    //     myArray[0] = 10;
    //     myArray[1] = 11;
    //     myArray[2] = 12;
    //     return myArray;
    // } 

    // function test2(int _int, string calldata _str) public returns(int[] memory){
    //     // int aa = _int;
    //     myStr =  _str;      // memory => stateVar(storage)  ok
    //     string memory memstr = myStr;   // storage => memory  ok
    //     myStr2 = myStr;     //  storage => storage  ok
    //     // int[] myArray 
    //     myArray[0] = 10;
    //     myArray[1] = 11;
    //     myArray[2] = 12;
    //     return myArray;
    // } 

    function testElementary(int  _i) public view returns(int){
        int  localIntVar = IntStateVar;
        // int  storage  localIntVar = IntStateVar;     // compile error, elementary var can't have datalocation 
        localIntVar = _i;
        return localIntVar;
    }

    // function testComplex(string memory  _str) public view{
    //     /* test memory type, result: the value is copied/cloned from the contract storage (from the state variable proposalCount) 
    //      to the local variable (on the stack). Any changes made to the local variable do not propagate to the contract storage. */
    //     // string memory strmemory = StrStateVar;
    //     // strmemory = _str;

    //     // test storage tye, 
    //     string storage strStorage = StrStateVar;
    //     strStorage = string("sdfasd");
    // }
}