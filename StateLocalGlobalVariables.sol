// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract StateLocalGlobalVar {
    string public  StateStr = "stateString";
    int public a = 3;
    int public b = 0x10;

    function multiply(int x, int y) external pure returns(int) {
        int z =10;
        return x * y *z;
            } 

    function divide(uint x, uint y) external pure returns(uint) {
        return x / y;
    } 

    function multiplyBy_a(int x, int y) external view returns(int) {
        // int a = 100;    // local var temp overide the state var, with warning in compile 
        int z = 10;
        // int public  zz = 100;    //  can't declare state var in funtion.
        return x * y *z * a;
    } 

    function set_ab(int x, int y) external {
        a = x;  // state var can be modified in view/pure fundion.
        b = y;
    } 

    function getStrVar() external pure returns(string memory){
        // return StateStr;         // ok
        // return "aaa" + " bbb";   // operaor + not allowed in v0.8
        return string(abi.encodePacked("aaa", " bbb"));
    }

    function getGmtTime(uint timestamp) public pure returns(string memory){
            uint year = (timestamp / 31536000);
            uint month = ((timestamp % 31536000) / 2628000);
            uint day = (((timestamp % 31536000) % 2628000)) / 864000;
            uint hour = ((((timestamp % 31536000) % 2628000)) % 864000) / 360000;
            return string(abi.encodePacked("GMT", year, "-", month, "-", day," ",hour));
        }

    function GlobalInfoViewer() external view returns(address, uint, uint){
        address senderAddr = msg.sender;
        uint blockTimestap = block.timestamp;
        uint blocckNum = block.number;
        // string memory blockGMT = getGmtTime(blockTimestap);
        // return(msg.sender, block.timestamp, block.number);
        return(senderAddr, blockTimestap, blocckNum);
    }
}