// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "hardhat/console.sol";


// 1. A call b with call(), check tx.origin and msg.sender
// 2. A delegate b , check 
// 3. A delegate b, b delegate C, check
contract Alpha {
    function cal(address _b, bytes memory _data) public  {
        console.log("A call B.");
        (bool success, ) = address(_b).call(_data);
        console.log("A call b return:", success);
    }

    function d_call(address _b, bytes memory _data) public  {
        console.log("A delegateCall B.");
        (bool success, ) = address(_b).delegatecall(_data);
        console.log("A delegateCall b return:", success);
    }

    // function d_callbc()

}

contract Bravo{
    function cal() public view{
        console.log("Bravo: tx.origin=", tx.origin);
        console.log("Bravo: msg.sender=", msg.sender);
    }

    function getData1() public  view returns(bytes memory){
        return abi.encodeCall(this.cal, ());
    }

    function getData2() public  view returns(bytes memory){
        console.log("Remix directly call Bravo:");
        console.log("Bravo: tx.origin=", tx.origin);
        console.log("Bravo: msg.sender=", msg.sender);
        return abi.encodeWithSelector(this.cal.selector);
    }

    function d_callc(address _addr, bytes memory _data) public  {
        console.log("Bravo delegateCall Charly:");
        console.log("Bravo: tx.origin=", tx.origin);
        console.log("Bravo: msg.sender=", msg.sender);
        _addr.delegatecall(_data);
        
    }

    function getcallCData(address _addr, bytes memory _data) public pure returns(bytes memory){
        return abi.encodeWithSelector(this.d_callc.selector, _addr, _data);
    }
}

contract Charly {
    function cal() public view{
        console.log("Charly: tx.origin=", tx.origin);
        console.log("Charly: msg.sender=", msg.sender);
    }

    function getData1() public  view returns(bytes memory){
        return abi.encodeCall(this.cal, ());
    }
}