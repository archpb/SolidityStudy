// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

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
    function foo() public    virtual override pure returns(string memory ret){
        return "B";
    }

    function bar() public    virtual override pure returns(string memory ret){
        return "B";
    }
}

contract C is B {
    function foo() public  override pure returns(string memory ret){
        return "C";
    }

    function dig() public  override pure returns(string memory ret){
        return "C";
    }

}