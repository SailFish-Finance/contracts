// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "contracts/SwapHelperFacet2.sol";

//Deployed on Blast Sepolia
contract DeployLiq is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address deployer = 0x83E46e6E193B284d26f7A4B7D865B65952A50Bf2;
        address vc = 0x9902378119Ff0cd344381208215cDcC6304af580;
        address usdc = 0x128462fB43b1219Ab9B25C56CF05c87695d5a32a;

        SwapHelperFacet2 shf2 = SwapHelperFacet2(0xDfaa1F83Cd9657f4C12741B47c15C573867C30F0);

        shf2.addLiquidity(usdc, vc, false, 1 ether, 1 ether, 0, 0, deployer, block.timestamp + 1000000000);

        vm.stopBroadcast();
    }
}
