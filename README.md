## Claim History Blockchain

The issue that our project is aiming to solve is to reduce the cost for insurance companies to verify whether the customer is "good" (with low probability of making a claim) or "bad" (with high probability of making a claim); and similarly, to reduce the admin cost customers have to incur to try to prove that they are "good", thereby gaining access to lower premium products than they otherwise would. 

Our project is a platform where customers can securely store their claim history with their current insurance provider, which  they would then be able to share with another insurer if they want to switch providers, and still be able to prove that they are good customers. Putting customers' claim history on the blockchain, where a claim can appear only if it has been approved by both the customer and their current provider, creates a system of permanent, verified and retroactively unmodifiable claims record, trusted by all insurers and customers as reflecting the truth.

The platform (a website) would have two sections:
1.       the first is where people can record their claims that will be recorded in the blockchain

2.       the insurer accepts or rejects the claim and it will be recorded in the blockchain

What we have built for now is the first half the project, which consists of a smart contract that has two main parts: one where customers can propose claims, and a second where insurers can either approve or reject the proposed claim.

# truffle-init-webpack
Example webpack project with Truffle. Includes contracts, migrations, tests, user interface and webpack build pipeline.

## Usage

To initialize a project with this example, run `truffle init webpack` inside an empty directory.

## Building and the frontend

1. First run `truffle compile`, then run `truffle migrate` to deploy the contracts onto your network of choice (default "development").
1. Then run `npm run dev` to build the app and serve it on http://localhost:8080

## Possible upgrades

* Use the webpack hotloader to sense when contracts or javascript have been recompiled and rebuild the application. Contributions welcome!

## Common Errors

* **Error: Can't resolve '../build/contracts/MetaCoin.json'**

This means you haven't compiled or migrated your contracts yet. Run `truffle compile` and `truffle migrate` first.

Full error:

```
ERROR in ./app/main.js
Module not found: Error: Can't resolve '../build/contracts/MetaCoin.json' in '/Users/tim/Documents/workspace/Consensys/test3/app'
 @ ./app/main.js 11:16-59
```
