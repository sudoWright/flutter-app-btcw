// transaction_details.rs
use flutter_rust_bridge::frb;

use andromeda_bitcoin::transactions::{TransactionDetails, TransactionTime};

use crate::api::bdk_wallet::derivation_path::FrbDerivationPath;

use super::{
    transaction_details_txin::FrbDetailledTxIn, transaction_details_txop::FrbDetailledTxOutput,
};

#[derive(Clone, Debug)]
pub struct FrbTransactionDetails {
    /// Transaction id
    pub txid: String,
    /// Received value (sats)
    /// Sum of owned outputs of this transaction.
    pub received: u64,
    /// Sent value (sats)
    /// Sum of owned inputs of this transaction.
    pub sent: u64,
    /// Fee value (sats) if confirmed.
    /// The availability of the fee depends on the backend. It's never `None`
    /// with an Electrum Server backend, but it could be `None` with a
    /// Bitcoin RPC node without txindex that receive funds while offline.
    pub fees: Option<u64>,
    /// If the transaction is confirmed, contains height and Unix timestamp of
    /// the block containing the transaction, unconfirmed transaction
    /// contains `None`.
    pub time: TransactionTime,
    /// List of transaction inputs.
    pub inputs: Vec<FrbDetailledTxIn>,
    /// List of transaction outputs.
    pub outputs: Vec<FrbDetailledTxOutput>,
    /// BIP44 Account to which the transaction is bound
    pub account_derivation_path: FrbDerivationPath,
}

impl FrbTransactionDetails {
    #[frb(getter, sync)]
    pub fn txid(&self) -> String {
        self.txid.clone()
    }

    #[frb(getter, sync)]
    pub fn received(&self) -> u64 {
        self.received
    }

    #[frb(getter, sync)]
    pub fn sent(&self) -> u64 {
        self.sent
    }

    #[frb(getter, sync)]
    pub fn fees(&self) -> Option<u64> {
        self.fees
    }

    #[frb(getter, sync)]
    pub fn time(&self) -> TransactionTime {
        self.time
    }

    #[frb(getter, sync)]
    pub fn inputs(&self) -> Vec<FrbDetailledTxIn> {
        self.inputs.clone()
    }

    #[frb(getter, sync)]
    pub fn outputs(&self) -> Vec<FrbDetailledTxOutput> {
        self.outputs.clone()
    }

    #[frb(getter, sync)]
    pub fn account_derivation_path(&self) -> FrbDerivationPath {
        self.account_derivation_path.clone()
    }
}

impl From<TransactionDetails> for FrbTransactionDetails {
    fn from(transaction_details: TransactionDetails) -> Self {
        FrbTransactionDetails {
            txid: transaction_details.txid.to_string(),
            received: transaction_details.received,
            sent: transaction_details.sent,
            fees: transaction_details.fees,
            time: transaction_details.time,
            inputs: transaction_details
                .inputs
                .into_iter()
                .map(FrbDetailledTxIn::from)
                .collect(),
            outputs: transaction_details
                .outputs
                .into_iter()
                .map(FrbDetailledTxOutput::from)
                .collect(),
            account_derivation_path: transaction_details.account_derivation_path.into(),
        }
    }
}
