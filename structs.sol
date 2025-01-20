// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyStruct{
    struct Vehicle{
        string make;
        uint year;
        address owner;
    }

    Vehicle[] public v;
    // uint[] public test1 = [1,2,3,4,5,6]; 

    function add(string memory _make, uint _year, address _owner) public {
        Vehicle memory temp = Vehicle(_make, _year, _owner); 
        v.push(temp);
    }

    // function getInfoByIdx(uint idx) public  view returns(Vehicle memory){
    //     return v[idx];
    // } 
    // function getAll() public  view returns(Vehicle[] memory){
    //     return v;
    // } 
    // function getTestAll() public  view returns(uint[] memory){
    //     return test1;
    // } 

    function getYearByMake(string memory _make) public view returns(Vehicle[] memory) {
        uint len = v.length;
        uint8 foundCnt = 0;
        bool found =  false;
        uint i;

        for(i = 0; i < len; ++i){
            if(keccak256(bytes(v[i].make)) == keccak256(bytes(_make))){
                found = true;
                foundCnt++;
            }  
        }
        assert(found ==  true);

        Vehicle[] memory outV = new Vehicle[](foundCnt);
        uint8 j = 0;
        for(i = 0; i < len; ++i){
            // make output
            if(keccak256(bytes(v[i].make)) == keccak256(bytes(_make))){
                outV[j++] = v[i];
            }  
        }
        
        return outV;
    }

    function getYearByOwner(address _owner) public view returns(Vehicle[] memory){
        uint len = v.length;
        uint8 foundCnt = 0;
        bool found =  false;
        uint i;

        for(i = 0; i < len; ++i){
            if(v[i].owner == _owner){    
                found = true;
                foundCnt++;
            }  
        }
        assert(found ==  true);

        Vehicle[] memory outV = new Vehicle[](foundCnt);
        uint8 j = 0;
        for(i = 0; i < len; ++i){
            // make output
            if(v[i].owner == _owner){ 
                outV[j++] = v[i];
            }  
        }
        
        return outV;
    }


}