// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
// import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
// import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.1.0/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract UUPSBoxV1 is UUPSUpgradeable, OwnableUpgradeable  {
    uint private _count;

    receive() external payable { }
    function initialize(uint _x) public initializer {
        _count = _x;
        __Ownable_init(msg.sender);
    } 

    function getCount() external view returns(uint){
        return _count;
    }

    function cal() external returns(uint){
        return _count += 1;
    }
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner{
         // modifier checked
    } 

    function getOwner() external view returns(address){
        return owner();
    }
    function getThisAddr() external view returns(address){
        return address(this);
    }
    function getCaller() external view returns(address){
        return msg.sender;
    }
    function getInitCalldata(uint _x) external  pure returns(bytes memory){
        return abi.encodeWithSelector(this.initialize.selector, _x);
    }
}


contract UUPSBoxV2 is UUPSUpgradeable, OwnableUpgradeable  {
    uint private _count;

    receive() external payable { }
    function initialize(uint _x) public initializer {
        _count = _x;
        __Ownable_init(msg.sender);
    } 

    function getCount() external view returns(uint){
        return _count;
    }

    function cal() external returns(uint){
        return _count *= 2;
    }
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner{
         // modifier checked
    } 

    function getOwner() external view returns(address){
        return owner();
    }
    function getThisAddr() external view returns(address){
        return address(this);
    }
    function getCaller() external view returns(address){
        return msg.sender;
    }
    function getInitCalldata(uint _x) external  pure returns(bytes memory){
        return abi.encodeWithSelector(this.initialize.selector, _x);
    }
}

