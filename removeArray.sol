// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// import "./arrayHelper.sol";

contract RemoveArray{
    // arrayHelper helperImp = new arrayHelper();
    uint[] public MyArray = [1,2,3,4,5,6];  

    // function show() public view returns(string memory){
    //     helperImp.showarrayDyn

    // }


    function removeEleByIdx(uint idx, bool keepOrder) public returns(uint len){
         // check input, 1) not empty array, 2) input index not exceed 
        len = MyArray.length;
        require(len > 0, "the array is empty, can't be removed.");
        require(idx <= len - 1, "Index is out of range.");       

        // src array len  = 1, directly pop
        if (len == 1)
            return len;

        uint i = idx;  
        if(keepOrder){
            // remove element specified by idx, keep the rest in order
            while (i < len - 1){
                MyArray[i] = MyArray[i+1];
            }
            MyArray.pop();
        }
        else{
            // remove element specified by idx, not keep the rest in order
            MyArray[i] = MyArray[len - 1 ];
            MyArray.pop();
        }
        return len;
    }


    function removeEleByIdx2(uint[] storage srcArray, uint idx, bool keepOrder) internal returns(uint[] memory){
        // check input, 1) not empty array, 2) input index not exceed 
        uint len = srcArray.length;
        require(len > 0, "the array is empty, can't be removed.");
        require(idx <= len - 1, "Index is out of range.");
        

        // src array len  = 1, directly pop
        if (len == 1)
            return srcArray;

        uint i = idx;        
        if(keepOrder){
            // remove element specified by idx, keep the rest in order
            while (i < len - 1){
                srcArray[i] = srcArray[i+1];
            }
            // srcArray.pop();
        }
        else{
            // remove element specified by idx, not keep the rest in order
            srcArray[i] = srcArray[len - 1 ];
            // srcArray.pop();
        }
        return srcArray;
        
        
    }


}