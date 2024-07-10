import 'package:wallet/rust/common/errors.dart';

ResponseError? parseResponseError(BridgeError exception) {
  return exception.maybeMap(
    apiResponse: (e) => e.field0,
    orElse: () => null,
  );
}

String parseSampleDisplayError(BridgeError exception) {
  return exception.map(
    apiLock: (e) => e.field0,
    generic: (e) => e.field0,
    muonAuthSession: (e) => e.field0,
    muonAuthRefresh: (e) => e.field0,
    muonClient: (e) => e.field0,
    muonSession: (e) => e.field0,
    andromedaBitcoin: (e) => e.field0,
    apiResponse: (e) => e.field0.error,
    apiSrp: (e) => e.field0,
  );
}

String? parseSessionExpireError(BridgeError exception) {
  return exception.maybeMap(
    muonAuthSession: (e) => e.field0,
    muonAuthRefresh: (e) => e.field0,
    orElse: () => null,
  );
}
