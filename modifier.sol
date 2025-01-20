// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract modifierTest{
    int private m_number;

    modifier nonZero(){
        require(m_number != 0, "number is 0, execution is stopped.");
        _;
    }

    modifier addx(int x){
        if(x <= 0) revert("x should > 0");
        _;
    }

  modifier sandwich(int x, int y){
        if(x <= 0 || y <=0)    revert("x, y should both > 0");
        _;
        m_number += y;
    }

    function getNumber() external view returns(int){
        return m_number;
    }

    function setNumber(int x) external addx(x){
        m_number = x;
    }

    function doubleNumber() external nonZero {
        m_number *= 2;
    }

    function resetNumber() external nonZero {
        m_number = 0;
    }

    function changeNumber(int x, int y) external sandwich(x, y){
        m_number = x + y;
    }
}