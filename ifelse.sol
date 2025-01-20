// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract IfElse{

    function ProcessNumber(uint x) external pure returns(string memory)
    {
        if (x < 10)
            return "number < 10";
        else if (x <= 20)
            return "10 <= number < =20";
        return "number > 20";
    }

    function ProcessNumber2(uint x) external pure returns(string memory)
    {
       return (x < 10) ? "number < 10" : ((x <= 20) ? ("10 <= number < =20") : ("number > 20"));
    }
}