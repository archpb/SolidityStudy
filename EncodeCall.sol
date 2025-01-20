// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
interface IERC20 {
    function transfer(address, uint) external payable;
}

contract testCall{
    function transfer(address, uint) external  payable {

    } 
}
contract encodeCall{
    function test(address _contract, bytes memory _calldata) external {
        (bool ok, ) = _contract.call(_calldata);
        require(ok, "call fail");
    }

    function encodeWithSignature(address _to, uint _amount) public pure returns(bytes memory){
        return abi.encodeWithSignature("transfer(address,uint256)", _to, _amount);
    }
    function encodeWithSelector(address _to, uint _amount) public pure returns(bytes memory){
        return abi.encodeWithSelector(IERC20.transfer.selector, _to,_amount);
    }
    function encodeWithCall(address _to, uint _amount) public pure returns(bytes memory){
        return abi.encodeCall(IERC20.transfer, (_to,_amount));
    }
}