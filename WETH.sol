// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// this contract is used for EOA transform their eth to my own coin WETH
contract WETH is ERC20{
    event WETH_Deposit(address indexed sender, uint amount);
    event WETH_Withdraw(address indexed receipient, uint amount);

    constructor() ERC20("Wapper Ether", "WETH"){}

    // define fallback for user's directly transfer eth without any function call
    fallback() external payable { 
        deposit();
    }     

    function deposit() public payable {
        // we set the WETH <=> ETH 's exchange rate, fow now we use 1:1
        // the send call this function with eth transfer, then we store eth and exchange to our WETH 
        address sender  = msg.sender;
        uint amount = msg.value;
        _mint(sender, amount);
        emit WETH_Deposit(sender, amount);
    }

    // the receipient call this to withdraw ether in wei
    // the correspoding WETH will be burned
    function withdraw(uint _amount) external payable {
        address payable receipient  = payable (msg.sender);
        _burn(receipient, _amount);  // burn first , then transfer ether to receipient to avoid re-entry attack
        receipient.transfer(_amount);

        emit WETH_Withdraw(receipient, _amount);
    }

    
}

contract MyERC20 is ERC20{
    constructor(string memory name, string memory symbol) ERC20(name, symbol){

    }

    function mint(address owner, uint amount) external {
        _mint(owner, amount);
    }

}