// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleBank{
    mapping (address => uint) public balances; // mapping can only be storage type
    mapping (string => uint) testMap;   // string can be the key
    address public owner;

    constructor(){
        owner = msg.sender;
        balances[owner] = 0;    // init account 0 money;
    }

    modifier  OnlyOwner(){
        require(owner == msg.sender, "Only owner ");
        _;
    }
    function deposit(uint money) public payable returns(uint){
        balances[msg.sender] += money;
        return balances[msg.sender];
    }

    function withdraw(uint amount) public payable returns(uint){
        require(amount <= balances[msg.sender],"You don't have enough money to withdraw.");
        balances[msg.sender] -= amount;
        return balances[msg.sender];
    } 

    function checkBalance() public view returns(uint){
        return balances[msg.sender];
    }

    function resetAllCount() public payable OnlyOwner{
        // can't be implemented, because mapping can't be literalted 
    }

    function test() public view returns(uint){
        mapping (address => uint ) storage books = balances; // mapping can only be used as a referrace, 
                                                            // mapping can't be reture value, or input para of a public/external function   
        return books[msg.sender];

    }
}