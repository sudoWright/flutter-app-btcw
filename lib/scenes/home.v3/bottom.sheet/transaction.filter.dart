import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/l10n/generated/locale.dart';
import 'package:wallet/scenes/components/bottom.sheets/base.dart';
import 'package:wallet/scenes/home.v3/home.viewmodel.dart';
import 'package:wallet/theme/theme.font.dart';

class TransactionFilterSheet {
  static void show(BuildContext context, HomeViewModel viewModel) {
    HomeModalBottomSheet.show(context, child:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              ListTile(
                trailing: viewModel.transactionListFilterBy.isEmpty
                    ? SvgPicture.asset("assets/images/icon/ic-checkmark.svg",
                        fit: BoxFit.fill, width: 20, height: 20)
                    : null,
                title: Text(S.of(context).transaction_filter_all_transactions,
                    style: FontManager.body2Regular(ProtonColors.textNorm)),
                onTap: () {
                  viewModel.updateTransactionListFilterBy("");
                  Navigator.of(context).pop();
                },
              ),
              const Divider(
                thickness: 0.2,
                height: 1,
              ),
              ListTile(
                trailing: viewModel.transactionListFilterBy.contains("send")
                    ? SvgPicture.asset("assets/images/icon/ic-checkmark.svg",
                        fit: BoxFit.fill, width: 20, height: 20)
                    : null,
                title: Text(S.of(context).transaction_filter_sent,
                    style: FontManager.body2Regular(ProtonColors.textNorm)),
                onTap: () {
                  viewModel.updateTransactionListFilterBy("send");
                  Navigator.of(context).pop();
                },
              ),
              const Divider(
                thickness: 0.2,
                height: 1,
              ),
              ListTile(
                trailing: viewModel.transactionListFilterBy.contains("receive")
                    ? SvgPicture.asset("assets/images/icon/ic-checkmark.svg",
                        fit: BoxFit.fill, width: 20, height: 20)
                    : null,
                title: Text(S.of(context).transaction_filter_received,
                    style: FontManager.body2Regular(ProtonColors.textNorm)),
                onTap: () {
                  viewModel.updateTransactionListFilterBy("receive");
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      );
    }));
  }
}
