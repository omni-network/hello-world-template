# Omni Hello World Template

This repository serves as a template for Ethereum smart contract development using Foundry, specifically designed for projects intending to utilize the Omni protocol for cross-chain interactions. The template features the `Greeter` and `GreetingBook` contracts as examples to demonstrate how contracts can interact across different blockchain networks.

## Installation

To use this template for your project, initialize a new project either by using `forge init` or cloning this repo::

```bash
forge init --template https://github.com/omni-network/hello-world-template.git
```

```bash
git clone --recursive https://github.com/omni-network/hello-world-template.git
git submodule update --init --recursive
```

## Usage

1. Run `make build` to build the smart contracts.
2. Run `make test` to run tests.

If you want to deploy the contracts agains a local devnet:

1. Run `make ensure-deps` to ensure you've installed the `omni` cli.
2. Run `make devnet-start` to deploy a local instance of Omni, which includes local deployments of Omni, Arbitrum, and Optimism.
3. Run `make deploy` to deploy your smart contracts.

Note: you'll need to have docker installed to run the local devnet.

When finished, you can run:

`make devnet-clean`
