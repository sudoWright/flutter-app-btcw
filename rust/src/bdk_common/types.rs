// use crate::bdk::psbt::Transaction;
// use bdk::bitcoin::blockdata::transaction::TxIn as BdkTxIn;
// use bdk::bitcoin::blockdata::transaction::TxOut as BdkTxOut;
// use bdk::bitcoin::hashes::hex::ToHex;
// use bdk::bitcoin::locktime::Error;
// use bdk::bitcoin::psbt::Input;
// use bdk::bitcoin::util::address::{Payload as BdkPayload, WitnessVersion as BdkWitnessVersion};
// use bdk::bitcoin::{Address as BdkAddress, OutPoint as BdkOutPoint, Txid};
// use bdk::blockchain::Progress as BdkProgress;
// use bdk::{Balance as BdkBalance, Error as BdkError};
use serde::{Deserialize, Serialize};
use std::borrow::Borrow;
use std::fmt;
use std::fmt::Debug;
use std::str::FromStr;

#[derive(Debug, Clone)]
pub struct TxIn {
    pub previous_output: OutPoint,
    pub script_sig: Script,
    pub sequence: u32,
    pub witness: Vec<String>,
}

// impl From<&BdkTxIn> for TxIn {
//     fn from(x: &BdkTxIn) -> Self {
//         TxIn {
//             previous_output: x.previous_output.into(),
//             script_sig: x.clone().script_sig.into(),
//             sequence: x.clone().sequence.0,
//             witness: x.witness.to_vec().iter().map(|x| x.to_hex()).collect(),
//         }
//     }
// }

///A transaction output, which defines new coins to be created from old ones.
pub struct TxOut {
    /// The value of the output, in satoshis.
    pub value: u64,
    /// The address of the output.
    pub script_pubkey: Script,
}
// impl From<&BdkTxOut> for TxOut {
//     fn from(x: &BdkTxOut) -> Self {
//         TxOut {
//             value: x.clone().value,
//             script_pubkey: x.clone().script_pubkey.into(),
//         }
//     }
// }
pub struct PsbtSigHashType {
    pub inner: u32,
}

// pub fn to_input(input: String) -> Input {
//     let input: Input = serde_json::from_str(&input).expect("Invalid Psbt Input");
//     input
// }
/// A reference to a transaction output.
#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct OutPoint {
    /// The referenced transaction's txid.
    pub(crate) txid: String,
    /// The index of the referenced output in its transaction's vout.
    pub(crate) vout: u32,
}
// impl From<&OutPoint> for BdkOutPoint {
//     fn from(x: &OutPoint) -> BdkOutPoint {
//         BdkOutPoint {
//             txid: Txid::from_str(x.clone().txid.borrow()).unwrap(),
//             vout: x.clone().vout,
//         }
//     }
// }
// impl From<BdkOutPoint> for OutPoint {
//     fn from(x: BdkOutPoint) -> OutPoint {
//         OutPoint {
//             txid: x.txid.to_string(),
//             vout: x.vout,
//         }
//     }
// }

// /// Local Wallet's Balance
// #[derive(Deserialize)]


/// The address index selection strategy to use to derived an address from the wallet's external
/// descriptor.
pub enum AddressIndex {
    ///Return a new address after incrementing the current descriptor index.
    New,
    ///Return the address for the current descriptor index if it has not been used in a received transaction. Otherwise return a new address as with AddressIndex.New.
    ///Use with caution, if the wallet has not yet detected an address has been used it could return an already used address. This function is primarily meant for situations where the caller is untrusted; for example when deriving donation addresses on-demand for a public web page.
    LastUnused,
    /// Return the address for a specific descriptor index. Does not change the current descriptor
    /// index used by `AddressIndex` and `AddressIndex.LastUsed`.
    /// Use with caution, if an index is given that is less than the current descriptor index
    /// then the returned address may have already been used.
    Peek { index: u32 },
    /// Return the address for a specific descriptor index and reset the current descriptor index
    /// used by `AddressIndex` and `AddressIndex.LastUsed` to this value.
    /// Use with caution, if an index is given that is less than the current descriptor index
    /// then the returned address and subsequent addresses returned by calls to `AddressIndex`
    /// and `AddressIndex.LastUsed` may have already been used. Also if the index is reset to a
    /// value earlier than the Blockchain stopGap (default is 20) then a
    /// larger stopGap should be used to monitor for all possibly used addresses.
    Reset { index: u32 },
}
// impl From<AddressIndex> for bdk::wallet::AddressIndex {
//     fn from(x: AddressIndex) -> bdk::wallet::AddressIndex {
//         match x {
//             AddressIndex::New => bdk::wallet::AddressIndex::New,
//             AddressIndex::LastUnused => bdk::wallet::AddressIndex::LastUnused,
//             AddressIndex::Peek { index } => bdk::wallet::AddressIndex::Peek(index),
//             AddressIndex::Reset { index } => bdk::wallet::AddressIndex::Reset(index),
//         }
//     }
// }

///A derived address and the index it was found at For convenience this automatically derefs to Address
pub struct AddressInfo {
    ///Child index of this address
    pub index: u32,
    /// Address
    pub address: String,
}
// impl From<bdk::wallet::AddressInfo> for AddressInfo {
//     fn from(x: bdk::wallet::AddressInfo) -> AddressInfo {
//         AddressInfo {
//             index: x.index,
//             address: x.address.to_string(),
//         }
//     }
// }

#[derive(Debug, Clone, PartialEq, Eq, Default, Serialize)]
///A wallet transaction
pub struct TransactionDetails {
    pub serialized_tx: Option<String>,
    /// Transaction id.
    pub txid: String,
    /// Received value (sats)
    /// Sum of owned outputs of this transaction.
    pub received: u64,
    /// Sent value (sats)
    /// Sum of owned inputs of this transaction.
    pub sent: u64,
    /// Fee value (sats) if confirmed.
    /// The availability of the fee depends on the backend. It's never None with an Electrum
    /// Server backend, but it could be None with a Bitcoin RPC node without txindex that receive
    /// funds while offline.
    pub fee: Option<u64>,
    /// If the transaction is confirmed, contains height and timestamp of the block containing the
    /// transaction, unconfirmed transaction contains `None`.
    pub confirmation_time: Option<BlockTime>,
}
/// A wallet transaction
// impl From<&bdk::TransactionDetails> for TransactionDetails {
//     fn from(x: &bdk::TransactionDetails) -> TransactionDetails {
//         TransactionDetails {
//             serialized_tx: x
//                 .clone()
//                 .transaction
//                 .map(|x| Transaction { internal: x }.into()),
//             fee: x.clone().fee,
//             txid: x.clone().txid.to_string(),
//             received: x.clone().received,
//             sent: x.clone().sent,
//             confirmation_time: set_block_time(x.confirmation_time.clone()),
//         }
//     }
// }

// fn set_block_time(time: Option<bdk::BlockTime>) -> Option<BlockTime> {
//     time.map(|time| time.into())
// }

#[derive(Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
///Block height and timestamp of a block
pub struct BlockTime {
    ///Confirmation block height
    pub height: u32,
    ///Confirmation block timestamp
    pub timestamp: u64,
}

// impl From<bdk::BlockTime> for BlockTime {
//     fn from(x: bdk::BlockTime) -> Self {
//         BlockTime {
//             height: x.height,
//             timestamp: x.timestamp,
//         }
//     }
// }

/// A output script and an amount of satoshis.
pub struct ScriptAmount {
    pub script: Script,
    pub amount: u64,
}

#[allow(dead_code)]
#[derive(Clone, Debug)]
pub enum RbfValue {
    RbfDefault,
    Value(u32),
}

#[derive(Debug, Clone)]
///Types of keychains
pub enum KeychainKind {
    External,
    ///Internal, usually used for change outputs
    Internal,
}
// impl From<bdk::KeychainKind> for KeychainKind {
//     fn from(e: bdk::KeychainKind) -> Self {
//         match e {
//             bdk::KeychainKind::External => KeychainKind::External,
//             bdk::KeychainKind::Internal => KeychainKind::Internal,
//         }
//     }
// }
// impl From<KeychainKind> for bdk::KeychainKind {
//     fn from(kind: KeychainKind) -> Self {
//         match kind {
//             KeychainKind::External => bdk::KeychainKind::External,
//             KeychainKind::Internal => bdk::KeychainKind::Internal,
//         }
//     }
// }


// pub struct Address {
//     pub address: BdkAddress,
// }
// impl Address {
//     pub fn new(address: String) -> Result<Self, BdkError> {
//         BdkAddress::from_str(address.as_str())
//             .map(|a| Address { address: a })
//             .map_err(|e| BdkError::Generic(e.to_string()))
//     }

//     pub fn from_script(script: Script, network: Network) -> Result<Self, BdkError> {
//         BdkAddress::from_script(&script.into(), network.into())
//             .map(|a| Address { address: a })
//             .map_err(|e| BdkError::Generic(e.to_string()))
//     }
//     pub fn payload(&self) -> Payload {
//         match &self.address.payload.clone() {
//             BdkPayload::PubkeyHash(pubkey_hash) => Payload::PubkeyHash {
//                 pubkey_hash: pubkey_hash.to_vec(),
//             },
//             BdkPayload::ScriptHash(script_hash) => Payload::ScriptHash {
//                 script_hash: script_hash.to_vec(),
//             },
//             BdkPayload::WitnessProgram { version, program } => Payload::WitnessProgram {
//                 version: version.to_owned().into(),
//                 program: program.clone(),
//             },
//         }
//     }

//     pub fn network(&self) -> Network {
//         self.address.network.into()
//     }

//     pub fn script_pubkey(&self) -> Script {
//         self.address.script_pubkey().into()
//     }
// }
/// A Bitcoin script.
#[derive(Clone, Default, Debug)]
pub struct Script {
    pub internal: Vec<u8>,
}
// impl Script {
//     pub fn new(raw_output_script: Vec<u8>) -> Result<Script, Error> {
//         let script = bdk::bitcoin::Script::from(raw_output_script);
//         Ok(Script {
//             internal: script.into_bytes(),
//         })
//     }
// }

// impl From<Script> for bdk::bitcoin::Script {
//     fn from(value: Script) -> Self {
//         bdk::bitcoin::Script::from(value.internal)
//     }
// }
// impl From<bdk::bitcoin::Script> for Script {
//     fn from(value: bdk::bitcoin::Script) -> Self {
//         Script {
//             internal: value.into_bytes(),
//         }
//     }
// }

#[derive(Debug, Clone)]
pub enum WitnessVersion {
    /// Initial version of witness program. Used for P2WPKH and P2WPK outputs
    V0 = 0,
    /// Version of witness program used for Taproot P2TR outputs.
    V1 = 1,
    /// Future (unsupported) version of witness program.
    V2 = 2,
    /// Future (unsupported) version of witness program.
    V3 = 3,
    /// Future (unsupported) version of witness program.
    V4 = 4,
    /// Future (unsupported) version of witness program.
    V5 = 5,
    /// Future (unsupported) version of witness program.
    V6 = 6,
    /// Future (unsupported) version of witness program.
    V7 = 7,
    /// Future (unsupported) version of witness program.
    V8 = 8,
    /// Future (unsupported) version of witness program.
    V9 = 9,
    /// Future (unsupported) version of witness program.
    V10 = 10,
    /// Future (unsupported) version of witness program.
    V11 = 11,
    /// Future (unsupported) version of witness program.
    V12 = 12,
    /// Future (unsupported) version of witness program.
    V13 = 13,
    /// Future (unsupported) version of witness program.
    V14 = 14,
    /// Future (unsupported) version of witness program.
    V15 = 15,
    /// Future (unsupported) version of witness program.
    V16 = 16,
}
// impl From<BdkWitnessVersion> for WitnessVersion {
//     fn from(value: BdkWitnessVersion) -> Self {
//         match value {
//             BdkWitnessVersion::V0 => WitnessVersion::V0,
//             BdkWitnessVersion::V1 => WitnessVersion::V1,
//             BdkWitnessVersion::V2 => WitnessVersion::V2,
//             BdkWitnessVersion::V3 => WitnessVersion::V3,
//             BdkWitnessVersion::V4 => WitnessVersion::V4,
//             BdkWitnessVersion::V5 => WitnessVersion::V5,
//             BdkWitnessVersion::V6 => WitnessVersion::V6,
//             BdkWitnessVersion::V7 => WitnessVersion::V7,
//             BdkWitnessVersion::V8 => WitnessVersion::V8,
//             BdkWitnessVersion::V9 => WitnessVersion::V9,
//             BdkWitnessVersion::V10 => WitnessVersion::V10,
//             BdkWitnessVersion::V11 => WitnessVersion::V11,
//             BdkWitnessVersion::V12 => WitnessVersion::V12,
//             BdkWitnessVersion::V13 => WitnessVersion::V13,
//             BdkWitnessVersion::V14 => WitnessVersion::V14,
//             BdkWitnessVersion::V15 => WitnessVersion::V15,
//             BdkWitnessVersion::V16 => WitnessVersion::V16,
//         }
//     }
// }
/// The method used to produce an address.
#[derive(Debug)]
pub enum Payload {
    /// P2PKH address.
    PubkeyHash { pubkey_hash: Vec<u8> },
    /// P2SH address.
    ScriptHash { script_hash: Vec<u8> },
    /// Segwit address.
    WitnessProgram {
        /// The witness program version.
        version: WitnessVersion,
        /// The witness program.
        program: Vec<u8>,
    },
}

/// Trait that logs at level INFO every update received (if any).
pub trait Progress: Send + Sync + 'static {
    /// Send a new progress update. The progress value should be in the range 0.0 - 100.0, and the message value is an
    /// optional text message that can be displayed to the user.
    fn update(&self, progress: f32, message: Option<String>);
}

pub struct ProgressHolder {
    pub progress: Box<dyn Progress>,
}

// impl BdkProgress for ProgressHolder {
//     fn update(&self, progress: f32, message: Option<String>) -> Result<(), BdkError> {
//         self.progress.update(progress, message);
//         Ok(())
//     }
// }

impl Debug for ProgressHolder {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("ProgressHolder").finish_non_exhaustive()
    }
}
// pub enum ChangeSpendPolicy {
//     ChangeAllowed,
//     OnlyChange,
//     ChangeForbidden,
// }
// impl From<ChangeSpendPolicy> for bdk::wallet::tx_builder::ChangeSpendPolicy {
//     fn from(value: ChangeSpendPolicy) -> Self {
//         match value {
//             ChangeSpendPolicy::ChangeAllowed => {
//                 bdk::wallet::tx_builder::ChangeSpendPolicy::ChangeAllowed
//             }
//             ChangeSpendPolicy::OnlyChange => bdk::wallet::tx_builder::ChangeSpendPolicy::OnlyChange,
//             ChangeSpendPolicy::ChangeForbidden => {
//                 bdk::wallet::tx_builder::ChangeSpendPolicy::ChangeForbidden
//             }
//         }
//     }
// }
