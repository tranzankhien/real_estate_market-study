# Smart Contracts - Real Estate Marketplace on IOTA

This directory contains Move smart contracts for a decentralized real estate marketplace built on the IOTA blockchain.

## 📁 Project Structure

```
move/
├── property/           # Property NFT contract
│   ├── Move.toml
│   └── sources/
│       └── property.move
├── marketplace/        # Marketplace contract
│   ├── Move.toml
│   └── sources/
│       └── marketplace.move
└── escrow/            # Escrow contract
    ├── Move.toml
    └── sources/
        └── escrow.move
```

---

## 🏗️ Smart Contracts Overview

### 1️⃣ Property Contract (`property/`)

**Purpose:** Manages Property NFTs representing real estate assets.

**Key Features:**
- Create property NFTs with metadata (title, description, location, price, area, type, image)
- Update property price
- Toggle availability status
- Transfer ownership
- Emit events for property creation and transfers

**Main Functions:**
- `create_property()` - Mint a new property NFT
- `update_price()` - Change the selling price
- `update_availability()` - Mark as available/sold
- `transfer_property()` - Transfer ownership to another address

**Data Structure:**
```move
public struct Property has key, store {
    id: UID,
    title: String,
    description: String,
    location: String,
    price: u64,
    area: u64,
    property_type: u8,  // 1=house, 2=land, 3=apartment
    is_available: bool,
    original_owner: address,
    image_url: String,
}
```

---

### 2️⃣ Marketplace Contract (`marketplace/`)

**Purpose:** Facilitates buying and selling of properties with transaction fees.

**Key Features:**
- Create listings for properties
- Purchase properties with IOTA tokens
- Automatic fee collection (configurable percentage)
- Admin fee withdrawal
- Cancel and update listings

**Main Functions:**
- `create_marketplace()` - Initialize marketplace (one-time setup)
- `create_listing()` - List a property for sale
- `purchase_property()` - Buy a listed property
- `cancel_listing()` - Remove a listing
- `update_listing_price()` - Change listing price
- `withdraw_fees()` - Admin withdraws collected fees

**Data Structures:**
```move
public struct Marketplace has key {
    id: UID,
    fee_percentage: u64,
    fee_balance: Balance<IOTA>,
    admin: address,
}

public struct Listing has key, store {
    id: UID,
    property_id: address,
    seller: address,
    price: u64,
    is_active: bool,
}
```

**Transaction Flow:**
1. Seller creates listing with price
2. Buyer purchases with IOTA payment
3. Marketplace deducts fee (e.g., 5%)
4. Seller receives payment minus fee
5. Listing marked as inactive

---

### 3️⃣ Escrow Contract (`escrow/`)

**Purpose:** Provides secure escrow service for real estate transactions.

**Key Features:**
- Lock buyer's payment until transaction completes
- Protect both buyer and seller
- Allow cancellation with refund
- Buyer confirmation mechanism
- Transaction status tracking

**Main Functions:**
- `create_escrow()` - Create escrow and deposit funds
- `complete_escrow()` - Release funds to seller
- `cancel_escrow()` - Cancel and refund buyer
- `buyer_confirm()` - Buyer confirms receipt of property

**Data Structure:**
```move
public struct Escrow has key {
    id: UID,
    property_id: address,
    buyer: address,
    seller: address,
    amount: Balance<IOTA>,
    status: u8,  // 0=pending, 1=completed, 2=cancelled
    created_at: u64,
}
```

**Transaction Flow:**
1. Buyer creates escrow and locks payment
2. Seller transfers property NFT
3. Buyer confirms receipt via `buyer_confirm()`
4. Payment automatically released to seller

---

## 🚀 Getting Started

### Prerequisites

- IOTA CLI installed
- WSL/Ubuntu (for Move commands)
- Node.js >= 18 (for frontend)
- IOTA testnet account with tokens

### Setup IOTA Environment

```bash
# Configure testnet
iota client new-env --alias testnet --rpc https://api.testnet.iota.cafe:443
iota client switch --env testnet

# Create address
iota client new-address --key-scheme ed25519

# Request testnet tokens
# Visit: https://faucet.testnet.iota.cafe/
```

---

## 📦 Build Contracts

```bash
# Build Property contract
cd property
iota move build

# Build Marketplace contract
cd ../marketplace
iota move build

# Build Escrow contract
cd ../escrow
iota move build
```

---

## 🚢 Deploy Contracts

### 1. Deploy Property Contract

```bash
cd property
iota client publish --gas-budget 100000000
```

**Save the `PackageID` from output.**

### 2. Deploy Marketplace Contract

```bash
cd ../marketplace
iota client publish --gas-budget 100000000
```

**Save the `PackageID` from output.**

### 3. Deploy Escrow Contract

```bash
cd ../escrow
iota client publish --gas-budget 100000000
```

**Save the `PackageID` from output.**

### 4. Initialize Marketplace

```bash
iota client call \
  --package <MARKETPLACE_PACKAGE_ID> \
  --module property_marketplace \
  --function create_marketplace \
  --args 5 \
  --gas-budget 10000000
```

**Save the `Marketplace Object ID` (shared object) from output.**

---

## 🧪 Testing Contracts

### Test Property Creation

```bash
iota client call \
  --package <PROPERTY_PACKAGE_ID> \
  --module real_estate \
  --function create_property \
  --args "Beach Villa" "Luxury beachfront property" "Da Nang, Vietnam" 5000000000 200 1 "https://example.com/villa.jpg" \
  --gas-budget 10000000
```

### Test Create Listing

```bash
iota client call \
  --package <MARKETPLACE_PACKAGE_ID> \
  --module property_marketplace \
  --function create_listing \
  --args <PROPERTY_OBJECT_ID> 5000000000 \
  --gas-budget 10000000
```

### Test Create Escrow

```bash
iota client call \
  --package <ESCROW_PACKAGE_ID> \
  --module property_escrow \
  --function create_escrow \
  --args <PROPERTY_ID> <SELLER_ADDRESS> <COIN_OBJECT_ID> \
  --gas-budget 10000000
```

---

## 🔍 Verify Deployment

```bash
# Check deployed packages
iota client objects

# Inspect specific object
iota client object <OBJECT_ID>

# View on Explorer
# https://explorer.iota.cafe/object/<OBJECT_ID>?network=testnet
```

---

## 📝 Configuration

After deployment, update `../src/config.ts`:

```typescript
export const PACKAGE_IDS = {
  PROPERTY: "0xYOUR_PROPERTY_PACKAGE_ID",
  MARKETPLACE: "0xYOUR_MARKETPLACE_PACKAGE_ID",
  ESCROW: "0xYOUR_ESCROW_PACKAGE_ID",
};

export const MARKETPLACE_OBJECT_ID = "0xYOUR_MARKETPLACE_OBJECT_ID";
```

---

## 🔐 Security Features

- **Access Control:** Only authorized users can modify their assets
- **Immutable Ownership:** Property ownership tracked on-chain
- **Atomic Transactions:** All state changes are atomic
- **Event Logging:** All important actions emit events
- **Escrow Protection:** Funds locked until transaction completes

---

## 🛠️ Development

### Clean Build

```bash
rm -rf build/
iota move build
```

### Run Tests

```bash
iota move test
```

### Gas Optimization Tips

- Use `&mut` references instead of consuming objects when possible
- Batch operations in single transactions
- Minimize storage usage

---

## 📚 Resources

- [IOTA Documentation](https://docs.iota.org/)
- [Move Language Book](https://move-language.github.io/move/)
- [IOTA Testnet Explorer](https://explorer.iota.cafe/?network=testnet)
- [IOTA Testnet Faucet](https://faucet.testnet.iota.cafe/)

---

## 🐛 Troubleshooting

### Insufficient Gas
```bash
# Increase gas budget
--gas-budget 200000000
```

### Object Not Found
- Verify object ID is correct
- Ensure object belongs to active address
- Check object hasn't been consumed

### Type Mismatch
- Verify argument types match function signature
- Use correct number format (u64, u8)
- Wrap strings in quotes

---

## 📄 License

MIT License

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📧 Support

For issues and questions, please open an issue on GitHub.
