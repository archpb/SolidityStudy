// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract BisContrat{
    uint public count;

    constructor(){count = 10;}

    receive() external payable { }

    function incCount(uint x) public payable  {
        count += x;
    }

    function showCalldata(uint x) public pure returns(bytes memory){
        return abi.encodeWithSelector(this.incCount.selector, x);
    }

}