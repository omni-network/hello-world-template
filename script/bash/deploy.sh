#!/usr/bin/env bash

# Note: Run from the root of the project

# Compile all contracts
forge build

# import env variables
source script/bash/.env.example

# Omni Deployment
export GLOBAL_GREETER_ADDRESS=$(forge script DeployGlobalGreeter --broadcast --rpc-url $OMNI_RPC_URL --private-key $PRIVATE_KEY | grep "Contract Address:" | awk '{ print $3 }')
echo "Deployed GlobalGreeter..."

# Optimism Deployment
export OP_ROLLUP_GREETER_ADDRESS=$(forge script DeployRollupGreeter --broadcast --rpc-url $OP_RPC_URL --private-key $PRIVATE_KEY | grep "Contract Address:" | awk '{ print $3 }')
echo "Deployed OP RollupGreeter..."

# Arbitrum Deployment
export ARB_ROLLUP_GREETER_ADDRESS=$(forge script DeployRollupGreeter --broadcast --rpc-url $ARB_RPC_URL --private-key $PRIVATE_KEY | grep "Contract Address:" | awk '{ print $3 }')
echo "Deployed ARB RollupGreeter..."

# Summary
echo "Deployment Summary:"
echo "Global Greeter Address: $GLOBAL_GREETER_ADDRESS"
echo "OP Rollup Greeter Address: $OP_ROLLUP_GREETER_ADDRESS"
echo "ARB Rollup Greeter Address: $ARB_ROLLUP_GREETER_ADDRESS"

# ----------------------------------------------------------------
## Development
# Testing the contracts - uncomment the following lines and copy them to your terminal to test the contracts
# ----------------------------------------------------------------

# export GLOBAL_GREETER_ADDRESS=0x8464135c8F25Da09e49BC8782676a84730C318bC
# export OP_ROLLUP_GREETER_ADDRESS=0x8464135c8F25Da09e49BC8782676a84730C318bC
# export ARB_ROLLUP_GREETER_ADDRESS=0x8464135c8F25Da09e49BC8782676a84730C318bC
# cast call $GLOBAL_GREETER_ADDRESS "lastGreet():(uint64,uint256,uint256,address,address,string)" --rpc-url $OMNI_RPC_URL
# cast send $GLOBAL_GREETER_ADDRESS "greet(string)" "testtest" --private-key $PRIVATE_KEY --rpc-url $OMNI_RPC_URL
# cast call $GLOBAL_GREETER_ADDRESS "lastGreet():(uint64,uint256,uint256,address,address,string)" --rpc-url $OMNI_RPC_URL
# cast send $OP_ROLLUP_GREETER_ADDRESS "greet(string)" "xtesttest" --private-key $PRIVATE_KEY --rpc-url $OP_RPC_URL --value 1ether
# sleep 5
# cast call $GLOBAL_GREETER_ADDRESS "lastGreet():(uint64,uint256,uint256,address,address,string)" --rpc-url $OMNI_RPC_URL
# cast send $ARB_ROLLUP_GREETER_ADDRESS "greet(string)" "xxtesttest" --private-key $PRIVATE_KEY --rpc-url $ARB_RPC_URL --value 1ether
# sleep 5
# cast call $GLOBAL_GREETER_ADDRESS "lastGreet():(uint64,uint256,uint256,address,address,string)" --rpc-url $OMNI_RPC_URL
# cast call $OP_ROLLUP_GREETER_ADDRESS "omniChainGreeter()(address)" --rpc-url $OP_RPC_URL
# cast call $ARB_ROLLUP_GREETER_ADDRESS "omniChainId()(uint64)" --rpc-url $OP_RPC_URL
