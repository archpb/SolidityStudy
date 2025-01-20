
// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract MyVariables {

    // normal types
    bool public isTrue =  true;
    bool public bool0;
    int public myInt256_min = type(int).min;
    int public myInt256_max =  type(int).max;
    int public myInt = 0x11;

    int8 public myInt8 = -8;
    int16 public myInt16 = -16;
    int32 public myInt32 = -32;

    uint public myUInt256_min = type(uint).min;
    uint public myUInt256_max =  type(uint).max;
    uint public myUInt = 11-1;
    uint8 public myUInt8 = 8;
    uint16 public myUInt16 = 16;
    uint32 public myUInt32 = 32;
    // myInt = myInt32 - myInt16；

    // bytes32  256bits, eg: hash, private/pulick key
    function myFunction() public pure returns (bytes32) {
        bytes memory hash = abi.encodePacked("Hello, World!");
        
       return keccak256(abi.encodePacked(hash));
   }
    bytes32 public mybytes32 = myFunction();

    // address 160 bits , used for block-related operation address. interface address , eg: contract address
    address public myAddress = 0x3328358128832A260C76A4141e19E2A943CD4B6D;

    string public mystr = "1234567890.1234567890.1234567890.1234567890.";
    string public mystrNULL;
    // string public mystrAdd = "mystr" + "aaa";
    // string public mystrAdd2 = abi.encodePacked("mystr","aaa");  /* why? compile error */





}