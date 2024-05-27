// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.33.

// Section: imports

use super::*;
use crate::api::api_service::bitcoin_address_client::*;
use crate::api::api_service::email_integration_client::*;
use crate::api::api_service::event_client::*;
use crate::api::api_service::exchange_rate_client::*;
use crate::api::api_service::proton_api_service::*;
use crate::api::api_service::proton_contacts_client::*;
use crate::api::api_service::proton_email_addr_client::*;
use crate::api::api_service::proton_users_client::*;
use crate::api::api_service::settings_client::*;
use crate::api::api_service::transaction_client::*;
use crate::api::api_service::wallet_auth_store::*;
use crate::api::api_service::wallet_client::*;
use crate::api::bdk_wallet::*;
use flutter_rust_bridge::for_generated::byteorder::{NativeEndian, ReadBytesExt, WriteBytesExt};
use flutter_rust_bridge::for_generated::transform_result_dco;
use flutter_rust_bridge::for_generated::wasm_bindgen;
use flutter_rust_bridge::for_generated::wasm_bindgen::prelude::*;
use flutter_rust_bridge::{Handler, IntoIntoDart};

// Section: boilerplate

flutter_rust_bridge::frb_generated_boilerplate_web!();

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcProtonAPIService(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Arc < ProtonAPIService >>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerArcProtonAPIService(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<Arc < ProtonAPIService >>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBdkWalletManager(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<BdkWalletManager>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBdkWalletManager(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<BdkWalletManager>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBitcoinAddressClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<BitcoinAddressClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerBitcoinAddressClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<BitcoinAddressClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerContactsClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ContactsClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerContactsClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ContactsClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEmailIntegrationClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<EmailIntegrationClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEmailIntegrationClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<EmailIntegrationClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEventClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<EventClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerEventClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<EventClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerExchangeRateClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ExchangeRateClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerExchangeRateClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ExchangeRateClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerProtonAPIService(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonAPIService>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerProtonAPIService(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonAPIService>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerProtonEmailAddressClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonEmailAddressClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerProtonEmailAddressClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonEmailAddressClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerProtonUsersClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonUsersClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerProtonUsersClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonUsersClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerProtonWalletAuthStore(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonWalletAuthStore>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerProtonWalletAuthStore(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ProtonWalletAuthStore>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSettingsClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<SettingsClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerSettingsClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<SettingsClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerTransactionClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<TransactionClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerTransactionClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<TransactionClient>>::decrement_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_increment_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletClient>>::increment_strong_count(ptr as _);
}

#[wasm_bindgen]
pub fn rust_arc_decrement_strong_count_RustOpaque_flutter_rust_bridgefor_generatedRustAutoOpaqueInnerWalletClient(
    ptr: *const std::ffi::c_void,
) {
    MoiArc::<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<WalletClient>>::decrement_strong_count(ptr as _);
}
