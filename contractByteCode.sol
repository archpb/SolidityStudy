// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
    return(p, s) - end execution and return data from memory p to p + s
    mstore(p, v) - store v at memory p to p + 32
    PUSH1 0x2a  //60 2a
    PUSH1 0     //60 00
    MSTORE      //52

    Return 32 bytes from memory
    PUSH1 0x20  //60 20
    PUSH1 0     //60 00
    RETURN      //f3

    https://www.evm.codes/playground
    Run time code - return 42:
    602a60005260206000f3    // 10 bytes

    Creation code
    Store run time code to memory
    PUSH10 0x602a60005260206000f3   // 69 602a60005260206000f3
    PUSH1 0
    MSTORE
    0x00000000000000000000000000000000000000000000602a60005260206000f3
    Return 10 bytes from memroy starting at offset 22
    PUSH1 0x0a
    PUSH1 0x16
    RETURN
    69602a60005260206000f3600052600a6016f3  // 19bytes
    00000000000000000000000000000000000000000000000000000000000000ff
    0000000000000000000000000000000000000000000000000000000000000000
*/

contract factory{
    event deployOK(address addr);
    function deploy() external {
        
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        address addr;
        assembly{
            addr := create(0, add(bytecode, 0x20), 0x13) //var name bytescods is a pointer, bytes type var, first 32bytes is the number of its members, so skip 32 , add(bytecode, 0x20)
        }
        require(addr != address(0), "deploy fail");
        emit deployOK(addr);
         
    }
}

interface IWhatever {
    function whatever() external pure returns(uint);
}