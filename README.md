# dbilia-test Simple Custom NFT
## Assignment

In this project you will be using either truffle or hardhat to build a small minting smart contract.
We recommend you to use the solidity version ^0.8.0;

Dbilia app accepts payment both in USD and ETH for minting; and smart contract needs to track this information.

- When a user wants to pay in USD, user pays gas fee to Dbilia in advance; and Dbilia’s ethereum account will mint the token on the user’s behalf and will keep the token.
- When a user wants to pay in ETH, user himself (msg.sender) will mint and keep the token.

Create two minting functions in DbiliaToken.sol and make sure to emit an event.

- mintWithUSD()
  i. when we confirm the user has paid gas fee to Dbilia, we will trigger this function
  ii. Only Dbilia can trigger using a modifier
  iii. take four parameters (userId, cardId, edition, tokenURI)
  iv. add any require statements as much as possible
  v. create a mapping to track the owner of token using userId (because dbilia is minting on their behalf)
  vi. cardId and edition should be mapped to a mapping
  vii. mint
  viii. set token uri

- mintWithETH()
  i. take three parameters (cardId, edition, tokenURI)
  ii. add any require statements as much as possible
  iii. cardId and edition should be mapped to a mapping
  iv. mint
  v. set token uri
# Development

## Local environment

Add INFURA_PROJECT_ID, PRIVATE_KEY and ETHERSCAN_API_KEY at hardhat.config.js

```sh
yarn install
```

## Testing

```sh
npx hardhat test
```