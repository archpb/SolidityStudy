// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract arrayHelper {
    uint[] public StateDynamicArray;    // 1
    
    uint[3] public StateFixedArray;     // 2
    uint public lenDyn;
    uint public lenFix;
    uint[] public emptyArray;
    // uint[2][3] public aa = [[1u,2u,3],[4u,5u,6]]; /* solidity NOT support multi-dimensional arrays*/

    constructor(){
        StateDynamicArray =[11,22,33,44];
        StateFixedArray = [111,222,333];
        lenDyn = StateDynamicArray.length;
        lenFix = StateFixedArray.length;
        // emptyArray.push(55);
        // emptyArray.pop();

    } 

    function getEmptyArrayLength() external view returns(uint){
        return emptyArray.length;
    }

    function testStateArray() public returns(uint){
        StateDynamicArray[2] = 77; 
        StateDynamicArray.push(88);
        StateDynamicArray.push(99);
        StateDynamicArray.push(0);

        StateDynamicArray.pop();

        delete StateDynamicArray[0];
        delete StateFixedArray[1];

        StateDynamicArray[0] = 888;
        StateFixedArray[1] = 9999;
        uint len = StateDynamicArray.length; 

        lenDyn = StateDynamicArray.length;
        lenFix = StateFixedArray.length;
        return len;       
    }
   //这个函数用来连接两个字符串 'aaa' + 'bbb' =>  'aaabbb'
    function strConcat(string memory _a, string memory _b) public pure returns (string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ret = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(ret);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bret[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(ret);
    }    
    
    //这个函数最关键，比较取巧，用来将uint256类型的 0-9 数字转成字符
    function toStr(uint256 value) public pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";
        //这里把数字转成了bytes32类型，但是因为我们知道数字是 0-9 ，所以前面其实都是填充了0
        bytes memory data = abi.encodePacked(value);
        bytes memory str = new bytes(1);
        //所以最后一位才是真正的数字
        uint i = data.length - 1;
        str[0] = alphabet[uint(uint8(data[i] & 0x0f))];
        return string(str);
    }
    
    //调用这个函数，通过取模的方式，一位一位转换
    function uintToString(uint _uint) public pure returns (string memory str) {
 
        if(_uint==0) return '0';
 
        while (_uint != 0) {
            //取模
            uint remainder = _uint % 10;
            //每取一位就移动一位，个位、十位、百位、千位……
            _uint = _uint / 10;
            //将字符拼接，注意字符位置
            str = strConcat(toStr(remainder),str);
        }
 
    }

    function showarrayFix() public view returns(string memory){
        uint len = lenFix;
        string memory outStr;
        for (uint i = 0; i<len;++i){
            // outStr += "[" + string memory(StateDynamicArray[i]) + "[";
            outStr = strConcat(outStr, uintToString(StateFixedArray[i]));
            outStr = strConcat(outStr, "  ");

        }

        return outStr;  
    }
    function showarrayDyn() public view returns(string memory){
        uint len = lenDyn;
        string memory outStr;
        for (uint i = 0; i<len;++i){
            // outStr += "[" + string memory(StateDynamicArray[i]) + "[";
            outStr = strConcat(outStr, uintToString(StateDynamicArray[i]));
            outStr = strConcat(outStr, "  ");

        }

        return outStr;  
    }
}