Official repository of SailFish, a veDEX on EDUCHAIN

### Features

-   100% Protocol fees distributed to users
-   Efficient Swap Router
-   CLAMM Powered by Algebra Integra
-   Launchpad for Fair Launches on EDUCHAIN

```
forge build
forge test -vvvv
forge script script/deploy.educhain.sol:DeployScript --chain educhain --broadcast -vvvv
forge script script/deploy.educhain.sol:DeployScript --rpc-url https://open-campus-codex-sepolia.drpc.org --broadcast -vvvv 
```
