// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.24.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/api2.dart';
import 'api/ldk_api.dart';
import 'api/proton_api.dart';
import 'api/rust_api.dart';
import 'api/rust_objects.dart';
import 'bdk/blockchain.dart';
import 'bdk/error.dart';
import 'bdk/types.dart';
import 'bdk/wallet.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';
import 'proton_api/errors.dart';
import 'proton_api/types.dart';
import 'proton_api/wallet_account_routes.dart';
import 'proton_api/wallet_routes.dart';
import 'proton_api/wallet_settings_routes.dart';

abstract class RustLibApiImplPlatform extends BaseApiImpl<RustLibWire> {
  RustLibApiImplPlatform({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @protected
  AnyhowException dco_decode_AnyhowException(dynamic raw);

  @protected
  String dco_decode_String(dynamic raw);

  @protected
  AddressIndex dco_decode_address_index(dynamic raw);

  @protected
  AddressInfo dco_decode_address_info(dynamic raw);

  @protected
  ApiError dco_decode_api_error(dynamic raw);

  @protected
  AuthInfo dco_decode_auth_info(dynamic raw);

  @protected
  Balance dco_decode_balance(dynamic raw);

  @protected
  BlockTime dco_decode_block_time(dynamic raw);

  @protected
  bool dco_decode_bool(dynamic raw);

  @protected
  AddressIndex dco_decode_box_autoadd_address_index(dynamic raw);

  @protected
  BlockTime dco_decode_box_autoadd_block_time(dynamic raw);

  @protected
  CreateWalletAccountReq dco_decode_box_autoadd_create_wallet_account_req(
      dynamic raw);

  @protected
  CreateWalletReq dco_decode_box_autoadd_create_wallet_req(dynamic raw);

  @protected
  DatabaseConfig dco_decode_box_autoadd_database_config(dynamic raw);

  @protected
  ElectrumConfig dco_decode_box_autoadd_electrum_config(dynamic raw);

  @protected
  EsploraConfig dco_decode_box_autoadd_esplora_config(dynamic raw);

  @protected
  double dco_decode_box_autoadd_f_32(dynamic raw);

  @protected
  LocalUtxo dco_decode_box_autoadd_local_utxo(dynamic raw);

  @protected
  MyTestObject dco_decode_box_autoadd_my_test_object(dynamic raw);

  @protected
  OutPoint dco_decode_box_autoadd_out_point(dynamic raw);

  @protected
  PsbtSigHashType dco_decode_box_autoadd_psbt_sig_hash_type(dynamic raw);

  @protected
  RbfValue dco_decode_box_autoadd_rbf_value(dynamic raw);

  @protected
  (OutPoint, String, int) dco_decode_box_autoadd_record_out_point_string_usize(
      dynamic raw);

  @protected
  Script dco_decode_box_autoadd_script(dynamic raw);

  @protected
  SignOptions dco_decode_box_autoadd_sign_options(dynamic raw);

  @protected
  SledDbConfiguration dco_decode_box_autoadd_sled_db_configuration(dynamic raw);

  @protected
  SqliteDbConfiguration dco_decode_box_autoadd_sqlite_db_configuration(
      dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_32(dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_64(dynamic raw);

  @protected
  int dco_decode_box_autoadd_u_8(dynamic raw);

  @protected
  WalletSettings dco_decode_box_autoadd_wallet_settings(dynamic raw);

  @protected
  ChangeSpendPolicy dco_decode_change_spend_policy(dynamic raw);

  @protected
  CreateWalletAccountReq dco_decode_create_wallet_account_req(dynamic raw);

  @protected
  CreateWalletReq dco_decode_create_wallet_req(dynamic raw);

  @protected
  CreateWalletResponse dco_decode_create_wallet_response(dynamic raw);

  @protected
  DatabaseConfig dco_decode_database_config(dynamic raw);

  @protected
  ElectrumConfig dco_decode_electrum_config(dynamic raw);

  @protected
  Error dco_decode_error(dynamic raw);

  @protected
  EsploraConfig dco_decode_esplora_config(dynamic raw);

  @protected
  double dco_decode_f_32(dynamic raw);

  @protected
  int dco_decode_i_32(dynamic raw);

  @protected
  int dco_decode_i_64(dynamic raw);

  @protected
  int dco_decode_i_8(dynamic raw);

  @protected
  KeychainKind dco_decode_keychain_kind(dynamic raw);

  @protected
  List<String> dco_decode_list_String(dynamic raw);

  @protected
  List<LocalUtxo> dco_decode_list_local_utxo(dynamic raw);

  @protected
  List<OutPoint> dco_decode_list_out_point(dynamic raw);

  @protected
  List<int> dco_decode_list_prim_u_8_loose(dynamic raw);

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw);

  @protected
  List<ScriptAmount> dco_decode_list_script_amount(dynamic raw);

  @protected
  List<TransactionDetails> dco_decode_list_transaction_details(dynamic raw);

  @protected
  List<TxIn> dco_decode_list_tx_in(dynamic raw);

  @protected
  List<TxOut> dco_decode_list_tx_out(dynamic raw);

  @protected
  List<WalletAccount> dco_decode_list_wallet_account(dynamic raw);

  @protected
  List<WalletData> dco_decode_list_wallet_data(dynamic raw);

  @protected
  LocalUtxo dco_decode_local_utxo(dynamic raw);

  @protected
  MyTestObject dco_decode_my_test_object(dynamic raw);

  @protected
  Network dco_decode_network(dynamic raw);

  @protected
  String? dco_decode_opt_String(dynamic raw);

  @protected
  BlockTime? dco_decode_opt_box_autoadd_block_time(dynamic raw);

  @protected
  double? dco_decode_opt_box_autoadd_f_32(dynamic raw);

  @protected
  PsbtSigHashType? dco_decode_opt_box_autoadd_psbt_sig_hash_type(dynamic raw);

  @protected
  RbfValue? dco_decode_opt_box_autoadd_rbf_value(dynamic raw);

  @protected
  (OutPoint, String, int)?
      dco_decode_opt_box_autoadd_record_out_point_string_usize(dynamic raw);

  @protected
  Script? dco_decode_opt_box_autoadd_script(dynamic raw);

  @protected
  SignOptions? dco_decode_opt_box_autoadd_sign_options(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_32(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_64(dynamic raw);

  @protected
  int? dco_decode_opt_box_autoadd_u_8(dynamic raw);

  @protected
  WalletSettings? dco_decode_opt_box_autoadd_wallet_settings(dynamic raw);

  @protected
  OutPoint dco_decode_out_point(dynamic raw);

  @protected
  Payload dco_decode_payload(dynamic raw);

  @protected
  ProtonWallet dco_decode_proton_wallet(dynamic raw);

  @protected
  ProtonWalletKey dco_decode_proton_wallet_key(dynamic raw);

  @protected
  PsbtSigHashType dco_decode_psbt_sig_hash_type(dynamic raw);

  @protected
  RbfValue dco_decode_rbf_value(dynamic raw);

  @protected
  (OutPoint, String, int) dco_decode_record_out_point_string_usize(dynamic raw);

  @protected
  (String, Network) dco_decode_record_string_network(dynamic raw);

  @protected
  (String, TransactionDetails) dco_decode_record_string_transaction_details(
      dynamic raw);

  @protected
  ResponseCode dco_decode_response_code(dynamic raw);

  @protected
  Script dco_decode_script(dynamic raw);

  @protected
  ScriptAmount dco_decode_script_amount(dynamic raw);

  @protected
  SignOptions dco_decode_sign_options(dynamic raw);

  @protected
  SledDbConfiguration dco_decode_sled_db_configuration(dynamic raw);

  @protected
  SqliteDbConfiguration dco_decode_sqlite_db_configuration(dynamic raw);

  @protected
  TransactionDetails dco_decode_transaction_details(dynamic raw);

  @protected
  TxIn dco_decode_tx_in(dynamic raw);

  @protected
  TxOut dco_decode_tx_out(dynamic raw);

  @protected
  int dco_decode_u_32(dynamic raw);

  @protected
  int dco_decode_u_64(dynamic raw);

  @protected
  int dco_decode_u_8(dynamic raw);

  @protected
  void dco_decode_unit(dynamic raw);

  @protected
  int dco_decode_usize(dynamic raw);

  @protected
  WalletAccount dco_decode_wallet_account(dynamic raw);

  @protected
  WalletAccountResponse dco_decode_wallet_account_response(dynamic raw);

  @protected
  WalletAccountsResponse dco_decode_wallet_accounts_response(dynamic raw);

  @protected
  WalletData dco_decode_wallet_data(dynamic raw);

  @protected
  WalletSettings dco_decode_wallet_settings(dynamic raw);

  @protected
  WalletsResponse dco_decode_wallets_response(dynamic raw);

  @protected
  WitnessVersion dco_decode_witness_version(dynamic raw);

  @protected
  WordCount dco_decode_word_count(dynamic raw);

  @protected
  AnyhowException sse_decode_AnyhowException(SseDeserializer deserializer);

  @protected
  String sse_decode_String(SseDeserializer deserializer);

  @protected
  AddressIndex sse_decode_address_index(SseDeserializer deserializer);

  @protected
  AddressInfo sse_decode_address_info(SseDeserializer deserializer);

  @protected
  ApiError sse_decode_api_error(SseDeserializer deserializer);

  @protected
  AuthInfo sse_decode_auth_info(SseDeserializer deserializer);

  @protected
  Balance sse_decode_balance(SseDeserializer deserializer);

  @protected
  BlockTime sse_decode_block_time(SseDeserializer deserializer);

  @protected
  bool sse_decode_bool(SseDeserializer deserializer);

  @protected
  AddressIndex sse_decode_box_autoadd_address_index(
      SseDeserializer deserializer);

  @protected
  BlockTime sse_decode_box_autoadd_block_time(SseDeserializer deserializer);

  @protected
  CreateWalletAccountReq sse_decode_box_autoadd_create_wallet_account_req(
      SseDeserializer deserializer);

  @protected
  CreateWalletReq sse_decode_box_autoadd_create_wallet_req(
      SseDeserializer deserializer);

  @protected
  DatabaseConfig sse_decode_box_autoadd_database_config(
      SseDeserializer deserializer);

  @protected
  ElectrumConfig sse_decode_box_autoadd_electrum_config(
      SseDeserializer deserializer);

  @protected
  EsploraConfig sse_decode_box_autoadd_esplora_config(
      SseDeserializer deserializer);

  @protected
  double sse_decode_box_autoadd_f_32(SseDeserializer deserializer);

  @protected
  LocalUtxo sse_decode_box_autoadd_local_utxo(SseDeserializer deserializer);

  @protected
  MyTestObject sse_decode_box_autoadd_my_test_object(
      SseDeserializer deserializer);

  @protected
  OutPoint sse_decode_box_autoadd_out_point(SseDeserializer deserializer);

  @protected
  PsbtSigHashType sse_decode_box_autoadd_psbt_sig_hash_type(
      SseDeserializer deserializer);

  @protected
  RbfValue sse_decode_box_autoadd_rbf_value(SseDeserializer deserializer);

  @protected
  (OutPoint, String, int) sse_decode_box_autoadd_record_out_point_string_usize(
      SseDeserializer deserializer);

  @protected
  Script sse_decode_box_autoadd_script(SseDeserializer deserializer);

  @protected
  SignOptions sse_decode_box_autoadd_sign_options(SseDeserializer deserializer);

  @protected
  SledDbConfiguration sse_decode_box_autoadd_sled_db_configuration(
      SseDeserializer deserializer);

  @protected
  SqliteDbConfiguration sse_decode_box_autoadd_sqlite_db_configuration(
      SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_box_autoadd_u_8(SseDeserializer deserializer);

  @protected
  WalletSettings sse_decode_box_autoadd_wallet_settings(
      SseDeserializer deserializer);

  @protected
  ChangeSpendPolicy sse_decode_change_spend_policy(
      SseDeserializer deserializer);

  @protected
  CreateWalletAccountReq sse_decode_create_wallet_account_req(
      SseDeserializer deserializer);

  @protected
  CreateWalletReq sse_decode_create_wallet_req(SseDeserializer deserializer);

  @protected
  CreateWalletResponse sse_decode_create_wallet_response(
      SseDeserializer deserializer);

  @protected
  DatabaseConfig sse_decode_database_config(SseDeserializer deserializer);

  @protected
  ElectrumConfig sse_decode_electrum_config(SseDeserializer deserializer);

  @protected
  Error sse_decode_error(SseDeserializer deserializer);

  @protected
  EsploraConfig sse_decode_esplora_config(SseDeserializer deserializer);

  @protected
  double sse_decode_f_32(SseDeserializer deserializer);

  @protected
  int sse_decode_i_32(SseDeserializer deserializer);

  @protected
  int sse_decode_i_64(SseDeserializer deserializer);

  @protected
  int sse_decode_i_8(SseDeserializer deserializer);

  @protected
  KeychainKind sse_decode_keychain_kind(SseDeserializer deserializer);

  @protected
  List<String> sse_decode_list_String(SseDeserializer deserializer);

  @protected
  List<LocalUtxo> sse_decode_list_local_utxo(SseDeserializer deserializer);

  @protected
  List<OutPoint> sse_decode_list_out_point(SseDeserializer deserializer);

  @protected
  List<int> sse_decode_list_prim_u_8_loose(SseDeserializer deserializer);

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer);

  @protected
  List<ScriptAmount> sse_decode_list_script_amount(
      SseDeserializer deserializer);

  @protected
  List<TransactionDetails> sse_decode_list_transaction_details(
      SseDeserializer deserializer);

  @protected
  List<TxIn> sse_decode_list_tx_in(SseDeserializer deserializer);

  @protected
  List<TxOut> sse_decode_list_tx_out(SseDeserializer deserializer);

  @protected
  List<WalletAccount> sse_decode_list_wallet_account(
      SseDeserializer deserializer);

  @protected
  List<WalletData> sse_decode_list_wallet_data(SseDeserializer deserializer);

  @protected
  LocalUtxo sse_decode_local_utxo(SseDeserializer deserializer);

  @protected
  MyTestObject sse_decode_my_test_object(SseDeserializer deserializer);

  @protected
  Network sse_decode_network(SseDeserializer deserializer);

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer);

  @protected
  BlockTime? sse_decode_opt_box_autoadd_block_time(
      SseDeserializer deserializer);

  @protected
  double? sse_decode_opt_box_autoadd_f_32(SseDeserializer deserializer);

  @protected
  PsbtSigHashType? sse_decode_opt_box_autoadd_psbt_sig_hash_type(
      SseDeserializer deserializer);

  @protected
  RbfValue? sse_decode_opt_box_autoadd_rbf_value(SseDeserializer deserializer);

  @protected
  (OutPoint, String, int)?
      sse_decode_opt_box_autoadd_record_out_point_string_usize(
          SseDeserializer deserializer);

  @protected
  Script? sse_decode_opt_box_autoadd_script(SseDeserializer deserializer);

  @protected
  SignOptions? sse_decode_opt_box_autoadd_sign_options(
      SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_32(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_64(SseDeserializer deserializer);

  @protected
  int? sse_decode_opt_box_autoadd_u_8(SseDeserializer deserializer);

  @protected
  WalletSettings? sse_decode_opt_box_autoadd_wallet_settings(
      SseDeserializer deserializer);

  @protected
  OutPoint sse_decode_out_point(SseDeserializer deserializer);

  @protected
  Payload sse_decode_payload(SseDeserializer deserializer);

  @protected
  ProtonWallet sse_decode_proton_wallet(SseDeserializer deserializer);

  @protected
  ProtonWalletKey sse_decode_proton_wallet_key(SseDeserializer deserializer);

  @protected
  PsbtSigHashType sse_decode_psbt_sig_hash_type(SseDeserializer deserializer);

  @protected
  RbfValue sse_decode_rbf_value(SseDeserializer deserializer);

  @protected
  (OutPoint, String, int) sse_decode_record_out_point_string_usize(
      SseDeserializer deserializer);

  @protected
  (String, Network) sse_decode_record_string_network(
      SseDeserializer deserializer);

  @protected
  (String, TransactionDetails) sse_decode_record_string_transaction_details(
      SseDeserializer deserializer);

  @protected
  ResponseCode sse_decode_response_code(SseDeserializer deserializer);

  @protected
  Script sse_decode_script(SseDeserializer deserializer);

  @protected
  ScriptAmount sse_decode_script_amount(SseDeserializer deserializer);

  @protected
  SignOptions sse_decode_sign_options(SseDeserializer deserializer);

  @protected
  SledDbConfiguration sse_decode_sled_db_configuration(
      SseDeserializer deserializer);

  @protected
  SqliteDbConfiguration sse_decode_sqlite_db_configuration(
      SseDeserializer deserializer);

  @protected
  TransactionDetails sse_decode_transaction_details(
      SseDeserializer deserializer);

  @protected
  TxIn sse_decode_tx_in(SseDeserializer deserializer);

  @protected
  TxOut sse_decode_tx_out(SseDeserializer deserializer);

  @protected
  int sse_decode_u_32(SseDeserializer deserializer);

  @protected
  int sse_decode_u_64(SseDeserializer deserializer);

  @protected
  int sse_decode_u_8(SseDeserializer deserializer);

  @protected
  void sse_decode_unit(SseDeserializer deserializer);

  @protected
  int sse_decode_usize(SseDeserializer deserializer);

  @protected
  WalletAccount sse_decode_wallet_account(SseDeserializer deserializer);

  @protected
  WalletAccountResponse sse_decode_wallet_account_response(
      SseDeserializer deserializer);

  @protected
  WalletAccountsResponse sse_decode_wallet_accounts_response(
      SseDeserializer deserializer);

  @protected
  WalletData sse_decode_wallet_data(SseDeserializer deserializer);

  @protected
  WalletSettings sse_decode_wallet_settings(SseDeserializer deserializer);

  @protected
  WalletsResponse sse_decode_wallets_response(SseDeserializer deserializer);

  @protected
  WitnessVersion sse_decode_witness_version(SseDeserializer deserializer);

  @protected
  WordCount sse_decode_word_count(SseDeserializer deserializer);

  @protected
  void sse_encode_AnyhowException(
      AnyhowException self, SseSerializer serializer);

  @protected
  void sse_encode_String(String self, SseSerializer serializer);

  @protected
  void sse_encode_address_index(AddressIndex self, SseSerializer serializer);

  @protected
  void sse_encode_address_info(AddressInfo self, SseSerializer serializer);

  @protected
  void sse_encode_api_error(ApiError self, SseSerializer serializer);

  @protected
  void sse_encode_auth_info(AuthInfo self, SseSerializer serializer);

  @protected
  void sse_encode_balance(Balance self, SseSerializer serializer);

  @protected
  void sse_encode_block_time(BlockTime self, SseSerializer serializer);

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_address_index(
      AddressIndex self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_block_time(
      BlockTime self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_create_wallet_account_req(
      CreateWalletAccountReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_create_wallet_req(
      CreateWalletReq self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_database_config(
      DatabaseConfig self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_electrum_config(
      ElectrumConfig self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_esplora_config(
      EsploraConfig self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_f_32(double self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_local_utxo(
      LocalUtxo self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_my_test_object(
      MyTestObject self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_out_point(
      OutPoint self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_psbt_sig_hash_type(
      PsbtSigHashType self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_rbf_value(
      RbfValue self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_record_out_point_string_usize(
      (OutPoint, String, int) self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_script(Script self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_sign_options(
      SignOptions self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_sled_db_configuration(
      SledDbConfiguration self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_sqlite_db_configuration(
      SqliteDbConfiguration self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_box_autoadd_wallet_settings(
      WalletSettings self, SseSerializer serializer);

  @protected
  void sse_encode_change_spend_policy(
      ChangeSpendPolicy self, SseSerializer serializer);

  @protected
  void sse_encode_create_wallet_account_req(
      CreateWalletAccountReq self, SseSerializer serializer);

  @protected
  void sse_encode_create_wallet_req(
      CreateWalletReq self, SseSerializer serializer);

  @protected
  void sse_encode_create_wallet_response(
      CreateWalletResponse self, SseSerializer serializer);

  @protected
  void sse_encode_database_config(
      DatabaseConfig self, SseSerializer serializer);

  @protected
  void sse_encode_electrum_config(
      ElectrumConfig self, SseSerializer serializer);

  @protected
  void sse_encode_error(Error self, SseSerializer serializer);

  @protected
  void sse_encode_esplora_config(EsploraConfig self, SseSerializer serializer);

  @protected
  void sse_encode_f_32(double self, SseSerializer serializer);

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_i_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_i_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_keychain_kind(KeychainKind self, SseSerializer serializer);

  @protected
  void sse_encode_list_String(List<String> self, SseSerializer serializer);

  @protected
  void sse_encode_list_local_utxo(
      List<LocalUtxo> self, SseSerializer serializer);

  @protected
  void sse_encode_list_out_point(List<OutPoint> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_loose(List<int> self, SseSerializer serializer);

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer);

  @protected
  void sse_encode_list_script_amount(
      List<ScriptAmount> self, SseSerializer serializer);

  @protected
  void sse_encode_list_transaction_details(
      List<TransactionDetails> self, SseSerializer serializer);

  @protected
  void sse_encode_list_tx_in(List<TxIn> self, SseSerializer serializer);

  @protected
  void sse_encode_list_tx_out(List<TxOut> self, SseSerializer serializer);

  @protected
  void sse_encode_list_wallet_account(
      List<WalletAccount> self, SseSerializer serializer);

  @protected
  void sse_encode_list_wallet_data(
      List<WalletData> self, SseSerializer serializer);

  @protected
  void sse_encode_local_utxo(LocalUtxo self, SseSerializer serializer);

  @protected
  void sse_encode_my_test_object(MyTestObject self, SseSerializer serializer);

  @protected
  void sse_encode_network(Network self, SseSerializer serializer);

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_block_time(
      BlockTime? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_f_32(double? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_psbt_sig_hash_type(
      PsbtSigHashType? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_rbf_value(
      RbfValue? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_record_out_point_string_usize(
      (OutPoint, String, int)? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_script(
      Script? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_sign_options(
      SignOptions? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_32(int? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_64(int? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_u_8(int? self, SseSerializer serializer);

  @protected
  void sse_encode_opt_box_autoadd_wallet_settings(
      WalletSettings? self, SseSerializer serializer);

  @protected
  void sse_encode_out_point(OutPoint self, SseSerializer serializer);

  @protected
  void sse_encode_payload(Payload self, SseSerializer serializer);

  @protected
  void sse_encode_proton_wallet(ProtonWallet self, SseSerializer serializer);

  @protected
  void sse_encode_proton_wallet_key(
      ProtonWalletKey self, SseSerializer serializer);

  @protected
  void sse_encode_psbt_sig_hash_type(
      PsbtSigHashType self, SseSerializer serializer);

  @protected
  void sse_encode_rbf_value(RbfValue self, SseSerializer serializer);

  @protected
  void sse_encode_record_out_point_string_usize(
      (OutPoint, String, int) self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_network(
      (String, Network) self, SseSerializer serializer);

  @protected
  void sse_encode_record_string_transaction_details(
      (String, TransactionDetails) self, SseSerializer serializer);

  @protected
  void sse_encode_response_code(ResponseCode self, SseSerializer serializer);

  @protected
  void sse_encode_script(Script self, SseSerializer serializer);

  @protected
  void sse_encode_script_amount(ScriptAmount self, SseSerializer serializer);

  @protected
  void sse_encode_sign_options(SignOptions self, SseSerializer serializer);

  @protected
  void sse_encode_sled_db_configuration(
      SledDbConfiguration self, SseSerializer serializer);

  @protected
  void sse_encode_sqlite_db_configuration(
      SqliteDbConfiguration self, SseSerializer serializer);

  @protected
  void sse_encode_transaction_details(
      TransactionDetails self, SseSerializer serializer);

  @protected
  void sse_encode_tx_in(TxIn self, SseSerializer serializer);

  @protected
  void sse_encode_tx_out(TxOut self, SseSerializer serializer);

  @protected
  void sse_encode_u_32(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_64(int self, SseSerializer serializer);

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer);

  @protected
  void sse_encode_unit(void self, SseSerializer serializer);

  @protected
  void sse_encode_usize(int self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_account(WalletAccount self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_account_response(
      WalletAccountResponse self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_accounts_response(
      WalletAccountsResponse self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_data(WalletData self, SseSerializer serializer);

  @protected
  void sse_encode_wallet_settings(
      WalletSettings self, SseSerializer serializer);

  @protected
  void sse_encode_wallets_response(
      WalletsResponse self, SseSerializer serializer);

  @protected
  void sse_encode_witness_version(
      WitnessVersion self, SseSerializer serializer);

  @protected
  void sse_encode_word_count(WordCount self, SseSerializer serializer);
}

// Section: wire_class

class RustLibWire implements BaseWire {
  factory RustLibWire.fromExternalLibrary(ExternalLibrary lib) =>
      RustLibWire(lib.ffiDynamicLibrary);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustLibWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;
}
