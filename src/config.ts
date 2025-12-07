// Network configuration for IOTA
export const NETWORK = "testnet";

// Package IDs sau khi deploy
export const PACKAGE_IDS = {
  PROPERTY: "0x2ee861ccbdc2037ffa01250fdad78d94cd73f9e44b44cca5b82e249107a11edd",
  MARKETPLACE: "0x3597f5c17be5057c4c1be4e2301d5af33bebcf5bb89d53d9c7e2d7a377525959",
  ESCROW: "0xa53a4b57043d12512180a661615ee81f1bfd9dd0fa93939e154b7cc39e8ae2f6",
};

// Marketplace object ID (shared object)
export const MARKETPLACE_OBJECT_ID = "0xdba5c27664fd5eeb47d4277ab6996ea560826f7f93f5ce407df6388f73afa370";

// Module names
export const MODULES = {
  PROPERTY: "real_estate",
  MARKETPLACE: "property_marketplace",
  ESCROW: "property_escrow",
};

// Property types
export const PROPERTY_TYPES = {
  HOUSE: 1,
  LAND: 2,
  APARTMENT: 3,
};

export const PROPERTY_TYPE_LABELS = {
  [PROPERTY_TYPES.HOUSE]: "Nhà",
  [PROPERTY_TYPES.LAND]: "Đất",
  [PROPERTY_TYPES.APARTMENT]: "Căn hộ",
};

export const PROPERTY_TYPE_ICONS = {
  [PROPERTY_TYPES.HOUSE]: "🏠",
  [PROPERTY_TYPES.LAND]: "🌳",
  [PROPERTY_TYPES.APARTMENT]: "🏢",
};
