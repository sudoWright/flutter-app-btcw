import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wallet/components/custom.loading.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/helper/bitcoin.amount.dart';
import 'package:wallet/helper/common_helper.dart';
import 'package:wallet/l10n/generated/locale.dart';
import 'package:wallet/theme/theme.font.dart';

class TransactionListTitle extends StatelessWidget {
  final double width;
  final String address;
  final BitcoinAmount bitcoinAmount;
  final bool isSend;
  final int? timestamp;
  final VoidCallback? onTap;
  final String note;
  final String? body;

  const TransactionListTitle({
    super.key,
    required this.width,
    required this.address,
    required this.isSend,
    required this.bitcoinAmount,
    this.timestamp,
    this.note = "",
    this.onTap,
    this.body,
  });

  String parsetime(int timestemp) {
    var millis = timestemp;
    var dt = DateTime.fromMillisecondsSinceEpoch(millis * 1000);

    var dformat = DateFormat('MM.dd.yyyy').format(dt);
    return dformat.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 26, right: 26, top: 10),
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          // width: width,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
              color: ProtonColors.wMajor1,
              width: 0.5,
            )),
          ),
          child: Row(children: [
            SvgPicture.asset(
                isSend
                    ? "assets/images/icon/send.svg"
                    : "assets/images/icon/receive.svg",
                fit: BoxFit.fill,
                width: 32,
                height: 32),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: SizedBox(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          address,
                          style:
                              FontManager.captionRegular(ProtonColors.textNorm),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                        const SizedBox(width: 4),
                        isSend
                            ? Text(
                                bitcoinAmount.toFiatCurrencyString(),
                                style: FontManager.captionRegular(
                                    ProtonColors.textHint))
                            : Text(
                                "+${bitcoinAmount.toFiatCurrencyString()}",
                                style: FontManager.captionRegular(
                                    ProtonColors.textHint))
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        timestamp != null
                            ? Expanded(
                                child: Text(
                                parsetime(timestamp!),
                                style: FontManager.captionRegular(
                                    ProtonColors.textHint),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ))
                            : Row(children: [
                                const CustomLoading(),
                                const SizedBox(width: 6),
                                Text(S.of(context).in_progress,
                                    style: FontManager.captionRegular(
                                        ProtonColors.protonBlue)),
                              ]),
                        const SizedBox(width: 4),
                        isSend
                            ? Text(
                                bitcoinAmount.toString(),
                                style: FontManager.captionRegular(
                                    ProtonColors.signalError))
                            : Text(
                                "+${bitcoinAmount.toString()}",
                                style: FontManager.captionRegular(
                                    ProtonColors.signalSuccess)),
                      ]),
                  if (note != "")
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ProtonColors.wMajor1,
                          ),
                          margin: const EdgeInsets.only(right: 4, top: 2),
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(Icons.edit_outlined,
                              size: 10, color: ProtonColors.textHint)),
                      Expanded(
                          child: Text(
                        S
                            .of(context)
                            .trans_note(CommonHelper.getFirstNChar(note, 24)),
                        style:
                            FontManager.captionRegular(ProtonColors.textHint),
                        overflow: TextOverflow.ellipsis,
                      ))
                    ]),
                  if ((body ?? "").isNotEmpty)
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ProtonColors.wMajor1,
                          ),
                          margin: const EdgeInsets.only(right: 4, top: 2),
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(Icons.messenger_outline,
                              size: 10, color: ProtonColors.textHint)),
                      Expanded(
                          child: Text(
                        S.of(context).trans_body(body ?? ""),
                        style:
                            FontManager.captionRegular(ProtonColors.textHint),
                        overflow: TextOverflow.ellipsis,
                      ))
                    ]),
                ],
              )),
            ),
          ]),
        ));
  }
}
