// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract defaultValues{
    bool public b;  //false 0
    uint public u;  // 0
    int public i;   //0
    address public addr;    //0x000000...    40bytes
    bytes32 public b32;     // 0x0000...    64bytes
    string public str;      // null

    // local var default values
    function showLocalVarDef() external pure returns(bool, uint, int, address, bytes32, string memory){
        bool  bb;  //false 0
        uint  uu;  // 0
        int  ii;   //0
        address  aaddr;    //0x000000...    40bytes
        bytes32  bb32;     // 0x0000...    64bytes
        string memory sstr;      // null

        return(bb, uu, ii, aaddr, bb32, sstr);
    }
}