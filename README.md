# 🏠 Real Estate Marketplace on IOTA

A decentralized real estate trading platform built on IOTA blockchain using Move smart contracts. Buy, sell, and trade properties securely with blockchain technology.

## 📍 Contract Addresses

**Network:** IOTA Testnet

| Contract | Package ID | Explorer |
|----------|-----------|----------|
| Property | `0x2ee861ccbdc2037ffa01250fdad78d94cd73f9e44b44cca5b82e249107a11edd` | [View](https://explorer.iota.cafe/object/0x2ee861ccbdc2037ffa01250fdad78d94cd73f9e44b44cca5b82e249107a11edd?network=testnet) |
| Marketplace | `0x3597f5c17be5057c4c1be4e2301d5af33bebcf5bb89d53d9c7e2d7a377525959` | [View](https://explorer.iota.cafe/object/0x3597f5c17be5057c4c1be4e2301d5af33bebcf5bb89d53d9c7e2d7a377525959?network=testnet) |
| Escrow | `0xa53a4b57043d12512180a661615ee81f1bfd9dd0fa93939e154b7cc39e8ae2f6` | [View](https://explorer.iota.cafe/object/0xa53a4b57043d12512180a661615ee81f1bfd9dd0fa93939e154b7cc39e8ae2f6?network=testnet) |
| Marketplace Object | `0xdba5c27664fd5eeb47d4277ab6996ea560826f7f93f5ce407df6388f73afa370` | [View](https://explorer.iota.cafe/object/0xdba5c27664fd5eeb47d4277ab6996ea560826f7f93f5ce407df6388f73afa370?network=testnet) |

## 📋 Description

Real Estate Marketplace is a blockchain-powered DApp that revolutionizes property trading on IOTA. Create property NFTs, list them on the marketplace, and execute secure transactions with built-in escrow protection. All transactions are transparent, immutable, and stored permanently on the blockchain.

## 🚀 Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

## 💡 How It Works

1. **Create Properties**: Mint property NFTs with metadata (title, location, price, area, images)
2. **List for Sale**: Create marketplace listings with custom pricing
3. **Secure Escrow**: Lock funds in escrow for safe transactions
4. **Transfer Ownership**: Automatic property transfer upon payment completion

Your property transactions are:
- **🔒 Immutable**: Once recorded, transaction history is permanent
- **🔐 Secure**: Blockchain-level security and encryption
- **🌐 Transparent**: All transactions visible on-chain
- **💰 Protected**: Escrow system protects both parties
- **⚡ Fast**: Near-instant transaction confirmations
- **🌍 Global**: Trade with anyone, anywhere

## ✨ Features

- 📝 **Property NFTs**: Tokenize real estate as NFTs
- 🏪 **Decentralized Marketplace**: P2P property trading
- 🔐 **Escrow Protection**: Secure fund holding during transactions
- 💰 **Automated Payments**: Smart contract-based settlements
- 📊 **Transaction History**: Complete on-chain audit trail
- 🌐 **Global Access**: Trade from anywhere with internet
- ⚡ **Low Fees**: Minimal transaction costs (5% marketplace fee)
- 🕰️ **Permanent Records**: Immutable ownership history

## 🏗️ Smart Contract Architecture

### 📁 Contract Structure (`move/`)

```
move/
├── property/           # Property NFT Management
│   ├── Move.toml      # Package configuration
│   └── sources/
│       └── property.move
├── marketplace/        # Trading Platform
│   ├── Move.toml
│   └── sources/
│       └── marketplace.move
└── escrow/            # Secure Transactions
    ├── Move.toml
    └── sources/
        └── escrow.move
```

### 🔷 1. Property Contract (`property.move`)

**Purpose**: Manages property NFTs representing real estate assets

**Key Responsibilities**:
- 🏠 Create property NFTs with complete metadata
- 💵 Update property pricing
- 🔄 Toggle availability status
- 👤 Transfer ownership between addresses
- 📢 Emit events for all property actions

**Core Functions**:
```move
create_property()       // Mint new property NFT
update_price()          // Change property price
update_availability()   // Mark as available/sold
transfer_property()     // Transfer to new owner
```

**Data Structure**:
```move
Property {
    id: UID,
    title: String,           // "Luxury Beach Villa"
    description: String,     // Full property details
    location: String,        // "123 Ocean Drive, Miami"
    price: u64,             // Price in IOTA
    area: u64,              // Area in square meters
    property_type: u8,      // 1=House, 2=Land, 3=Apartment
    is_available: bool,     // Trading status
    original_owner: address,
    image_url: String
}
```

### 🔷 2. Marketplace Contract (`marketplace.move`)

**Purpose**: Facilitates property buying and selling with fee collection

**Key Responsibilities**:
- 📋 Create and manage property listings
- 💳 Process purchase transactions
- 💰 Calculate and collect marketplace fees
- 🔄 Update listing status
- 👨‍💼 Admin fee withdrawal

**Core Functions**:
```move
create_marketplace()    // Initialize marketplace (admin only)
create_listing()        // List property for sale
purchase_property()     // Buy listed property
cancel_listing()        // Remove listing
update_listing_price()  // Update listing price
withdraw_fees()         // Admin withdraws collected fees
```

**Data Structures**:
```move
Marketplace {
    id: UID,
    fee_percentage: u64,        // e.g., 5 for 5%
    fee_balance: Balance<IOTA>, // Accumulated fees
    admin: address              // Admin address
}

Listing {
    id: UID,
    property_id: address,
    seller: address,
    price: u64,
    is_active: bool
}
```

**Transaction Flow**:
1. Seller creates listing → Property ID + Price
2. Buyer purchases → Sends IOTA payment
3. Marketplace deducts fee → 5% to platform
4. Seller receives → 95% of listing price
5. Listing marked inactive → Property sold

### 🔷 3. Escrow Contract (`escrow.move`)

**Purpose**: Provides secure escrow service protecting both parties

**Key Responsibilities**:
- 🔒 Lock buyer's payment securely
- ✅ Release funds upon confirmation
- ❌ Refund on cancellation
- 📊 Track transaction status
- ⏱️ Timestamp all actions

**Core Functions**:
```move
create_escrow()     // Lock funds in escrow
complete_escrow()   // Release to seller
cancel_escrow()     // Refund to buyer
buyer_confirm()     // Buyer confirms receipt
```

**Data Structure**:
```move
Escrow {
    id: UID,
    property_id: address,
    buyer: address,
    seller: address,
    amount: Balance<IOTA>,  // Locked funds
    status: u8,             // 0=Pending, 1=Completed, 2=Cancelled
    created_at: u64         // Timestamp
}
```

**Transaction Flow**:
1. Buyer creates escrow → Funds locked
2. Seller transfers property NFT → Off-chain or marketplace
3. Buyer confirms receipt → Calls `buyer_confirm()`
4. Funds released to seller → Automatic transfer
5. Escrow completed → Status updated

## 🛠️ Technical Stack

- **Frontend**: React 18, TypeScript, Vite
- **Blockchain**: IOTA Testnet
- **Smart Contracts**: Move Language
- **Wallet Integration**: @iota/dapp-kit
- **UI Framework**: Radix UI
- **Styling**: CSS Modules

## 📦 Installation & Deployment

### Prerequisites

- Node.js >= 18
- IOTA CLI
- WSL/Ubuntu (for Move commands)
- IOTA Wallet (Browser Extension)

### Step 1: Clone & Install

```bash
git clone https://github.com/tranzankhien/real_estate_market-study.git
cd real-estate_exchange-iota_dapp
npm install
```

### Step 2: Setup IOTA Environment

```bash
# Configure testnet
iota client new-env --alias testnet --rpc https://api.testnet.iota.cafe:443
iota client switch --env testnet

# Create wallet address
iota client new-address --key-scheme ed25519

# Request testnet tokens
# Visit: https://faucet.testnet.iota.cafe/
```

### Step 3: Build Smart Contracts

**Open WSL Ubuntu terminal:**

```bash
# Build all contracts
cd move/property && iota move build
cd ../marketplace && iota move build
cd ../escrow && iota move build
```

### Step 4: Deploy Contracts

```bash
# Deploy Property contract
cd move/property
iota client publish --gas-budget 100000000

# Deploy Marketplace contract
cd ../marketplace
iota client publish --gas-budget 100000000

# Deploy Escrow contract
cd ../escrow
iota client publish --gas-budget 100000000

# Initialize Marketplace
iota client call \
  --package <MARKETPLACE_PACKAGE_ID> \
  --module property_marketplace \
  --function create_marketplace \
  --args 5 \
  --gas-budget 10000000
```

### Step 5: Configure Frontend

Update `src/config.ts`:

```typescript
export const PACKAGE_IDS = {
  PROPERTY: "0x2ee861ccbdc2037ffa01250fdad78d94cd73f9e44b44cca5b82e249107a11edd",
  MARKETPLACE: "0x3597f5c17be5057c4c1be4e2301d5af33bebcf5bb89d53d9c7e2d7a377525959",
  ESCROW: "0xa53a4b57043d12512180a661615ee81f1bfd9dd0fa93939e154b7cc39e8ae2f6",
};

export const MARKETPLACE_OBJECT_ID = "0xdba5c27664fd5eeb47d4277ab6996ea560826f7f93f5ce407df6388f73afa370";
```

### Step 6: Run Application

```bash
npm run dev
# Open http://localhost:5173
```

## 📖 User Guide

### For Property Sellers

1. 🔌 **Connect Wallet**: Click "Connect Wallet" and approve connection
2. ➕ **Register Property**: Navigate to "Register Property" tab
3. 📝 **Fill Details**: 
   - Property title and description
   - Location address
   - Price in IOTA
   - Area in square meters
   - Property type (House/Land/Apartment)
   - Image URL
4. ✅ **Submit**: Create your Property NFT on blockchain
5. 📋 **List for Sale**: Create marketplace listing with your property

### For Property Buyers

1. 🔍 **Browse Listings**: View available properties
2. 👁️ **View Details**: Click property card for full information
3. 💰 **Purchase Options**:
   - **Buy Now**: Direct purchase with full payment
   - **Escrow**: Secure transaction with deposit
4. ✅ **Complete**: Confirm transaction in wallet
5. 🎉 **Ownership**: Property NFT transferred to your wallet

## 🔗 Contract Functions

### Property Contract
```move
create_property()       // Create new property NFT
update_price()          // Update property price
update_availability()   // Toggle sale status
transfer_property()     // Transfer ownership
get_*()                // Getter functions
```

### Marketplace Contract
```move
create_marketplace()    // Initialize marketplace
create_listing()        // Create property listing
purchase_property()     // Buy property
cancel_listing()        // Cancel listing
update_listing_price()  // Update price
withdraw_fees()         // Admin withdraw fees
```

### Escrow Contract
```move
create_escrow()    // Create escrow with deposit
complete_escrow()  // Release funds to seller
cancel_escrow()    // Cancel and refund buyer
buyer_confirm()    // Buyer confirmation
```

## 📚 Documentation

- 📖 [Smart Contracts Guide](move/README.md) - Detailed contract documentation
- 📝 [Deployment Guide](DEPLOY.md) - Step-by-step deployment
- 🧪 [Testing Guide](TESTING.md) - Contract testing instructions
- 📋 [Todo List](TODO.md) - Development roadmap

## 🌐 Learn More

- [IOTA Documentation](https://docs.iota.org/)
- [IOTA dApp Kit](https://sdk.iota.org/dapp-kit)
- [Move Language](https://move-language.github.io/move/)
- [IOTA Testnet Explorer](https://explorer.iota.cafe/?network=testnet)
- [IOTA Testnet Faucet](https://faucet.testnet.iota.cafe/)

## 🛡️ Security & Best Practices

- ✅ Smart contracts audited and tested
- 🔐 Escrow system protects all parties
- 📊 All transactions transparent on-chain
- 🔒 Immutable ownership records
- ⚡ Atomic transaction execution
- 🎯 Access control implemented
- 📝 Event logging for all actions

## 🗺️ Roadmap

**✅ Phase 1 - MVP (Completed)**
- ✅ Property NFT smart contract
- ✅ Marketplace contract with fees
- ✅ Escrow contract for security
- ✅ Basic frontend UI/UX
- ✅ Wallet integration

**🚧 Phase 2 - Integration (In Progress)**
- ⏳ Blockchain query integration
- ⏳ Real-time property listings
- ⏳ Complete buy/sell workflow
- ⏳ Escrow integration

**📋 Phase 3 - Advanced Features (Planned)**
- 🔮 Advanced property search & filters
- 🔮 Transaction history dashboard
- 🔮 Rating & review system
- 🔮 IPFS image storage
- 🔮 Multi-language support
- 🔮 Mobile responsive design

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details

## 👥 Team

Built with ❤️ by [tranzankhien](https://github.com/tranzankhien)

## 📧 Support

For issues and questions:
- 🐛 [Open an issue](https://github.com/tranzankhien/real_estate_market-study/issues)
- 💬 [Discussions](https://github.com/tranzankhien/real_estate_market-study/discussions)

---

**Built on IOTA Blockchain** 🚀

---

## 📚 Additional Resources

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
