// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "contracts/SwapHelperFacet2.sol";
import "contracts/lib/Token.sol";
import "contracts/pools/xyk/XYKPoolFactory.sol";

//Deployed on Blast Sepolia
contract DeployLiq is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        IERC20 usdc = IERC20(0x128462fB43b1219Ab9B25C56CF05c87695d5a32a);

        XYKPool edu_usdc_lp =
            XYKPoolFactory(0x86367e107aff49caB76593Be65242A0b1a803901).deploy(NATIVE_TOKEN, toToken(usdc));

        console.log("edu_usdc_lp: %s", address(edu_usdc_lp));

        vm.stopBroadcast();
    }
}
