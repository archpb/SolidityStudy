// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract storeContract{
 

}
contract test{

     event sendCode2Proxy(bytes);
    event sendExecute2Proxy(bool);
    event getFuncData(bytes);

    // get the creation code of the conturct which needs to be deployed
    function getByteCode() public returns(bytes memory code){
        code = type(storeContract).creationCode;
        emit sendCode2Proxy(code);
    }


    function executeSet(address _contractAddr, uint _x) public payable  {
        bytes memory funcData = abi.encodeWithSignature("set(uint)", _x);
        emit getFuncData(funcData);
        (bool ret,) = _contractAddr.call{value: msg.value}(funcData);
        require(ret, "execute set() fail");
        emit sendExecute2Proxy(ret);

    }
        // test function selector generation and msg.data's content 
    // msg.data's type is bytes, the content is:
    // 0x8a1017ed       function selector
    // 000000000000000000000000000000000000000000000000000000000000000b     para1
    // 000000000000000000000000000000000000000000000000000000000000000c     para2
    // 000000000000000000000000bad6d077f18a13d1dde89354f4f1104ce8387c0d     para3
    function testMsgdata(uint _x, uint _y, address _z) public payable  {
        bytes memory funcData = abi.encodeWithSignature("set(uint256,uint256,address)", _x, _y, _z);
        emit getFuncData(funcData);
    }

    function getFuncSelector(string calldata _func) public  pure returns(bytes4){
        return bytes4(keccak256(bytes(_func)));
    }
}