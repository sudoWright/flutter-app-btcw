use std::sync::Arc;

use crate::{
    errors::ApiError,
    wallet::{BitcoinAddress, WalletBitcoinAddress},
};

use super::proton_api_service::ProtonAPIService;

pub struct BitcoinAddressClient {
    pub inner: Arc<andromeda_api::bitcoin_address::BitcoinAddressClient>,
}

impl BitcoinAddressClient {
    pub fn new(service: &ProtonAPIService) -> Self {
        Self {
            inner: Arc::new(andromeda_api::bitcoin_address::BitcoinAddressClient::new(
                service.inner.clone(),
            )),
        }
    }

    pub async fn update_bitcoin_address(
        &self,
        wallet_id: String,
        wallet_account_id: String,
        wallet_account_bitcoin_address_id: String,
        bitcoin_address: BitcoinAddress,
    ) -> Result<WalletBitcoinAddress, ApiError> {
        let result = self
            .inner
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
        &self,
        wallet_id: String,
        wallet_account_id: String,
        bitcoin_addresses: Vec<BitcoinAddress>,
    ) -> Result<Vec<WalletBitcoinAddress>, ApiError> {
        let result = self
            .inner
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
    pub async fn get_wallet_bitcoin_address(
        &self,
        wallet_id: String,
        wallet_account_id: String,
        only_request: Option<u8>,
    ) -> Result<Vec<WalletBitcoinAddress>, ApiError> {
        let result = self
            .inner
            .get_bitcoin_addresses(wallet_id, wallet_account_id, only_request)
            .await;
        match result {
            Ok(response) => Ok(response.into_iter().map(|v| v.into()).collect()),
            Err(err) => Err(err.into()),
        }
    }

    pub async fn get_bitcoin_address_latest_index(
        &self,
        wallet_id: String,
        wallet_account_id: String,
    ) -> Result<u64, ApiError> {
        let result = self
            .inner
            .get_bitcoin_address_highest_index(wallet_id, wallet_account_id)
            .await;
        match result {
            Ok(response) => Ok(response),
            Err(err) => Err(err.into()),
        }
    }
}
