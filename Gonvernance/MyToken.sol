// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Nonces.sol";

// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4       owner
// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

// 0x0E486f7659e6802Ab27f9B40Ab7DaAc0FA479C3d       bizContract
// 0xe56539a500000000000000000000000000000000000000000000000000000000000003e8   calldata +1000
// 0xacd1e58dec2094c825c4d44ec5cea3ede410581aa38005e35fa0da68f34a5393  hash:"addcount"

contract MyToken is ERC20, ERC20Votes, ERC20Permit, Ownable{

    constructor () 
    ERC20("MyToken", "MTK")
    Ownable(msg.sender)
    ERC20Permit("MyToken"){

    }

    // the following 2funcs, are defined two or more in its inherited classes(pareant classes), 
    // here is ERC20, ERC20Votes, ERC20Votes's base ERC20. Similar to nonces()
    function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Votes) {
        super._update(from, to, value);  // erc20Votes _update will delegate coresponding vote units to the to_address at the same time as tokens are transferred.
    }
     function nonces(address owner) public view virtual override(ERC20Permit, Nonces) returns (uint256){
        return super.nonces(owner);
     }

    function mint(address to, uint amount) public virtual onlyOwner{
        if (delegates(to) == address(0)){
            _delegate(to, to); // if address_to has no delegatee, then delegate to itself. defined in {ERC20Votes->Votes}
        }
        _mint(to, amount); // tranfer token, defined in {ERC20}
    }
} 