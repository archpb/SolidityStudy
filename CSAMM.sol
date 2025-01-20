// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyCSAMM {
    event Swap(address indexed sender, uint token0In, uint token1In, uint token0Out, uint token1Out);

    // 2 types of token
    IERC20 private immutable token0;
    IERC20 private immutable token1;

    uint public reverse0;                           // token0's current liquidity
    uint public reverse1;                           // token1's current liquidity

    uint public totalSupplyShares;                  // this is total shares minted.
    mapping (address => uint) public balanceOf;     // shares of address

    constructor(address _tokenAddr0, address _tokenAddr1){
        token0 = IERC20(_tokenAddr0);
        token1 = IERC20(_tokenAddr1);

        // totalSupplyShares = token0.balanceOf(address(this)) + token1.balanceOf(address(this));  // wrong !
        // reverse0 = token0.balanceOf(address(this));     // add this for the case that deployer minted some token before deployment
        // reverse1 = token1.balanceOf(address(this));
    }

    function _mint(address _to, uint _amount) internal {
        totalSupplyShares += _amount;
        balanceOf[_to] += _amount;
    }
    function _burn(address _from, uint _amount) internal {
        totalSupplyShares -= _amount;
        balanceOf[_from] -= _amount;
    }
    function _updateLiquidity(uint _res0, uint _res1) internal {
        reverse0 = _res0;
        reverse1 = _res1;
    }
    function swap(address _token, uint _amountIn) external payable returns(uint){
        address payable  sender = payable (msg.sender);
        require(_token == address(token0) || _token == address(token1), "Token invalid");

        bool isToken0 = (_token == address(token0));
        (IERC20 tokenIn, IERC20 tokenOut) = isToken0 ? (token0, token1):(token1, token0);
        // (uint amountIn, uint amountOut) = isToken0 ? (_amountIn, _amountOut):(_amountOut, _amountIn);
        uint amountIn = _amountIn;
        uint resIn = isToken0 ? reverse0 : reverse1;

        // calculate out mount
        uint tmpIn;
        tokenIn.transferFrom(sender, address(this), amountIn);      // transfer token in
        tmpIn = tokenIn.balanceOf(address(this)) - resIn;
        uint amountOut = tmpIn * 997 / 1000;                             // fee: 0.003
        tokenOut.transfer(sender, amountOut);    // transfer token out  

        if (isToken0){
            reverse0 += amountIn;
            reverse1 -= amountOut;
            emit Swap(sender, amountIn, 0, amountOut, 0);
        }
        else{
            reverse0 -= amountOut;
            reverse1 += amountIn;
            emit Swap(sender, 0, amountIn, 0, amountOut);
        }
        return amountOut;

    }

    function addLiquidity(uint _amountIn0, uint _amountIn1) external payable returns(uint _share){
        address payable  sender = payable (msg.sender);

        // transfer toke in
        token0.transferFrom(sender, address(this), _amountIn0);
        token1.transferFrom(sender, address(this), _amountIn1);

        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        uint d0 = bal0 - reverse0;
        uint d1 = bal1 - reverse1;

        // calculate share
        /*
            a = amount in
            L = total liquidity
            s = shares to mint
            T = total supply 
            s should be proportional to increase from L to L + a
            (L + a) / L = (T + s) / T
            s = a * T / L
        */
        uint origRes0 = reverse0;
        uint origRes1 = reverse1;
        if(totalSupplyShares == 0){
            _share = d0 + d1;
        }
        else{
            _share = ((d0 + d1) * totalSupplyShares)/(origRes0 +  origRes1);
        }
        // update balance, total supply, reverse
        require(_share > 0, "shares < 0");          // if add too small , and total big enough, delta share may < 0
        _mint(sender, _share);
        _updateLiquidity(origRes0 + d0, origRes1 + d1);
    }

    function removeLiquidity(uint _share) external  payable returns(uint, uint){
        require(_share > 0 , " share should > 0");
       
        // calculate token out
        address payable sender = payable (msg.sender);
        uint bal = balanceOf[sender];
        require(_share <=  bal, "not enough shares to remove");
        
        /*
            a = amount out
            L = total liquidity
            s = shares
            T = total supply shares
            a / L = s / T
            a = L * s / T
            = (reserve0 + reserve1) * s / T
        */
        uint res0 = reverse0;
        uint res1 = reverse1;
        uint d0 = res0 * _share / totalSupplyShares;
        uint d1 = res1 * _share / totalSupplyShares;

        // transfer token out
        if (d0 > 0)
            token0.transfer(sender, d0);
        if (d1 > 0)    
            token1.transfer(sender, d1);
        // update liquidity
        _updateLiquidity(res0 - d0, res1 - d1);
        // burn shares
        _burn(sender, _share);

        return (d0, d1);

    } 

    // function getLiquidity() external view returns(uint , uint ){
    //     return (reverse0, reverse1);
    // }
}