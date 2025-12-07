module marketplace::property_marketplace {
    use iota::object::{Self, UID};
    use iota::transfer;
    use iota::tx_context::{Self, TxContext};
    use iota::coin::{Self, Coin};
    use iota::iota::IOTA;
    use iota::balance::{Self, Balance};
    use iota::event;

    /// Listing đại diện cho một property đang được bán
    public struct Listing has key, store {
        id: UID,
        // ID của property
        property_id: address,
        // Người bán
        seller: address,
        // Giá bán (IOTA)
        price: u64,
        // Trạng thái
        is_active: bool,
    }

    /// Marketplace chứa tất cả listings
    public struct Marketplace has key {
        id: UID,
        // Phí giao dịch (%)
        fee_percentage: u64,
        // Số dư phí đã thu
        fee_balance: Balance<IOTA>,
        // Admin
        admin: address,
    }

    /// Event khi tạo listing
    public struct ListingCreated has copy, drop {
        listing_id: address,
        property_id: address,
        seller: address,
        price: u64,
    }

    /// Event khi mua thành công
    public struct PropertyPurchased has copy, drop {
        listing_id: address,
        property_id: address,
        buyer: address,
        seller: address,
        price: u64,
    }

    /// Event khi hủy listing
    public struct ListingCancelled has copy, drop {
        listing_id: address,
        property_id: address,
    }

    /// Khởi tạo marketplace (chỉ gọi 1 lần)
    public entry fun create_marketplace(
        fee_percentage: u64,
        ctx: &mut TxContext
    ) {
        let marketplace = Marketplace {
            id: object::new(ctx),
            fee_percentage,
            fee_balance: balance::zero(),
            admin: tx_context::sender(ctx),
        };

        transfer::share_object(marketplace);
    }

    /// Tạo listing mới
    public entry fun create_listing(
        property_id: address,
        price: u64,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let id = object::new(ctx);
        let listing_id = object::uid_to_address(&id);

        let listing = Listing {
            id,
            property_id,
            seller: sender,
            price,
            is_active: true,
        };

        event::emit(ListingCreated {
            listing_id,
            property_id,
            seller: sender,
            price,
        });

        transfer::share_object(listing);
    }

    /// Mua property
    public entry fun purchase_property(
        marketplace: &mut Marketplace,
        listing: &mut Listing,
        payment: Coin<IOTA>,
        ctx: &mut TxContext
    ) {
        assert!(listing.is_active, 0); // Listing phải active
        assert!(coin::value(&payment) >= listing.price, 1); // Đủ tiền

        let buyer = tx_context::sender(ctx);
        
        // Tính phí
        let fee_amount = (listing.price * marketplace.fee_percentage) / 100;
        let seller_amount = listing.price - fee_amount;

        // Tách tiền
        let mut payment_balance = coin::into_balance(payment);
        let fee_balance = balance::split(&mut payment_balance, fee_amount);
        let seller_balance = balance::split(&mut payment_balance, seller_amount);

        // Thêm phí vào marketplace
        balance::join(&mut marketplace.fee_balance, fee_balance);

        // Chuyển tiền cho seller
        let seller_coin = coin::from_balance(seller_balance, ctx);
        transfer::public_transfer(seller_coin, listing.seller);

        // Trả lại tiền thừa (nếu có)
        if (balance::value(&payment_balance) > 0) {
            let change = coin::from_balance(payment_balance, ctx);
            transfer::public_transfer(change, buyer);
        } else {
            balance::destroy_zero(payment_balance);
        };

        // Đánh dấu listing đã bán
        listing.is_active = false;

        event::emit(PropertyPurchased {
            listing_id: object::uid_to_address(&listing.id),
            property_id: listing.property_id,
            buyer,
            seller: listing.seller,
            price: listing.price,
        });
    }

    /// Hủy listing
    public entry fun cancel_listing(
        listing: &mut Listing,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        assert!(listing.seller == sender, 2); // Chỉ seller mới hủy được
        assert!(listing.is_active, 3); // Phải đang active

        listing.is_active = false;

        event::emit(ListingCancelled {
            listing_id: object::uid_to_address(&listing.id),
            property_id: listing.property_id,
        });
    }

    /// Cập nhật giá listing
    public entry fun update_listing_price(
        listing: &mut Listing,
        new_price: u64,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        assert!(listing.seller == sender, 2);
        assert!(listing.is_active, 3);

        listing.price = new_price;
    }

    /// Admin rút phí
    public entry fun withdraw_fees(
        marketplace: &mut Marketplace,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        assert!(marketplace.admin == sender, 4); // Chỉ admin

        let amount = balance::value(&marketplace.fee_balance);
        assert!(amount > 0, 5); // Phải có tiền

        let withdrawn = coin::take(&mut marketplace.fee_balance, amount, ctx);
        transfer::public_transfer(withdrawn, sender);
    }

    // === Getter functions ===
    public fun get_listing_price(listing: &Listing): u64 {
        listing.price
    }

    public fun get_listing_seller(listing: &Listing): address {
        listing.seller
    }

    public fun get_property_id(listing: &Listing): address {
        listing.property_id
    }

    public fun is_listing_active(listing: &Listing): bool {
        listing.is_active
    }

    public fun get_fee_percentage(marketplace: &Marketplace): u64 {
        marketplace.fee_percentage
    }
}
