// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract S{
    string name;
    constructor(string memory _name){
        name = _name;
    }
}

contract T{
    string textT;
    constructor(string memory _text){
        textT = _text;
    }
}

contract U is S("ssuu"), T{
    string textU;
    constructor(string memory _text) T(_text){
        textU = _text;
    }
}

contract BB is S("ssbb"),T("ttbb"){

}