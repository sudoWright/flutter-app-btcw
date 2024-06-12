use super::proton_api_service::ProtonAPIService;
use crate::errors::ApiError;
use andromeda_api::{
    core::ApiClient,
    settings::{FiatCurrencySymbol as FiatCurrency, UserSettings as ApiWalletUserSettings},
};
use andromeda_common::BitcoinUnit;
use std::sync::Arc;

pub struct SettingsClient {
    pub inner: Arc<andromeda_api::settings::SettingsClient>,
}

impl SettingsClient {
    pub fn new(service: &ProtonAPIService) -> SettingsClient {
        SettingsClient {
            inner: Arc::new(andromeda_api::settings::SettingsClient::new(
                service.inner.clone(),
            )),
        }
    }

    pub async fn get_user_settings(&self) -> Result<ApiWalletUserSettings, ApiError> {
        let result = self.inner.get_user_settings().await;
        match result {
            Ok(response) => Ok(response),
            Err(err) => Err(err.into()),
        }
    }

    pub async fn bitcoin_unit(
        &self,
        symbol: BitcoinUnit,
    ) -> Result<ApiWalletUserSettings, ApiError> {
        let result = self.inner.update_bitcoin_unit(symbol).await;
        match result {
            Ok(response) => Ok(response),
            Err(err) => Err(err.into()),
        }
    }

    pub async fn fiat_currency(
        &self,
        symbol: FiatCurrency,
    ) -> Result<ApiWalletUserSettings, ApiError> {
        let result = self.inner.update_fiat_currency(symbol).await;
        match result {
            Ok(response) => Ok(response),
            Err(err) => Err(err.into()),
        }
    }

    pub async fn two_fa_threshold(&self, amount: u64) -> Result<ApiWalletUserSettings, ApiError> {
        let result = self.inner.update_two_fa_threshold(amount).await;
        match result {
            Ok(response) => Ok(response),
            Err(err) => Err(err.into()),
        }
    }
    pub async fn hide_empty_used_addresses(
        &self,
        hide_empty_used_addresses: bool,
    ) -> Result<ApiWalletUserSettings, ApiError> {
        let result = self
            .inner
            .update_hide_empty_used_addresses(hide_empty_used_addresses)
            .await;
        match result {
            Ok(response) => Ok(response),
            Err(err) => Err(err.into()),
        }
    }
}
