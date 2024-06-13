use andromeda_api::contacts::ApiContactEmails;
use andromeda_api::settings::{
    FiatCurrencySymbol as FiatCurrency, UserSettings as ApiWalletUserSettings,
};
use andromeda_api::wallet::{ApiWallet, ApiWalletAccount, ApiWalletData};
use andromeda_api::{
    transaction::ExchangeRateOrTransactionTime, wallet::CreateWalletTransactionRequestBody,
    ChildSession,
};
use andromeda_common::BitcoinUnit;
use chrono::Utc;
use lazy_static::lazy_static;
use log::info;
use std::sync::{Arc, RwLock};

use crate::api::api_service::proton_api_service::ProtonAPIService;
use crate::proton_api::{
    errors::ApiError,
    event_routes::ProtonEvent,
    exchange_rate::ProtonExchangeRate,
    proton_address::{AllKeyAddressKey, ProtonAddress},
    wallet::{
        BitcoinAddress, CreateWalletReq, EmailIntegrationBitcoinAddress, WalletBitcoinAddress,
        WalletTransaction,
    },
    wallet_account::CreateWalletAccountReq,
};

use crate::bdk::psbt::Transaction;
use bdk::bitcoin::consensus::serialize;
use bdk::bitcoin::Transaction as bdkTransaction;
use bitcoin_internals::hex::display::DisplayHex;

lazy_static! {
    static ref PROTON_API: RwLock<Option<Arc<ProtonAPIService>>> = RwLock::new(None);
}

pub(crate) fn retrieve_proton_api() -> Arc<ProtonAPIService> {
    PROTON_API.read().unwrap().clone().unwrap()
}

pub(crate) fn set_proton_api(inner: Arc<ProtonAPIService>) {
    info!("set_proton_api is called");
    let mut api_ref = PROTON_API.write().unwrap();
    *api_ref = Some(inner.clone());
}

pub(crate) fn logout() {
    let mut api_ref = PROTON_API.write().unwrap();
    *api_ref = None;
}

/// TODO:: slowly move to use api_service folder functions
// wallets
pub async fn get_wallets() -> Result<Vec<ApiWalletData>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result: Result<Vec<andromeda_api::wallet::ApiWalletData>, andromeda_api::error::Error> =
        proton_api.inner.clients().wallet.get_wallets().await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn create_wallet(wallet_req: CreateWalletReq) -> Result<ApiWalletData, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .create_wallet(wallet_req.into())
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn update_wallet_name(
    wallet_id: String,
    new_name: String,
) -> Result<ApiWallet, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .update_wallet_name(wallet_id, new_name)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn delete_wallet(wallet_id: String) -> Result<(), ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .delete_wallet(wallet_id)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

// wallet accounts
pub async fn get_wallet_accounts(wallet_id: String) -> Result<Vec<ApiWalletAccount>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .get_wallet_accounts(wallet_id)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn create_wallet_account(
    wallet_id: String,
    req: CreateWalletAccountReq,
) -> Result<ApiWalletAccount, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .create_wallet_account(wallet_id, req.into())
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn update_wallet_account_label(
    wallet_id: String,
    wallet_account_id: String,
    new_label: String,
) -> Result<ApiWalletAccount, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .update_wallet_account_label(wallet_id, wallet_account_id, new_label)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn update_wallet_account_fiat_currency(
    wallet_id: String,
    wallet_account_id: String,
    new_fiat_currency: FiatCurrency,
) -> Result<ApiWalletAccount, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .update_wallet_account_fiat_currency(wallet_id, wallet_account_id, new_fiat_currency)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn delete_wallet_account(
    wallet_id: String,
    wallet_account_id: String,
) -> Result<(), ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .delete_wallet_account(wallet_id, wallet_account_id)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

/// getUserSettings
pub async fn get_user_settings() -> Result<ApiWalletUserSettings, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .settings
        .get_user_settings()
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn bitcoin_unit(symbol: BitcoinUnit) -> Result<ApiWalletUserSettings, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .settings
        .update_bitcoin_unit(symbol)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn fiat_currency(symbol: FiatCurrency) -> Result<ApiWalletUserSettings, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .settings
        .update_fiat_currency(symbol)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn two_fa_threshold(amount: u64) -> Result<ApiWalletUserSettings, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .settings
        .update_two_fa_threshold(amount)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn hide_empty_used_addresses(
    hide_empty_used_addresses: bool,
) -> Result<ApiWalletUserSettings, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .settings
        .update_hide_empty_used_addresses(hide_empty_used_addresses)
        .await;

    info!("hide_empty_userd_addresses: {:?}", result);
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn get_exchange_rate(
    fiat_currency: FiatCurrency,
    time: Option<u64>,
) -> Result<ProtonExchangeRate, ApiError> {
    // call_dart_callback("geting_exchange_rate".to_string()).await;
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .exchange_rate
        .get_exchange_rate(fiat_currency, time)
        .await;

    info!("get_exchange_rate: {:?}", result);

    match result {
        Ok(response) => Ok(response.into()),
        Err(err) => Err(err.into()),
    }
}

pub async fn get_latest_event_id() -> Result<String, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api.inner.clients().event.get_latest_event_id().await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn collect_events(latest_event_id: String) -> Result<Vec<ProtonEvent>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .event
        .collect_events(latest_event_id)
        .await;
    match result {
        Ok(response) => Ok(response.into_iter().map(|x| x.into()).collect()),
        Err(err) => Err(err.into()),
    }
}

pub async fn get_contacts() -> Result<Vec<ApiContactEmails>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .contacts
        .get_contacts(Some(1000), Some(0))
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn get_proton_address() -> Result<Vec<ProtonAddress>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .proton_email_address
        .get_proton_email_addresses()
        .await;
    match result {
        Ok(response) => Ok(response.into_iter().map(|x| x.into()).collect()),
        Err(err) => Err(err.into()),
    }
}

pub async fn add_email_address(
    wallet_id: String,
    wallet_account_id: String,
    address_id: String,
) -> Result<ApiWalletAccount, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();

    let result = proton_api
        .inner
        .clients()
        .wallet
        .add_email_address(wallet_id, wallet_account_id, address_id)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn remove_email_address(
    wallet_id: String,
    wallet_account_id: String,
    address_id: String,
) -> Result<ApiWalletAccount, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();

    let result = proton_api
        .inner
        .clients()
        .wallet
        .remove_email_address(wallet_id, wallet_account_id, address_id)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn update_bitcoin_address(
    wallet_id: String,
    wallet_account_id: String,
    wallet_account_bitcoin_address_id: String,
    bitcoin_address: BitcoinAddress,
) -> Result<WalletBitcoinAddress, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();

    let result = proton_api
        .inner
        .clients()
        .bitcoin_address
        .update_bitcoin_address(
            wallet_id,
            wallet_account_id,
            wallet_account_bitcoin_address_id,
            bitcoin_address.into(),
        )
        .await;
    match result {
        Ok(response) => Ok(response.into()),
        Err(err) => Err(err.into()),
    }
}

pub async fn add_bitcoin_addresses(
    wallet_id: String,
    wallet_account_id: String,
    bitcoin_addresses: Vec<BitcoinAddress>,
) -> Result<Vec<WalletBitcoinAddress>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();

    let result = proton_api
        .inner
        .clients()
        .bitcoin_address
        .add_bitcoin_addresses(
            wallet_id,
            wallet_account_id,
            bitcoin_addresses.into_iter().map(|v| v.into()).collect(),
        )
        .await;
    match result {
        Ok(response) => Ok(response.into_iter().map(|x| x.into()).collect()),
        Err(err) => Err(err.into()),
    }
}

pub async fn lookup_bitcoin_address(
    email: String,
) -> Result<EmailIntegrationBitcoinAddress, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();

    let result = proton_api
        .inner
        .clients()
        .email_integration
        .lookup_bitcoin_address(email)
        .await;
    match result {
        Ok(response) => Ok(response.into()),
        Err(err) => Err(err.into()),
    }
}

pub async fn get_wallet_bitcoin_address(
    wallet_id: String,
    wallet_account_id: String,
    only_request: Option<u8>,
) -> Result<Vec<WalletBitcoinAddress>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();

    let result = proton_api
        .inner
        .clients()
        .bitcoin_address
        .get_bitcoin_addresses(wallet_id, wallet_account_id, only_request)
        .await;
    match result {
        Ok(response) => Ok(response.into_iter().map(|v| v.into()).collect()),
        Err(err) => Err(err.into()),
    }
}

pub async fn get_bitcoin_address_latest_index(
    wallet_id: String,
    wallet_account_id: String,
) -> Result<u64, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();

    let result = proton_api
        .inner
        .clients()
        .bitcoin_address
        .get_bitcoin_address_highest_index(wallet_id, wallet_account_id)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn get_wallet_transactions(
    wallet_id: String,
    wallet_account_id: Option<String>,
    hashed_txids: Option<Vec<String>>,
) -> Result<Vec<WalletTransaction>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();

    let result = proton_api
        .inner
        .clients()
        .wallet
        .get_wallet_transactions(wallet_id, wallet_account_id, hashed_txids)
        .await;
    match result {
        Ok(response) => Ok(response.into_iter().map(|v| v.into()).collect()),
        Err(err) => Err(err.into()),
    }
}

pub async fn create_wallet_transactions(
    wallet_id: String,
    wallet_account_id: String,
    transaction_id: String,
    hashed_transaction_id: String,
    label: Option<String>,
    exchange_rate_id: Option<String>,
    transaction_time: Option<String>,
) -> Result<WalletTransaction, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let payload = CreateWalletTransactionRequestBody {
        TransactionID: transaction_id,
        HashedTransactionID: hashed_transaction_id,
        Label: label,
        ExchangeRateID: exchange_rate_id,
        TransactionTime: transaction_time,
    };
    let result = proton_api
        .inner
        .clients()
        .wallet
        .create_wallet_transaction(wallet_id, wallet_account_id, payload)
        .await;
    match result {
        Ok(response) => Ok(response.into()),
        Err(err) => Err(err.into()),
    }
}

pub async fn update_wallet_transaction_label(
    wallet_id: String,
    wallet_account_id: String,
    wallet_transaction_id: String,
    label: String,
) -> Result<WalletTransaction, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .update_wallet_transaction_label(wallet_id, wallet_account_id, wallet_transaction_id, label)
        .await;
    match result {
        Ok(response) => Ok(response.into()),
        Err(err) => Err(err.into()),
    }
}

pub async fn delete_wallet_transactions(
    wallet_id: String,
    wallet_account_id: String,
    wallet_transaction_id: String,
) -> Result<(), ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .wallet
        .delete_wallet_transactions(wallet_id, wallet_account_id, wallet_transaction_id)
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

#[allow(clippy::too_many_arguments)]
pub async fn broadcast_raw_transaction(
    signed_transaction_hex: String,
    wallet_id: String,
    wallet_account_id: String,
    label: Option<String>,
    exchange_rate_id: Option<String>,
    transaction_time: Option<String>,
    address_id: Option<String>,
    subject: Option<String>,
    body: Option<String>,
) -> Result<String, ApiError> {
    let transaction: Transaction = signed_transaction_hex.into();
    let bdk_transaction: &bdkTransaction = &transaction.internal;
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let signed_transaction_hex = serialize(bdk_transaction).to_lower_hex_string();
    println!("signed_transaction_hex: {}", signed_transaction_hex);
    let exchange_rate_or_transaction_time = if let Some(exchange_rate_id) = exchange_rate_id {
        ExchangeRateOrTransactionTime::ExchangeRate(exchange_rate_id)
    } else if let Some(transaction_time) = transaction_time {
        ExchangeRateOrTransactionTime::TransactionTime(transaction_time)
    } else {
        ExchangeRateOrTransactionTime::TransactionTime(Utc::now().timestamp().to_string())
    };
    let result = proton_api
        .inner
        .clients()
        .transaction
        .broadcast_raw_transaction(
            signed_transaction_hex,
            wallet_id,
            wallet_account_id,
            label,
            exchange_rate_or_transaction_time,
            address_id,
            subject,
            body,
        )
        .await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

pub async fn get_all_public_keys(
    email: String,
    internal_only: u8,
) -> Result<Vec<AllKeyAddressKey>, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api
        .inner
        .clients()
        .proton_email_address
        .get_all_public_keys(email, Some(internal_only))
        .await;
    match result {
        Ok(response) => Ok(response.into_iter().map(|v| v.into()).collect()),
        Err(err) => Err(err.into()),
    }
}

pub async fn is_valid_token() -> Result<bool, ApiError> {
    let result = get_latest_event_id().await;
    match result {
        Ok(_) => Ok(true),
        Err(_) => Ok(false),
    }
}

pub async fn fork() -> Result<ChildSession, ApiError> {
    let proton_api = PROTON_API.read().unwrap().clone().unwrap();
    let result = proton_api.inner.fork().await;
    match result {
        Ok(response) => Ok(response),
        Err(err) => Err(err.into()),
    }
}

// enable it after 2fa mr ready for andromeda

// pub async fn get_2fa_enabled() -> Result<u32, ApiError> {
//     let proton_api = PROTON_API.read().unwrap().clone().unwrap();
//     let result = proton_api.two_factor_auth.get_2fa_enabled().await;
//     match result {
//         Ok(response) => Ok(response.into()),
//         Err(err) => Err(err.into()),
//     }
// }

// pub async fn set_2fa_totp(
//     username: String,
//     password: String,
//     totp_shared_secret: String,
//     totp_confirmation: String,
// ) -> Result<Vec<String>, ApiError> {
//     let proton_api = PROTON_API.read().unwrap().clone().unwrap();
//     let result = proton_api
//         .two_factor_auth
//         .set_2fa_totp(username, password, totp_shared_secret, totp_confirmation)
//         .await;
//     match result {
//         Ok(response) => Ok(response.into()),
//         Err(err) => Err(err.into()),
//     }
// }

// pub async fn disable_2fa_totp(
//     username: String,
//     password: String,
//     two_factor_code: String,
// ) -> Result<u32, ApiError> {
//     let proton_api = PROTON_API.read().unwrap().clone().unwrap();
//     let result = proton_api
//         .two_factor_auth
//         .disable_2fa_totp(username, password, two_factor_code)
//         .await;
//     match result {
//         Ok(response) => Ok(response.into()),
//         Err(err) => Err(err.into()),
//     }
// }

#[cfg(test)]
mod test {

    use crate::api::{
        api_service::{
            proton_api_service::ProtonAPIService, wallet_auth_store::ProtonWalletAuthStore,
        },
        proton_api::fork,
    };

    #[tokio::test]
    #[ignore]
    async fn test_fork_session() {
        let app_version = "android-wallet@1.0.0".to_string();
        let user_agent = "ProtonWallet/1.0.0 (iOS/17.4; arm64)".to_string();
        let env = "atlas";

        let store = ProtonWalletAuthStore::from_session(
            env,
            "aajxkia2ffiwjsm4gip5g2aahhra2gre".to_string(),
            "ietv5s2jri4hmggjj7bv2dtw6sf3ilp7".to_string(),
            "xwpffga6xbuitqw7sndtya5g2nk5xn4n".to_string(),
            vec![
                "full".to_string(),
                "self".to_string(),
                "payments".to_string(),
                "keys".to_string(),
                "parent".to_string(),
                "user".to_string(),
                "loggedin".to_string(),
                "nondelinquent".to_string(),
                "verified".to_string(),
                "settings".to_string(),
                "wallet".to_string(),
            ],
        )
        .unwrap();
        let mut client =
            ProtonAPIService::new(env.to_string(), app_version, user_agent, store).unwrap();
        client.set_proton_api();
        let forked_session = fork().await.unwrap();
        println!("forked session: {:?}", forked_session);
        assert!(!forked_session.access_token.is_empty())
    }

    #[tokio::test]
    #[ignore]
    async fn test_login_fork_session() {
        let app_version = "android-wallet@1.0.0".to_string();
        let user_agent = "ProtonWallet/1.0.0 (iOS/17.4; arm64)".to_string();
        let env = "atlas";

        let user = "feng100".to_string();
        let pass = "12345678".to_string();

        let store = ProtonWalletAuthStore::new(env).unwrap();
        let mut client =
            ProtonAPIService::new(env.to_string(), app_version, user_agent, store).unwrap();
        let auth_info = client.login(user, pass).await.unwrap();
        assert!(!auth_info.access_token.is_empty());
        client.set_proton_api();

        let forked_session = fork().await.unwrap();
        println!("forked session: {:?}", forked_session);
        assert!(!forked_session.access_token.is_empty())
    }
}
