import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/constants/text.style.dart';
import 'package:wallet/helper/bitcoin.amount.dart';
import 'package:wallet/l10n/generated/locale.dart';
import 'package:wallet/scenes/components/bottom.sheets/recipient.detail.dart';

class TransactionHistorySendItem extends StatelessWidget {
  final String content;
  final String bitcoinAddress;
  final String? walletAccountName;
  final BitcoinAmount? bitcoinAmount;
  final bool isLoading;
  final bool displayBalance;

  const TransactionHistorySendItem({
    required this.content,
    required this.bitcoinAddress,
    super.key,
    this.walletAccountName,
    this.bitcoinAmount,
    this.isLoading = false,
    this.displayBalance = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RecipientDetailSheet.show(
          context,
          content,
          content,
          bitcoinAddress,
          isBitcoinAddress: bitcoinAddress == content,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        color: ProtonColors.white,
        child: isLoading
            ? const CardLoading(
                height: 50,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                margin: EdgeInsets.only(top: 4),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).trans_to,
                              style: ProtonStyles.body2Medium(
                                  color: ProtonColors.textWeak)),
                          Text(
                            content,
                            style: ProtonStyles.body2Medium(
                                color: ProtonColors.textNorm),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (walletAccountName != null &&
                              walletAccountName != content)
                            Text(
                              walletAccountName!,
                              style: ProtonStyles.body2Medium(
                                  color: ProtonColors.textWeak),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      )),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        if (bitcoinAmount != null)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  bitcoinAmount!.toFiatCurrencyString(
                                      displayBalance: displayBalance),
                                  style: ProtonStyles.body2Regular(
                                      color: ProtonColors.textNorm)),
                              Text(
                                  bitcoinAmount!
                                      .toString(displayBalance: displayBalance),
                                  style: ProtonStyles.body2Regular(
                                      color: ProtonColors.textHint)),
                            ],
                          ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: ProtonColors.textWeak, size: 14),
                      ]),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
