// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Counter{
    uint private  m_count;
    constructor(){
        m_count = 100;
    }

    function inc() external returns(uint){
        return m_count++;
    } 

    function dec() external returns(uint){
        return m_count--;
    }

    function getCount() external view returns(uint){
        return m_count;
    }
}