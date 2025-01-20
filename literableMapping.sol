// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyLiterableMapping {

    mapping (address => uint) private  balances;
    mapping (address => bool) private inserted;
    address[] private  keys;

    function set(address _addr, uint _i) public {
        // input check , address 0 not allowed
        require(_addr != address(0), "address(0) is not allowed");

        // add/update to balances
        balances[_addr] = _i;

        // update inserted
        if(inserted[_addr] == false){
            inserted[_addr] = true;
            // update keys array
            keys.push(_addr);
        }
        else{
            // nothing to do
        }   
    }

    function removeKey(uint i) internal{
        uint len =  keys.length;
        assert(i <=  len - 1);
        keys[i] = keys[len - 1];
        keys.pop();

    }
    function del(address _addr) public {
        // check address inserted 
        require(inserted[_addr] == true, "address is not found.");
        delete balances[_addr]; // set to default
        inserted[_addr] = false;

        // find the address in keys and pop it
        bool found = false;
        for(uint i = 0; i<keys.length;++i){
            if (keys[i] == _addr){
                removeKey(i);
                found = true;
                break;
            }
        }
        assert(found == true);
    }

    function getSize() public view returns(uint){
        return keys.length;
    }

    function existed(address _addr) public view returns(bool){
        return inserted[_addr];
    }

    function getValueByAddr(address _addr) public view returns(uint){
        require(existed(_addr), "address not found.");
        return balances[_addr];
    }

    function getValueByIdx(uint _i) public view returns(uint){
        require(_i < keys.length, "index exceeds the range");
        return balances[keys[_i]];
    }

    function first() public  view returns(uint){
        require(keys.length > 0, "the balaces is empty.");
        return getValueByIdx(0); 
    }

    function last() public view returns(uint){
        require(keys.length > 0, "the balaces is empty.");
        return getValueByIdx(keys.length - 1);
    }





}   