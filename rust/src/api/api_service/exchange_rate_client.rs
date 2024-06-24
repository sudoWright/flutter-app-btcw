use super::proton_api_service::ProtonAPIService;
use crate::{exchange_rate::ProtonExchangeRate, BridgeError};
use andromeda_api::{core::ApiClient, settings::FiatCurrencySymbol as FiatCurrency};
use std::sync::Arc;

pub struct ExchangeRateClient {
    pub inner: Arc<andromeda_api::exchange_rate::ExchangeRateClient>,
}

impl ExchangeRateClient {
    pub fn new(service: &ProtonAPIService) -> Self {
        Self {
            inner: Arc::new(andromeda_api::exchange_rate::ExchangeRateClient::new(
                service.inner.clone(),
            )),
        }
    }

    pub async fn get_exchange_rate(
        &self,
        fiat_currency: FiatCurrency,
        time: Option<u64>,
    ) -> Result<ProtonExchangeRate, BridgeError> {
        let result = self.inner.get_exchange_rate(fiat_currency, time).await;
        match result {
            Ok(response) => Ok(response.into()),
            Err(err) => Err(err.into()),
        }
    }
}
