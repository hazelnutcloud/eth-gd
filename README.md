# Idle Chain

An on-chain idle game. Deposit your coins, earn rewards, level up your chain, win rare collectible NFTs. Withdraw your deposit anytime.

Built using the Godot game engine, powered by Chainlink.

## Tech stack

- [Godot](https://godotengine.org) - A open-source game engine. Godot is a powerful game engine that is licensed with the MIT license. It offers a lot of features and is very easy to use. It is also very lightweight and can be used to build games for all platforms. We chose Godot because it is open-source and it is very easy to use. We also wanted to build a game that can be played on mobile devices, and Godot is perfect for that.
- [eth-gd](https://github.com/hazelnutcloud/idle-chain/tree/main/godot/eth-gd) - An ethereum client library for the godot game engine. We developed this library ourselves during this Chainlink hackathon to fill a huge gap in the ecosystem and to enable us to build this game. We hope that with this library, more Web2 and Web3 developers alike will be interested in building games that leverage the power of the blockchain. It is still in early development, but it is already usable for simple use cases. Some features already included are JSON RPC client, ABI encoding/decoding, contract interactions and big number support. We will continue to develop this library and add more features to it.
- [Chainlink](https://chain.link) - A decentralized oracle network. Chainlink is a decentralized oracle network that provides reliable and secure data to smart contracts. We chose Chainlink no only because we are building for the Chainlink 2023 hackathon, but also because it is the most reliable oracle network in the blockchain space. We also wanted to build a game that is powered by the blockchain, and Chainlink is perfect for that. We used Chainlink's VRF to generate random numbers for the game. We also used Chainlink's Automation service to automate the routine on-chain tasks required by our game's smart contracts.