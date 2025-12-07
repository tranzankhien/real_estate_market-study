module escrow::property_escrow {
    use iota::object::{Self, UID};
    use iota::transfer;
    use iota::tx_context::{Self, TxContext};
    use iota::coin::{Self, Coin};
    use iota::iota::IOTA;
    use iota::balance::{Self, Balance};
    use iota::event;

    /// Escrow cho giao dịch BĐS
    public struct Escrow has key {
        id: UID,
        // Property ID
        property_id: address,
        // Người mua
        buyer: address,
        // Người bán
        seller: address,
        // Số tiền ký quỹ
        amount: Balance<IOTA>,
        // Trạng thái: 0=pending, 1=completed, 2=cancelled
        status: u8,
        // Thời gian tạo
        created_at: u64,
    }

    /// Event tạo escrow
    public struct EscrowCreated has copy, drop {
        escrow_id: address,
        property_id: address,
        buyer: address,
        seller: address,
        amount: u64,
    }

    /// Event hoàn tất escrow
    public struct EscrowCompleted has copy, drop {
        escrow_id: address,
        property_id: address,
        buyer: address,
        seller: address,
    }

    /// Event hủy escrow
    public struct EscrowCancelled has copy, drop {
        escrow_id: address,
        property_id: address,
        reason: u8, // 1=buyer cancel, 2=seller cancel
    }

    // Status constants
    const STATUS_PENDING: u8 = 0;
    const STATUS_COMPLETED: u8 = 1;
    const STATUS_CANCELLED: u8 = 2;

    // Error codes
    const E_INVALID_STATUS: u64 = 0;
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_INSUFFICIENT_AMOUNT: u64 = 2;

    /// Tạo escrow mới với tiền đặt cọc
    public entry fun create_escrow(
        property_id: address,
        seller: address,
        payment: Coin<IOTA>,
        ctx: &mut TxContext
    ) {
        let buyer = tx_context::sender(ctx);
        let amount = coin::value(&payment);
        let id = object::new(ctx);
        let escrow_id = object::uid_to_address(&id);

        let escrow = Escrow {
            id,
            property_id,
            buyer,
            seller,
            amount: coin::into_balance(payment),
            status: STATUS_PENDING,
            created_at: tx_context::epoch(ctx),
        };

        event::emit(EscrowCreated {
            escrow_id,
            property_id,
            buyer,
            seller,
            amount,
        });

        transfer::share_object(escrow);
    }

    /// Hoàn tất giao dịch - chuyển tiền cho seller
    public entry fun complete_escrow(
        escrow: &mut Escrow,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        
        // Chỉ buyer hoặc seller mới có thể hoàn tất
        assert!(sender == escrow.buyer || sender == escrow.seller, E_NOT_AUTHORIZED);
        assert!(escrow.status == STATUS_PENDING, E_INVALID_STATUS);

        let amount = balance::value(&escrow.amount);
        let payment = coin::take(&mut escrow.amount, amount, ctx);
        
        // Chuyển tiền cho seller
        transfer::public_transfer(payment, escrow.seller);

        escrow.status = STATUS_COMPLETED;

        event::emit(EscrowCompleted {
            escrow_id: object::uid_to_address(&escrow.id),
            property_id: escrow.property_id,
            buyer: escrow.buyer,
            seller: escrow.seller,
        });
    }

    /// Hủy giao dịch - hoàn tiền cho buyer
    public entry fun cancel_escrow(
        escrow: &mut Escrow,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        
        // Chỉ buyer hoặc seller mới có thể hủy
        assert!(sender == escrow.buyer || sender == escrow.seller, E_NOT_AUTHORIZED);
        assert!(escrow.status == STATUS_PENDING, E_INVALID_STATUS);

        let amount = balance::value(&escrow.amount);
        let refund = coin::take(&mut escrow.amount, amount, ctx);
        
        // Hoàn tiền cho buyer
        transfer::public_transfer(refund, escrow.buyer);

        escrow.status = STATUS_CANCELLED;

        let reason = if (sender == escrow.buyer) { 1 } else { 2 };

        event::emit(EscrowCancelled {
            escrow_id: object::uid_to_address(&escrow.id),
            property_id: escrow.property_id,
            reason,
        });
    }

    /// Buyer xác nhận nhận property - tự động hoàn tất
    public entry fun buyer_confirm(
        escrow: &mut Escrow,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        assert!(sender == escrow.buyer, E_NOT_AUTHORIZED);
        assert!(escrow.status == STATUS_PENDING, E_INVALID_STATUS);

        let amount = balance::value(&escrow.amount);
        let payment = coin::take(&mut escrow.amount, amount, ctx);
        
        transfer::public_transfer(payment, escrow.seller);
        escrow.status = STATUS_COMPLETED;

        event::emit(EscrowCompleted {
            escrow_id: object::uid_to_address(&escrow.id),
            property_id: escrow.property_id,
            buyer: escrow.buyer,
            seller: escrow.seller,
        });
    }

    // === Getter functions ===
    public fun get_property_id(escrow: &Escrow): address {
        escrow.property_id
    }

    public fun get_buyer(escrow: &Escrow): address {
        escrow.buyer
    }

    public fun get_seller(escrow: &Escrow): address {
        escrow.seller
    }

    public fun get_amount(escrow: &Escrow): u64 {
        balance::value(&escrow.amount)
    }

    public fun get_status(escrow: &Escrow): u8 {
        escrow.status
    }

    public fun get_created_at(escrow: &Escrow): u64 {
        escrow.created_at
    }
}
