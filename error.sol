// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract myerrors{
    uint public m_count = 10;
    
    function checkInput(uint x) external returns(uint){
        m_count++;
        require(x > 100, "input should > 100");
        return m_count;
    }

    function checkInWithRevert(uint x) external returns(uint){
        m_count +=100;
        if (x < 20 || x > 40){
            revert("input x should be 20 <= x <= 40");
        }
         return m_count;
    }

    function checkInWithAssert(uint x) external returns(uint){
        m_count += 1000;
        assert(x >= 50 && x <=60);
        return m_count;
    }

    function testAssert() public view{
        assert(m_count == 10);
    }
    error MyErr(address caller, bytes data, uint i);
    function testCostumError(uint x) public view{
        if (x > 100){
            revert MyErr(msg.sender, msg.data, x);
        }
    }
}