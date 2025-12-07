module property::real_estate {
    use iota::object::{Self, UID};
    use iota::transfer;
    use iota::tx_context::{Self, TxContext};
    use std::string::{Self, String};
    use iota::event;

    /// Property NFT đại diện cho bất động sản
    public struct Property has key, store {
        id: UID,
        // Thông tin cơ bản
        title: String,
        description: String,
        location: String,
        // Thông tin giá cả
        price: u64,
        // Diện tích (m2)
        area: u64,
        // Loại BĐS: 1=nhà, 2=đất, 3=căn hộ
        property_type: u8,
        // Trạng thái: true=đang bán, false=đã bán
        is_available: bool,
        // Chủ sở hữu ban đầu
        original_owner: address,
        // URL hình ảnh
        image_url: String,
    }

    /// Event khi tạo property mới
    public struct PropertyCreated has copy, drop {
        property_id: address,
        owner: address,
        title: String,
        price: u64,
    }

    /// Event khi chuyển quyền sở hữu
    public struct PropertyTransferred has copy, drop {
        property_id: address,
        from: address,
        to: address,
    }

    /// Tạo property mới
    public entry fun create_property(
        title: vector<u8>,
        description: vector<u8>,
        location: vector<u8>,
        price: u64,
        area: u64,
        property_type: u8,
        image_url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let id = object::new(ctx);
        let property_id = object::uid_to_address(&id);

        let property = Property {
            id,
            title: string::utf8(title),
            description: string::utf8(description),
            location: string::utf8(location),
            price,
            area,
            property_type,
            is_available: true,
            original_owner: sender,
            image_url: string::utf8(image_url),
        };

        event::emit(PropertyCreated {
            property_id,
            owner: sender,
            title: property.title,
            price,
        });

        transfer::public_transfer(property, sender);
    }

    /// Cập nhật giá bán
    public entry fun update_price(
        property: &mut Property,
        new_price: u64,
        _ctx: &mut TxContext
    ) {
        property.price = new_price;
    }

    /// Cập nhật trạng thái bán
    public entry fun update_availability(
        property: &mut Property,
        is_available: bool,
        _ctx: &mut TxContext
    ) {
        property.is_available = is_available;
    }

    /// Chuyển quyền sở hữu
    public entry fun transfer_property(
        property: Property,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let property_id = object::uid_to_address(&property.id);
        let sender = tx_context::sender(ctx);

        event::emit(PropertyTransferred {
            property_id,
            from: sender,
            to: recipient,
        });

        transfer::public_transfer(property, recipient);
    }

    // === Getter functions ===
    public fun get_title(property: &Property): String {
        property.title
    }

    public fun get_description(property: &Property): String {
        property.description
    }

    public fun get_location(property: &Property): String {
        property.location
    }

    public fun get_price(property: &Property): u64 {
        property.price
    }

    public fun get_area(property: &Property): u64 {
        property.area
    }

    public fun get_property_type(property: &Property): u8 {
        property.property_type
    }

    public fun is_available(property: &Property): bool {
        property.is_available
    }

    public fun get_original_owner(property: &Property): address {
        property.original_owner
    }

    public fun get_image_url(property: &Property): String {
        property.image_url
    }
}
