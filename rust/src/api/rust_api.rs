use super::proton_api::retrieve_proton_api;
pub use crate::bdk::blockchain::Blockchain;
use crate::bdk::blockchain::EsploraConfig;
pub use crate::bdk::descriptor::BdkDescriptor;
use crate::bdk::error::Error;
use crate::bdk::key::{DerivationPath, DescriptorPublicKey, DescriptorSecretKey, Mnemonic};
use crate::bdk::psbt::PartiallySignedTransaction;
pub use crate::bdk::psbt::Transaction;
use crate::bdk::types::{
    to_input, Address, AddressIndex, AddressInfo, Balance, ChangeSpendPolicy, KeychainKind,
    Network, OutPoint, PsbtSigHashType, RbfValue, Script, ScriptAmount, TransactionDetails, TxIn,
    TxOut, WordCount,
};
pub use crate::bdk::wallet::{DatabaseConfig, Wallet};
use crate::bdk::wallet::{LocalUtxo, SignOptions};
use bdk::bitcoin::{Address as BdkAddress, OutPoint as BdkOutPoint, Sequence, Txid};
use bdk::keys::DescriptorSecretKey as BdkDescriptorSecretKey;
use bitcoin::script::PushBytesBuf;
use lazy_static::lazy_static;
use log::{info, warn};
use std::borrow::Borrow;
use std::ops::Deref;
use std::str::FromStr;
use std::sync::{Arc, RwLock};
use tokio::runtime::Runtime;
use tokio::sync::Mutex;

lazy_static! {
    // runtime used for async calls but future or struct doesnt impl Send
    static ref RUNTIME: RwLock<Arc<tokio::runtime::Runtime>> = RwLock::new(Arc::new(Runtime::new().unwrap()));
}
pub struct Api {}
impl Api {
    //========Blockchain==========

    /// create esplora blockchain with proton api
    pub fn create_esplora_blockchain_with_api(config: EsploraConfig) -> Result<String, Error> {
        let proton_api: Arc<andromeda_api::ProtonWalletApiClient> =
            retrieve_proton_api().inner.clone();
        let blockchain = Blockchain::new_blockchain_with_api(config, proton_api);
        match blockchain {
            Ok(e) => Ok(e),
            Err(e) => Err(e.into()),
        }
    }

    pub async fn get_height(blockchain_id: String) -> Result<u32, Error> {
        RUNTIME.read().unwrap().clone().block_on(async {
            match Blockchain::retrieve_blockchain(blockchain_id)
                .get_height()
                .await
            {
                Ok(e) => Ok(e),
                Err(e) => Err(e.into()),
            }
        })
    }
    pub async fn get_blockchain_hash(
        blockchain_height: u32,
        blockchain_id: String,
    ) -> Result<String, Error> {
        RUNTIME.read().unwrap().clone().block_on(async {
            match Blockchain::retrieve_blockchain(blockchain_id)
                .get_block_hash(blockchain_height)
                .await
            {
                Ok(e) => Ok(e),
                Err(e) => Err(e.into()),
            }
        })
    }

    pub fn estimate_fee(target: u64, blockchain_id: String) -> Result<f32, Error> {
        RUNTIME.read().unwrap().clone().block_on(async {
            match Blockchain::retrieve_blockchain(blockchain_id)
                .estimate_fee(target)
                .await
            {
                Ok(e) => Ok(e.as_sat_per_vb()),
                Err(e) => Err(e.into()),
            }
        })
    }

    pub fn broadcast(tx: String, blockchain_id: String) -> Result<String, Error> {
        RUNTIME.read().unwrap().clone().block_on(async {
            let transaction: Transaction = tx.into();

            match Blockchain::retrieve_blockchain(blockchain_id)
                .broadcast(transaction)
                .await
            {
                Ok(e) => Ok(e),
                Err(e) => Err(e.into()),
            }
        })
    }

    //=========Transaction===========
    pub fn create_transaction(tx: Vec<u8>) -> Result<String, Error> {
        let res = Transaction::new(tx);
        match res {
            Ok(e) => Ok(e.into()),
            Err(e) => Err(e.into()),
        }
    }
    pub fn tx_txid(tx: String) -> Result<String, Error> {
        let tx_: Transaction = tx.into();
        Ok(tx_.txid())
    }
    pub fn weight(tx: String) -> u64 {
        let tx_: Transaction = tx.into();
        tx_.weight()
    }
    pub fn size(tx: String) -> u64 {
        let tx_: Transaction = tx.into();
        tx_.size()
    }
    pub fn vsize(tx: String) -> u64 {
        let tx_: Transaction = tx.into();
        tx_.vsize()
    }
    // pub fn serialize_tx(tx: String) -> Vec<u8> {
    //     let tx_: Transaction = tx.into();
    //     tx_.serialize()
    // }
    pub fn is_coin_base(tx: String) -> bool {
        let tx_: Transaction = tx.into();
        tx_.is_coin_base()
    }
    pub fn is_explicitly_rbf(tx: String) -> bool {
        let tx_: Transaction = tx.into();
        tx_.is_explicitly_rbf()
    }
    pub fn is_lock_time_enabled(tx: String) -> bool {
        let tx_: Transaction = tx.into();
        tx_.is_lock_time_enabled()
    }
    pub fn version(tx: String) -> i32 {
        let tx_: Transaction = tx.into();
        tx_.version()
    }
    pub fn lock_time(tx: String) -> u32 {
        let tx_: Transaction = tx.into();
        tx_.lock_time()
    }
    pub fn input(tx: String) -> Vec<TxIn> {
        let tx_: Transaction = tx.into();
        tx_.input()
    }
    pub fn output(tx: String) -> Vec<TxOut> {
        let tx_: Transaction = tx.into();
        tx_.output()
    }

    //========PartiallySignedTransaction==========
    pub async fn serialize_psbt(psbt_str: String) -> Result<String, Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        match psbt {
            Ok(e) => Ok(e.serialize().await),
            Err(e) => Err(e.into()),
        }
    }
    pub async fn psbt_txid(psbt_str: String) -> Result<String, Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        match psbt {
            Ok(e) => Ok(e.txid().await),
            Err(e) => Err(e.into()),
        }
    }
    pub async fn extract_tx(psbt_str: String) -> Result<String, Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        match psbt {
            Ok(e) => Ok(e.extract_tx().await.into()),
            Err(e) => Err(e.into()),
        }
    }
    pub async fn psbt_fee_rate(psbt_str: String) -> Option<f32> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        psbt.unwrap().fee_rate().await.map(|e| e.as_sat_per_vb())
    }
    pub async fn psbt_fee_amount(psbt_str: String) -> Option<u64> {
        let psbt = PartiallySignedTransaction::new(psbt_str);
        psbt.unwrap().fee_amount().await
    }
    pub async fn combine_psbt(psbt_str: String, other: String) -> Result<String, Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str).unwrap();
        let other = PartiallySignedTransaction::new(other).unwrap();
        match psbt.combine(Arc::new(other)).await {
            Ok(e) => Ok(e.serialize().await),
            Err(e) => Err(e.into()),
        }
    }
    pub async fn json_serialize(psbt_str: String) -> Result<String, Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str).unwrap();
        Ok(psbt.json_serialize().await)
    }

    //========TxBuilder==========
    #[allow(clippy::too_many_arguments)]
    pub fn tx_builder_finish(
        wallet_id: String,
        recipients: Vec<ScriptAmount>,
        utxos: Vec<OutPoint>,
        foreign_utxo: Option<(OutPoint, String, usize)>,
        unspendable: Vec<OutPoint>,
        change_policy: ChangeSpendPolicy,
        manually_selected_only: bool,
        fee_rate: Option<f32>,
        fee_absolute: Option<u64>,
        drain_wallet: bool,
        drain_to: Option<Script>,
        rbf: Option<RbfValue>,
        data: Vec<u8>,
    ) -> Result<(String, TransactionDetails), Error> {
        RUNTIME.read().unwrap().clone().block_on(async {
            let binding = Wallet::retrieve_wallet(wallet_id);
            let binding = binding.get_wallet().await;

            let mut tx_builder = binding.build_tx();

            for e in recipients {
                tx_builder.add_recipient(e.script.into(), e.amount);
            }
            tx_builder.change_policy(change_policy.into());

            if !utxos.is_empty() {
                let bdk_utxos: Vec<BdkOutPoint> = utxos.iter().map(BdkOutPoint::from).collect();
                let utxos: &[BdkOutPoint] = &bdk_utxos;
                tx_builder.add_utxos(utxos).unwrap();
            }
            if !unspendable.is_empty() {
                let bdk_unspendable: Vec<BdkOutPoint> =
                    unspendable.iter().map(BdkOutPoint::from).collect();
                tx_builder.unspendable(bdk_unspendable);
            }
            if manually_selected_only {
                tx_builder.manually_selected_only();
            }
            if let Some(sat_per_vb) = fee_rate {
                tx_builder.fee_rate(bdk::FeeRate::from_sat_per_vb(sat_per_vb));
            }
            if let Some(fee_amount) = fee_absolute {
                tx_builder.fee_absolute(fee_amount);
            }
            if drain_wallet {
                tx_builder.drain_wallet();
            }
            if let Some(script_) = drain_to {
                tx_builder.drain_to(script_.into());
            }
            if let Some(f_utxo) = foreign_utxo {
                let input = to_input(f_utxo.1);
                tx_builder
                    .add_foreign_utxo(f_utxo.0.borrow().into(), input, f_utxo.2)
                    .expect("Error adding foreign_utxo!");
            }
            if let Some(rbf) = &rbf {
                match rbf {
                    RbfValue::RbfDefault => {
                        tx_builder.enable_rbf();
                    }
                    RbfValue::Value(nsequence) => {
                        tx_builder.enable_rbf_with_sequence(Sequence(nsequence.to_owned()));
                    }
                }
            }
            if !data.is_empty() {
                let mut buf = PushBytesBuf::new();
                buf.extend_from_slice(data.as_slice())
                    .map_err(|e| Error::Psbt(e.to_string()))?;

                tx_builder.add_data(&buf.as_push_bytes());
            }

            match tx_builder.finish() {
                Ok(e) => Ok((
                    PartiallySignedTransaction {
                        internal: Mutex::new(e.0),
                    }
                    .serialize()
                    .await,
                    TransactionDetails::from(&e.1),
                )),
                Err(e) => Err(e.into()),
            }
        })
    }

    //========BumpFeeTxBuilder==========
    pub fn bump_fee_tx_builder_finish(
        txid: String,
        fee_rate: f32,
        allow_shrinking: Option<String>,
        wallet_id: String,
        enable_rbf: bool,
        n_sequence: Option<u32>,
    ) -> Result<(String, TransactionDetails), Error> {
        RUNTIME.read().unwrap().clone().block_on(async {
            let txid = Txid::from_str(txid.as_str()).unwrap();
            let binding = Wallet::retrieve_wallet(wallet_id);
            let bdk_wallet = binding.get_wallet().await;

            let mut tx_builder = bdk_wallet.build_fee_bump(txid)?;
            tx_builder.fee_rate(bdk::FeeRate::from_sat_per_vb(fee_rate));
            if let Some(allow_shrinking) = &allow_shrinking {
                let address = BdkAddress::from_str(allow_shrinking)
                    .map_err(|e| Error::Generic(e.to_string()))
                    .unwrap()
                    .assume_checked();
                let script = address.script_pubkey();
                tx_builder.allow_shrinking(script).unwrap();
            }
            if let Some(n_sequence) = n_sequence {
                tx_builder.enable_rbf_with_sequence(Sequence(n_sequence));
            }
            if enable_rbf {
                tx_builder.enable_rbf();
            }
            match tx_builder.finish() {
                Ok(e) => Ok((
                    PartiallySignedTransaction {
                        internal: Mutex::new(e.0),
                    }
                    .serialize()
                    .await,
                    TransactionDetails::from(&e.1),
                )),
                Err(e) => Err(e.into()),
            }
        })
    }

    //================Descriptor=========
    //Checking if the descriptor has any errors
    pub fn create_descriptor(descriptor: String, network: Network) -> Result<String, Error> {
        match BdkDescriptor::new(descriptor, network.into()) {
            Ok(e) => Ok(e.as_string_private()),
            Err(e) => Err(e.into()),
        }
    }
    pub async fn new_bip44_descriptor(
        key_chain_kind: KeychainKind,
        secret_key: String,
        network: Network,
    ) -> Result<String, Error> {
        let key = DescriptorSecretKey::from_string(secret_key)?;
        let descriptor = BdkDescriptor::new_bip44(key, key_chain_kind.into(), network.into()).await;
        Ok(descriptor.as_string_private())
    }
    pub async fn new_bip44_public(
        key_chain_kind: KeychainKind,
        public_key: String,
        network: Network,
        fingerprint: String,
    ) -> Result<String, Error> {
        let key = DescriptorPublicKey::from_string(public_key)?;
        let descriptor = BdkDescriptor::new_bip44_public(
            key,
            fingerprint,
            key_chain_kind.into(),
            network.into(),
        )
        .await;
        Ok(descriptor.as_string())
    }
    pub async fn new_bip49_descriptor(
        key_chain_kind: KeychainKind,
        secret_key: String,
        network: Network,
    ) -> Result<String, Error> {
        let key = DescriptorSecretKey::from_string(secret_key)?;
        let descriptor = BdkDescriptor::new_bip49(key, key_chain_kind.into(), network.into()).await;
        Ok(descriptor.as_string_private())
    }
    pub async fn new_bip49_public(
        key_chain_kind: KeychainKind,
        public_key: String,
        network: Network,
        fingerprint: String,
    ) -> Result<String, Error> {
        let key = DescriptorPublicKey::from_string(public_key)?;
        let descriptor = BdkDescriptor::new_bip49_public(
            key,
            fingerprint,
            key_chain_kind.into(),
            network.into(),
        )
        .await;
        Ok(descriptor.as_string())
    }
    pub async fn new_bip84_descriptor(
        key_chain_kind: KeychainKind,
        secret_key: String,
        network: Network,
    ) -> Result<String, Error> {
        let key = DescriptorSecretKey::from_string(secret_key)?;
        let descriptor = BdkDescriptor::new_bip84(key, key_chain_kind.into(), network.into()).await;
        Ok(descriptor.as_string_private())
    }
    pub async fn new_bip84_public(
        key_chain_kind: KeychainKind,
        public_key: String,
        network: Network,
        fingerprint: String,
    ) -> Result<String, Error> {
        let key: DescriptorPublicKey = DescriptorPublicKey::from_string(public_key)?;
        let descriptor = BdkDescriptor::new_bip84_public(
            key,
            fingerprint,
            key_chain_kind.into(),
            network.into(),
        )
        .await;
        Ok(descriptor.as_string())
    }
    pub fn descriptor_as_string_private(
        descriptor: String,
        network: Network,
    ) -> Result<String, Error> {
        let descriptor = BdkDescriptor::new(descriptor, network.into());
        Ok(descriptor?.as_string_private())
    }
    pub fn descriptor_as_string(descriptor: String, network: Network) -> Result<String, Error> {
        let descriptor = BdkDescriptor::new(descriptor, network.into());
        Ok(descriptor?.as_string())
    }
    pub fn max_satisfaction_weight(descriptor: String, network: Network) -> Result<usize, Error> {
        Ok(BdkDescriptor::new(descriptor, network.into())?.max_satisfaction_weight()?)
    }
    //====================== Descriptor Secret =================
    pub async fn create_descriptor_secret(
        network: Network,
        mnemonic: String,
        password: Option<String>,
    ) -> Result<String, Error> {
        let mnemonic = Mnemonic::from_str(mnemonic.as_str())?;
        Ok(
            DescriptorSecretKey::new(network.into(), mnemonic, password)?
                .as_string()
                .await,
        )
    }
    pub async fn descriptor_secret_from_string(secret: String) -> Result<String, Error> {
        Ok(DescriptorSecretKey::from_string(secret)?.as_string().await)
    }
    pub async fn extend_descriptor_secret(secret: String, path: String) -> String {
        let res = Self::descriptor_secret_config(secret, Some(path), false).await;
        res.as_string().await
    }
    pub async fn derive_descriptor_secret(secret: String, path: String) -> String {
        let res = Self::descriptor_secret_config(secret, Some(path), true).await;
        res.as_string().await
    }
    pub async fn descriptor_secret_as_secret_bytes(secret: String) -> Result<Vec<u8>, Error> {
        let secret = BdkDescriptorSecretKey::from_str(secret.as_str())?;
        let descriptor_secret = DescriptorSecretKey {
            descriptor_secret_key_mutex: Mutex::new(secret),
        };
        Ok(descriptor_secret.secret_bytes().await?)
    }
    pub async fn descriptor_secret_as_public(secret: String) -> Result<String, Error> {
        let secret = BdkDescriptorSecretKey::from_str(secret.as_str())?;
        let descriptor_secret = DescriptorSecretKey {
            descriptor_secret_key_mutex: Mutex::new(secret),
        };
        Ok(descriptor_secret.as_public().await?.as_string().await)
    }
    async fn descriptor_secret_config(
        secret: String,
        path: Option<String>,
        derive: bool,
    ) -> Arc<DescriptorSecretKey> {
        let secret = match BdkDescriptorSecretKey::from_str(secret.as_str()) {
            Ok(e) => e,
            Err(e) => panic!("{:?}", e),
        };
        let descriptor_secret = DescriptorSecretKey {
            descriptor_secret_key_mutex: Mutex::new(secret),
        };

        if path.is_none() {
            return Arc::new(descriptor_secret);
        }
        let derivation_path =
            Arc::new(DerivationPath::new(path.unwrap().to_string()).expect("Invalid path"));
        if derive {
            match descriptor_secret.derive(derivation_path).await {
                Ok(e) => e,
                Err(e) => panic!("{:?}", e),
            }
        } else {
            match descriptor_secret.extend(derivation_path).await {
                Ok(e) => e,
                Err(e) => panic!("{:?}", e),
            }
        }
    }

    //==============Derivation Path ==========
    pub async fn create_derivation_path(path: String) -> Result<String, Error> {
        Ok(DerivationPath::new(path)?.as_string().await)
    }

    //================Descriptor Public=========
    pub async fn descriptor_public_from_string(public_key: String) -> Result<String, Error> {
        Ok(DescriptorPublicKey::from_string(public_key)?
            .as_string()
            .await)
    }
    pub async fn create_descriptor_public(
        xpub: Option<String>,
        path: String,
        derive: bool,
    ) -> Result<String, Error> {
        let derivation_path = Arc::new(DerivationPath::new(path.to_string()).unwrap());
        let descriptor_public = DescriptorPublicKey::from_string(xpub.unwrap()).unwrap();
        if derive {
            Ok(descriptor_public
                .derive(derivation_path)
                .await?
                .as_string()
                .await)
        } else {
            Ok(descriptor_public
                .extend(derivation_path)
                .await?
                .as_string()
                .await)
        }
    }

    //============ Script Class===========
    // pub fn create_script(raw_output_script: Vec<u8>) -> Result<Script, Error> {
    //     Ok(Script::new(raw_output_script)?)
    // }

    //================Address============
    pub fn create_address(address: String) -> anyhow::Result<String, Error> {
        Ok(Address::new(address)?.address.to_string())
    }
    pub fn address_from_script(script: Script, network: Network) -> anyhow::Result<String, Error> {
        Ok(Address::from_script(script.into(), network)?
            .address
            .to_string())
    }
    pub fn address_to_script_pubkey(address: String) -> anyhow::Result<Script, Error> {
        Ok(Address::new(address)?.script_pubkey())
    }
    // pub fn payload(address: String) -> anyhow::Result<Payload, Error> {
    //     Ok(Address::new(address)?.payload())
    // }
    pub fn address_network(address: String) -> anyhow::Result<Network, Error> {
        Ok(Address::new(address)?.network())
    }

    //========Wallet==========
    pub fn create_wallet(
        descriptor: String,
        change_descriptor: Option<String>,
        network: Network,
        database_config: DatabaseConfig,
    ) -> Result<String, Error> {
        Ok(Wallet::new_wallet(
            descriptor,
            change_descriptor,
            network.into(),
            database_config,
        )?)
    }

    pub async fn get_address(
        wallet_id: String,
        address_index: AddressIndex,
    ) -> Result<AddressInfo, Error> {
        Ok(Wallet::retrieve_wallet(wallet_id)
            .get_address(address_index)
            .await?)
    }
    pub async fn is_mine(script: Script, wallet_id: String) -> Result<bool, Error> {
        Ok(Wallet::retrieve_wallet(wallet_id)
            .is_mine(script.into())
            .await?)
    }
    pub async fn get_internal_address(
        wallet_id: String,
        address_index: AddressIndex,
    ) -> Result<AddressInfo, Error> {
        Ok(Wallet::retrieve_wallet(wallet_id)
            .get_internal_address(address_index)
            .await?)
    }
    pub fn sync_wallet(wallet_id: String, blockchain_id: String) {
        warn!("warn sync_wallet: start syncing");
        info!("sync_wallet: start syncing");
        RUNTIME.read().unwrap().clone().block_on(async {
            // Call your async function here.
            Wallet::retrieve_wallet(wallet_id)
                .sync(Blockchain::retrieve_blockchain(blockchain_id).deref(), None)
                .await;
        });
        info!("sync_wallet: end syncing");
    }
    pub async fn get_balance(wallet_id: String) -> Result<Balance, Error> {
        Ok(Wallet::retrieve_wallet(wallet_id).get_balance().await?)
    }
    pub async fn list_unspent_outputs(wallet_id: String) -> Result<Vec<LocalUtxo>, Error> {
        Ok(Wallet::retrieve_wallet(wallet_id).list_unspent().await?)
    }
    pub async fn get_transactions(
        wallet_id: String,
        include_raw: bool,
    ) -> Result<Vec<TransactionDetails>, Error> {
        Ok(Wallet::retrieve_wallet(wallet_id)
            .list_transactions(include_raw)
            .await?)
    }
    pub async fn sign(
        wallet_id: String,
        psbt_str: String,
        sign_options: Option<SignOptions>,
    ) -> Result<Option<String>, Error> {
        let psbt = PartiallySignedTransaction::new(psbt_str)?;
        let signed = Wallet::retrieve_wallet(wallet_id)
            .sign(&psbt, sign_options.clone())
            .await?;
        match signed {
            true => Ok(Some(psbt.serialize().await)),
            false => {
                if let Some(sign_option) = sign_options {
                    if sign_option.is_multi_sig {
                        Ok(Some(psbt.serialize().await))
                    } else {
                        Ok(None)
                    }
                } else {
                    Ok(None)
                }
            }
        }
    }
    pub async fn wallet_network(wallet_id: String) -> Network {
        Wallet::retrieve_wallet(wallet_id)
            .get_wallet()
            .await
            .network()
            .into()
    }
    pub async fn list_unspent(wallet_id: String) -> Result<Vec<LocalUtxo>, Error> {
        Ok(Wallet::retrieve_wallet(wallet_id).list_unspent().await?)
    }
    /// get the corresponding PSBT Input for a LocalUtxo
    pub async fn get_psbt_input(
        wallet_id: String,
        utxo: LocalUtxo,
        only_witness_utxo: bool,
        psbt_sighash_type: Option<PsbtSigHashType>,
    ) -> Result<String, Error> {
        let input = Wallet::retrieve_wallet(wallet_id)
            .get_psbt_input(utxo, only_witness_utxo, psbt_sighash_type)
            .await?;
        Ok(serde_json::to_string(&input)?)
    }

    pub async fn get_descriptor_for_keychain(
        wallet_id: String,
        keychain: KeychainKind,
    ) -> Result<(String, Network), Error> {
        let wallet = Wallet::retrieve_wallet(wallet_id);
        let network: Network = wallet.get_wallet().await.network().into();
        match wallet.get_descriptor_for_keychain(keychain).await {
            Ok(e) => Ok((e.as_string_private(), network)),
            Err(e) => Err(e.into()),
        }
    }
    //================== Mnemonic ==========
    pub fn generate_seed_from_word_count(word_count: WordCount) -> String {
        let mnemonic = Mnemonic::new(word_count.into());
        mnemonic.as_string()
    }
    pub fn generate_seed_from_string(mnemonic: String) -> Result<String, Error> {
        Ok(Mnemonic::from_str(mnemonic.as_str())?.as_string())
    }
    pub fn generate_seed_from_entropy(entropy: Vec<u8>) -> Result<String, Error> {
        Ok(Mnemonic::from_entropy(entropy)?.as_string())
    }
}

#[cfg(test)]
mod test {
    use bdk::KeychainKind;
    use bitcoin::Network;
    use log::info;
    use std::{ops::Deref, str::FromStr};

    use crate::{
        api::{
            api_service::{
                proton_api_service::ProtonAPIService, wallet_auth_store::ProtonWalletAuthStore,
            },
            proton_api::retrieve_proton_api,
        },
        bdk::{
            blockchain::{Blockchain, EsploraConfig},
            descriptor::BdkDescriptor,
            key::{DescriptorSecretKey, Mnemonic},
        },
    };

    use super::Wallet;

    #[tokio::test]
    #[ignore]
    async fn test_wallet_import_sync() {
        // let alice_mnemonic = Mnemonic::from_str("certain sense kiss guide crumble hint transfer crime much stereo warm coral".to_string()).unwrap().as_string();
        let network = Network::Testnet;
        // let mnemonic = Mnemonic::from_str("certain sense kiss guide crumble hint transfer crime much stereo warm coral".to_string()).unwrap();
        let mnemonic = Mnemonic::from_str(
            "elbow guide topple state museum project goat split afraid rebuild hour destroy",
        )
        .unwrap();
        // let mnemonic = Mnemonic::from_str("category law logic swear involve banner pink room diesel fragile sunset remove whale lounge captain code hobby lesson material current moment funny vast fade".to_string()).unwrap();
        // let mnemonic = Mnemonic::from_str("deputy hollow damp frozen caught embark ostrich heart verify warrior blame enough".to_string()).unwrap();

        let key = DescriptorSecretKey::new(network, mnemonic, None).unwrap();
        // let key = DescriptorSecretKey::from_string(secret_key)?;
        let descriptor = BdkDescriptor::new_bip84(key, KeychainKind::External, network).await;

        let wallet_id = Wallet::new_wallet(
            descriptor.as_string(),
            None,
            Network::Testnet,
            super::DatabaseConfig::Memory,
        )
        .unwrap();
        let wallet = Wallet::retrieve_wallet(wallet_id);
        let app_version = "android-wallet@1.0.0".to_string();
        let user_agent = "ProtonWallet/1.0.0 (iOS/17.4; arm64)".to_string();
        let store = ProtonWalletAuthStore::new("altas").unwrap();
        let mut api_service =
            ProtonAPIService::new("atlas".to_string(), app_version, user_agent, store).unwrap();
        let _ = api_service
            .login("pro".to_string(), "pro".to_string())
            .await;

        api_service.set_proton_api();
        let proton_api = retrieve_proton_api();
        let config = EsploraConfig {
            base_url: "https://blockstream.info/testnet/api".to_string(),
            proxy: None,
            concurrency: Some(4),
            stop_gap: 10,
            timeout: None,
        };
        let blockchain_id =
            Blockchain::new_blockchain_with_api(config, proton_api.inner.clone()).unwrap();
        let blockchain = Blockchain::retrieve_blockchain(blockchain_id);

        println!("start syncing");
        info!("start syncing");
        wallet.sync(blockchain.deref(), None).await;

        println!("start syncing second time");
        wallet.sync(blockchain.deref(), None).await;

        println!("start getting banlance");
        let balance = wallet.get_balance().await.unwrap();
        println!("balance {:?}", balance.confirmed);
        assert!(balance.confirmed != 0);

        println!("check fee");
        let fee_rate = blockchain.estimate_fee(100).await.unwrap();
        println!("fee rate: {}", fee_rate.as_sat_per_vb());

        assert!(fee_rate.as_sat_per_vb() > 0.0);
    }

    #[tokio::test]
    #[ignore]
    async fn test_wallet_import_sync_then_send() {
        let network = Network::Testnet;
        let mnemonic = Mnemonic::from_str(
            "elbow guide topple state museum project goat split afraid rebuild hour destroy",
        )
        .unwrap();
        let key = DescriptorSecretKey::new(network, mnemonic, None).unwrap();
        let descriptor = BdkDescriptor::new_bip84(key, KeychainKind::External, network).await;

        let wallet_id = Wallet::new_wallet(
            descriptor.as_string(),
            None,
            Network::Testnet,
            super::DatabaseConfig::Memory,
        )
        .unwrap();

        let wallet = Wallet::retrieve_wallet(wallet_id);

        let app_version = "android-wallet@1.0.0".to_string();
        let user_agent = "ProtonWallet/1.0.0 (iOS/17.4; arm64)".to_string();
        let env = "altas";
        let store = ProtonWalletAuthStore::new(env).unwrap();
        let mut api_service =
            ProtonAPIService::new(env.to_string(), app_version, user_agent, store).unwrap();
        let _ = api_service
            .login("pro".to_string(), "pro".to_string())
            .await;
        api_service.set_proton_api();

        let proton_api = retrieve_proton_api();
        let config = EsploraConfig {
            base_url: "https://blockstream.info/testnet/api".to_string(),
            proxy: None,
            concurrency: Some(4),
            stop_gap: 10,
            timeout: None,
        };
        let blockchain_id =
            Blockchain::new_blockchain_with_api(config, proton_api.inner.clone()).unwrap();
        let blockchain = Blockchain::retrieve_blockchain(blockchain_id);

        println!("start syncing");
        info!("start syncing");
        wallet.sync(blockchain.deref(), None).await;

        println!("start getting banlance");
        let balance = wallet.get_balance().await.unwrap();
        println!("balance {:?}", balance.confirmed);
        assert!(balance.confirmed != 0);

        println!("check fee");
        let fee_rate = blockchain.estimate_fee(100).await.unwrap();
        println!("fee rate: {}", fee_rate.as_sat_per_vb());

        assert!(fee_rate.as_sat_per_vb() > 0.0);
    }
}
