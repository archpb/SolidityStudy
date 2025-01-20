// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ConstantVar{

    // once deployed, the gas is fixed. Even between different deployments, the gase seems to be the same 

    address public constant MYADDR_CONST = 0x0000000000000000000000000000000000000001;                              // 418
    address public MyAddr = 0x0000000000000000000000000000000000000001;                                             // 2572

    bytes32 public constant MYBYTE32_CONST = 0x0000000000000000000000000000000000000000000000000000000000000002;    // 376
    bytes32 public  MyByte32 = 0x0000000000000000000000000000000000000000000000000000000000000002;                  // 2449

    string public constant MYSTR10 = "0123456789";                          // 717
    string public  MyStr10 = "0123456789";                                  // 3366

    string public constant MYSTR30 = "012345678901234567890123456789";      // 652
    string public  MyStr30 = "012345678901234567890123456789";              // 3410

    int public constant MYINT = 100;        // 369
    int public MyInt = 100;                 // 2492

    bool public constant MYBOOL = true;     // 397
    bool public MyBool = true;              // 2488

    int public constant MYUINT = 10000;     // 348
    int public MyUint = 10000;              // 2493

    function GetMyint() external view returns(int){return MyInt;}
    function GetMyintConst() external pure returns(int){return MYINT;}
    // function GetGasLeft() external view returns(uint){
    //     return msg.gasleft();
    // }
}