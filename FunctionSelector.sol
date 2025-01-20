// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Receiver{
    // event DisplayMsgData(uint, uint8, uint32, uint64, string, address, bytes);
    event DisplayMsgData(bytes);
    event displayresults(bytes1[]);

    function recFunc(uint u256, 
    uint8 u8, 
    uint32 u32, 
    uint64 u64, 
    string memory inputstr, 
    address addr, 
    bytes memory inputbytes)

    
    external returns(uint , 
                uint8 , 
                uint32 , 
                uint64 , 
                string memory , 
                address , 
                bytes memory )
    {
        emit DisplayMsgData(msg.data);            

        return( u256, 
                 u8, 
                 u32, 
                 u64, 
                 inputstr, 
                addr, 
                inputbytes);
        
    }


    function test(bytes memory aa) external  {
        // bytes
        bytes1[] memory bb = new bytes1[](32);
        emit DisplayMsgData(aa);
        emit displayresults(bb);

    }
}

// event log:
// 0xc65bb0a3   funtion selecor
// 00000000000000000000000000000000000000000000000000000000000000fc para1 uint256
// 0000000000000000000000000000000000000000000000000000000000000008 para2 uint8
// 000000000000000000000000000000000000000000000000000000000000001f para3 uint32
// 000000000000000000000000000000000000000000000000000000000000003f para4 uint64
// 00000000000000000000000000000000000000000000000000000000000000e0 para5 ???
// 000000000000000000000000b1299b938ba41c213b2aeefd31efe3264cd50e10 para5 address 20bytes
// 0000000000000000000000000000000000000000000000000000000000000120  ???
// 0000000000000000000000000000000000000000000000000000000000000006 para6 string len
// 6161626263630000000000000000000000000000000000000000000000000000 para6 string content, 
// 0000000000000000000000000000000000000000000000000000000000000014 para7  bytes 20bytes 0x14
// b1299b938ba41c213b2aeefd31efe3264cd50888000000000000000000000000 para7 bytes content
// contract FunctionSelector {


// }