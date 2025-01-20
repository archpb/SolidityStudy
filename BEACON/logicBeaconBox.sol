// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
// import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.1.0/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";  // unnecessary, just for finding the src file to compile and deploy 
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";  // unnecessary, just for finding the src file to compile and deploy

contract BeaconBoxV1 is Initializable {
    uint private _count;

    receive() external payable { }
    function initialize(uint _x) public initializer {
        _count = _x;
    } 

    function getCount() external view returns(uint){
        return _count;
    }

    function cal() external returns(uint){
        return _count += 1;
    }

    function getInitCalldata(uint _x) external  pure returns(bytes memory){
        return abi.encodeWithSelector(this.initialize.selector, _x);
    }
}

contract BeaconBoxV2 is Initializable {
    uint private _count;

    receive() external payable { }
    function initialize(uint _x) public initializer {
        _count = _x;
    } 

    function getCount() external view returns(uint){
        return _count;
    }

    function cal() external returns(uint){
        return _count *= 2;
    }

    function getInitCalldata(uint _x) external  pure returns(bytes memory){
        return abi.encodeWithSelector(this.initialize.selector, _x);
    }
}
