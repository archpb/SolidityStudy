// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract storeContract{
    event executeSetEvent(uint);
    event executeGetEvent();

    uint public v;
    address public m_owner;
    constructor(){
        m_owner=msg.sender;
    }
    function set(uint _v) public {
        v = _v;
        emit executeSetEvent(_v);
    }
    function get() public returns(uint){
        emit executeGetEvent();
        return v;
    }
}

contract DeployProxy{
    // event 
    event deployEvent(address);
    address public addrDepolyed =  address(0);
    receive() external payable {}

    function deployContract(bytes memory _createCode) public payable  returns(address){
        // use creation code to deploy the contract
        address addr;
        assembly{
            // create(p,v,n)
            addr := create(callvalue(), add(_createCode, 0x20), mload(_createCode))
        }
        require(addr != address(0), "deploy failed.");

        // send event
        emit deployEvent(addr);
        addrDepolyed = addr;

        return addr;
    }

}

contract DeployAdmin{
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

