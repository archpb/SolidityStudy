// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract TPUPProxy is TransparentUpgradeableProxy {
    constructor (address _logic, address initialOwner, bytes memory _data) payable  TransparentUpgradeableProxy(
        _logic, initialOwner, _data){

    }

    function getOwner() public view returns(address){
        return ProxyAdmin(_proxyAdmin()).owner();
    } 

    function getAdminProxy() public view returns(address){
        return _proxyAdmin();
    }

    function getImplement() public view returns (address){
        return _implementation();
    }

    receive() external payable { }
}
