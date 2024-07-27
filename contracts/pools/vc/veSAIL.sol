// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "contracts/interfaces/IVC.sol";
import "contracts/lib/RPow.sol";
import "contracts/pools/PoolWithLPToken.sol";
import "openzeppelin/utils/math/SafeCast.sol";
import "../SatelliteUpgradeable.sol";

interface IVotingEscrow {
    struct LockedBalance {
        int128 amount;
        uint256 end;
    }

    function locked(uint256) external view returns (LockedBalance memory);
}

contract VeSail is PoolWithLPToken, ISwap, SatelliteUpgradeable {
    event MigratedNFT(uint256 indexed id, address indexed user, uint256 amount);
    event Lock(address indexed user, uint256 indexed amount);

    using UncheckedMemory for int128[];
    using TokenLib for Token;
    using SafeCast for uint256;
    using SafeCast for int256;

    IVC immutable vc;
    bool initialized;

    constructor(address selfAddr, IVault vault_, IVC vc_)
        Pool(vault_, selfAddr, address(this))
    {
        vc = vc_;
    }

    function initialize() external {
        if (!initialized) {
            PoolWithLPToken._initialize("Locked Sail", "veSAIL");
            initialized = true;
        }
    }


    function velocore__execute(address user, Token[] calldata tokens, int128[] memory r, bytes calldata)
        external
        override
        onlyVault
        returns (int128[] memory, int128[] memory)
    {
        uint256 iVeVC = _binarySearch(tokens, toToken(this));
        uint256 iVC = _binarySearch(tokens, toToken(IERC20(address(vc))));
        int128[] memory deltaPool = new int128[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            if (i == iVeVC) {
                continue;
            } else if (i == iVC) {
                require(r[i] >= 0, "SAIL cannot be withdrawn");
                deltaPool[iVC] += r.u(i);
                deltaPool[iVeVC] -= r.u(i);
                emit Lock(user, uint256(int256(r.u(i))));
                _simulateMint(uint256(int256(r.u(i))));
            } else {
                revert("unsupported token");
            }
        }
        return (new int128[](tokens.length), deltaPool);
    }

    function swapType() external view override returns (string memory) {
        return "veVC";
    }

    function listedTokens() external view override returns (Token[] memory ret) {
        ret = new Token[](1);
        ret[0] = toToken(vc);
    }

    function lpTokens() external view override returns (Token[] memory ret) {
        ret = new Token[](1);
        ret[0] = toToken(this);
    }

    function underlyingTokens(Token lp) external view override returns (Token[] memory) {
        return new Token[](0);
    }
}