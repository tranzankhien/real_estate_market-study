# Hướng dẫn Deploy Smart Contracts

## Bước 1: Chuẩn bị môi trường

### Cài đặt IOTA CLI (nếu chưa có)

```bash
# Mở WSL Ubuntu và chạy:
curl --proto '=https' --tlsv1.2 -sSf https://docs.iota.org/developer/getting-started/install-iota | sh
```

### Cấu hình testnet

```bash
iota client new-env --alias testnet --rpc https://fullnode.testnet.iota.org:443
iota client switch --env testnet
```

### Tạo địa chỉ ví (nếu chưa có)

```bash
iota client new-address --key-scheme secp256k1
iota client switch --address 0xYOUR_ADDRESS
```

### Lấy IOTA từ faucet

```bash
curl --location --request POST 'https://faucet.testnet.iota.org/gas' \
--header 'Content-Type: application/json' \
--data-raw '{
    "FixedAmountRequest": {
        "recipient": "YOUR_ADDRESS"
    }
}'
```

## Bước 2: Build Contracts

**Trong WSL Ubuntu:**

```bash
cd /mnt/d/IOTA/real-estate_exchange-iota_dapp/move/property
iota move build

cd ../marketplace
iota move build

cd ../escrow
iota move build
```

## Bước 3: Deploy Contracts

### Deploy Property Contract

```bash
cd /mnt/d/IOTA/real-estate_exchange-iota_dapp/move/property
iota client publish --gas-budget 100000000
```

**Lưu lại:**
- Package ID (dòng `Published Objects:` -> `PackageID`)

### Deploy Marketplace Contract

```bash
cd ../marketplace
iota client publish --gas-budget 100000000
```

**Lưu lại:**
- Package ID

### Deploy Escrow Contract

```bash
cd ../escrow
iota client publish --gas-budget 100000000
```

**Lưu lại:**
- Package ID

## Bước 4: Khởi tạo Marketplace

Sau khi deploy Marketplace contract, cần khởi tạo Marketplace object:

```bash
iota client call \
  --package <MARKETPLACE_PACKAGE_ID> \
  --module property_marketplace \
  --function create_marketplace \
  --args 5 \
  --gas-budget 10000000
```

Trong đó `5` là phí giao dịch 5%.

**Lưu lại Marketplace Object ID** từ kết quả.

## Bước 5: Cập nhật Frontend Config

Mở file `src/config.ts` và cập nhật:

```typescript
export const PACKAGE_IDS = {
  PROPERTY: "0xYOUR_PROPERTY_PACKAGE_ID",
  MARKETPLACE: "0xYOUR_MARKETPLACE_PACKAGE_ID",
  ESCROW: "0xYOUR_ESCROW_PACKAGE_ID",
};

export const MARKETPLACE_OBJECT_ID = "0xYOUR_MARKETPLACE_OBJECT_ID";
```

## Bước 6: Test

### Tạo Property

```bash
iota client call \
  --package <PROPERTY_PACKAGE_ID> \
  --module real_estate \
  --function create_property \
  --args "Nha dep" "Mo ta chi tiet" "Da Nang" 1000000 100 1 "https://example.com/image.jpg" \
  --gas-budget 10000000
```

### Kiểm tra object vừa tạo

```bash
iota client object <PROPERTY_OBJECT_ID>
```

## Lưu ý

- Tất cả lệnh `iota` phải chạy trong **WSL Ubuntu**
- Đảm bảo có đủ IOTA trong ví để trả gas fee
- Lưu lại tất cả Package IDs và Object IDs
- Kiểm tra kỹ địa chỉ ví đang active: `iota client active-address`
