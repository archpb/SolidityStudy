// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "hardhat/console.sol";
contract tt{
//     string constant x5 = "hello world";

// address constant x6 = address(0);

// string immutable x7 = "hello world";

// address immutable x8 = address(0);
    // function transfer(address recipient, uint amount) external override returns (bool) {
    //     balanceOf[msg.sender] -= amount;
    //     balanceOf[recipient] += amount;
    //     emit Transfer(msg.sender, recipient, amount);
    //     return true;
    // }
    function calcSelector() public pure returns(bytes4)
    {   
            return bytes4(keccak256("transfer(address,uint256)"));  //0xa9059cbb
    }    
}

contract root{
    function foo() public pure virtual {
        console.log("root.foo");
    }

    function bee() public pure virtual  {
        console.log("root.bee");
    }
}

contract A1 is root{
    function foo() public pure virtual  override {
        super.foo();
        console.log("A1.foo");
    }

    function bee() public pure virtual  override {
        super.bee();
        console.log("A1.bee");
        console.log("-------------");
        foo();
        
    }
}



contract B1 is root, A1{
    function foo() public pure virtual override(A1, root){
        super.foo();
        console.log("B1.foo"); 
    }

    function bee() public pure virtual  override(A1,root) {
        super.bee();
        console.log("B1.bee");
        
    }
}