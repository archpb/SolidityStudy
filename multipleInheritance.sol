// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
layer of inheritance

        A
       / \
      B   C  
      |   |  
      |   D
       \ /
        Z

*/
contract A {
    uint public a1 = 11;
    uint internal  a2;
    uint private  a3;
    // uint public a4;
    function foo() public virtual  pure returns(string memory ret){
        return "A";
    }

    function bar() public  virtual pure returns(string memory ret){
        return "A";
    }

    function baz() public pure returns(string memory ret){
        return "A";
    }

    function dig() public  virtual pure returns(string memory ret){
        return "A";
    }

}

contract B is A {
    uint public a3;
    function foo() public  virtual override pure returns(string memory ret){
        return "B";
    }

    function bar() public  virtual override pure returns(string memory ret){
        return "B";
    }
    function dig() public  virtual  override pure returns(string memory ret){
        return "B";
    }
}

contract C is A {
    function foo() public  virtual override pure returns(string memory ret){
        return "C";
    }

    function dig() public  virtual override pure returns(string memory ret){
        return "C";
    }

}

contract D is C {


}

contract X is B, D {
    function foo() public override(B,C)   pure returns(string memory ret){
        return "X";
    }

    function bar() public  override(A,B)   pure returns(string memory ret){
        return "X";
    }

    function dig() public  override(B,C)  pure returns(string memory ret){
        return "X";
    }
}

