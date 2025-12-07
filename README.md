# Real Estate Marketplace on IOTA

## 📋 Overview

A decentralized real estate marketplace (DApp) built on IOTA blockchain using Move language for smart contracts.

## 🏗️ System Architecture

### Smart Contracts (Move)

1. **Property Contract** (`move/property/`)
   - Manage Property NFTs (representing real estate)
   - Create and update property information
   - Transfer ownership

2. **Marketplace Contract** (`move/marketplace/`)
   - Manage property listings
   - Handle buy/sell transactions
   - Collect transaction fees

3. **Escrow Contract** (`move/escrow/`)
   - Secure escrow for transactions
   - Protect both buyers and sellers
   - Automatic fund release

### Frontend (React + TypeScript)

- **CreateProperty.tsx**: Form to register new properties
- **PropertyList.tsx**: List of properties for sale
- **PropertyDetail.tsx**: Property details and purchase

## 🚀 Installation

### Requirements

- Node.js >= 18
- IOTA CLI
- WSL/Ubuntu (for Move commands)

### Step 1: Clone & Install

```bash
git clone <repo-url>
cd real-estate_exchange-iota_dapp
npm install
```

### Step 2: Build Smart Contracts

**Open WSL Ubuntu terminal** to run Move commands:

```bash
# Build Property contract
cd move/property
iota move build

# Build Marketplace contract
cd ../marketplace
iota move build

# Build Escrow contract
cd ../escrow
iota move build
```

### Step 3: Deploy Contracts

**In WSL Ubuntu:**

```bash
# Deploy each contract and save package ID
cd move/property
iota client publish --gas-budget 100000000

cd ../marketplace
iota client publish --gas-budget 100000000

cd ../escrow
iota client publish --gas-budget 100000000
```

### Step 4: Configure Frontend

Update `src/config.ts` with your deployed Package IDs:

```typescript
export const PACKAGE_IDS = {
  PROPERTY: "0xYOUR_PROPERTY_PACKAGE_ID",
  MARKETPLACE: "0xYOUR_MARKETPLACE_PACKAGE_ID",
  ESCROW: "0xYOUR_ESCROW_PACKAGE_ID",
};
```

### Step 5: Run Frontend

```bash
npm run dev
```

## 📝 User Guide

### For Sellers

1. Connect IOTA wallet
2. Go to "Register Property" tab
3. Fill in property details: title, description, location, price, area, type
4. Submit to create Property NFT

### For Buyers

1. Browse property listings
2. Click on a property to view details
3. Choose "Buy Now" or "Make Deposit"

## 🔧 Development

### Project Structure

```
real-estate_exchange-iota_dapp/
├── move/
│   ├── property/          # Property NFT contract
│   ├── marketplace/       # Marketplace contract
│   └── escrow/           # Escrow contract
├── src/
│   ├── App.tsx           # Main app
│   ├── CreateProperty.tsx
│   ├── PropertyList.tsx
│   └── PropertyDetail.tsx
└── package.json
```

### Roadmap

**✅ Phase 1 - MVP (Completed)**
- Basic smart contracts
- Property registration and listing UI/UX

**🚧 Phase 2 - Integration (In Progress)**
- Blockchain query integration
- Real buy/sell functionality
- Escrow workflow

**📋 Phase 3 - Advanced Features (Planned)**
- Property filtering and search
- Transaction history
- Rating & Review system
- IPFS image upload

## 🔐 Security

- Smart contracts thoroughly tested
- Escrow protects both buyers and sellers
- All transactions transparent on blockchain

---

## 📚 IOTA dApp Development Resources

### Install IOTA cli

Before deploying your move code, ensure that you have installed the IOTA CLI.
You can follow the
[IOTA installation instruction](https://docs.iota.org/developer/getting-started/install-iota) to get
everything set up.

This template uses `testnet` by default, so we'll need to set up a testnet
environment in the CLI:

```bash
iota client new-env --alias testnet --rpc https://fullnode.testnet.iota.org:443
iota client switch --env testnet
```

If you haven't set up an address in the iota client yet, you can use the
following command to get a new address:

```bash
iota client new-address --key-scheme secp256k1
```

This well generate a new address and recover phrase for you. You can mark a
newly created address as you active address by running the following command
with your new address:

```bash
iota client switch --address 0xYOUR_ADDRESS...
```

We can ensure we have some IOTA in our new wallet by requesting IOTA from the
faucet (make sure to replace the address with your address):

```bash
curl --location --request POST 'https://faucet.testnet.iota.org/gas' \
--header 'Content-Type: application/json' \
--data-raw '{
    "FixedAmountRequest": {
        "recipient": "<YOUR_ADDRESS>"
    }
}'
```

### Publishing the move package

The move code for this template is located in the `move` directory. To publish
it, you can enter the `move` directory, and publish it with the IOTA CLI:

```bash
cd move
iota client publish --gas-budget 100000000 counter
```

In the output there will be an object with a `"packageId"` property. You'll want
to save that package ID to the `src/constants.ts` file as `PACKAGE_ID`:

```ts
export const TESTNET_COUNTER_PACKAGE_ID = "<YOUR_PACKAGE_ID>";
```

Now that we have published the move code, and update the package ID, we can
start the app.

## Starting your dApp

To install dependencies you can run

```bash
pnpm install
```

To start your dApp in development mode run

```bash
pnpm dev
```

## Building

To build your app for deployment you can run

```bash
pnpm build
```
