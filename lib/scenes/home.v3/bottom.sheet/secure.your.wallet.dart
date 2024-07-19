import 'package:flutter/material.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/l10n/generated/locale.dart';
import 'package:wallet/scenes/components/bottom.sheets/base.dart';
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart';
import 'package:wallet/scenes/home.v3/home.viewmodel.dart';
import 'package:wallet/theme/theme.font.dart';

class SecureYourWalletSheet {
  static void show(BuildContext context, HomeViewModel viewModel) {
    HomeModalBottomSheet.show(context,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(S.of(context).secure_your_wallet,
              style: FontManager.body2Median(ProtonColors.textNorm)),
          const SizedBox(height: 10),
          ListTile(
            title: Text(S.of(context).todos_backup_proton_account,
                style: !viewModel.hadSetupRecovery
                    ? FontManager.body2Median(ProtonColors.protonBlue)
                    : FontManager.body2MedianLineThrough(
                        ProtonColors.protonBlue)),
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: ProtonColors.protonBlue, size: 14),
            onTap: () {
              Navigator.of(context).pop(); // pop this modalBottomSheet
              viewModel.move(NavID.recovery);
            },
          ),
          const Divider(
            height: 0.3,
            thickness: 0.3,
          ),
          ListTile(
            title: Text(S.of(context).todos_backup_wallet_mnemonic,
                style: viewModel.showWalletRecovery
                    ? FontManager.body2Median(ProtonColors.protonBlue)
                    : FontManager.body2MedianLineThrough(
                        ProtonColors.protonBlue)),
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: ProtonColors.protonBlue, size: 14),
            onTap: () {
              Navigator.of(context).pop(); // pop this modalBottomSheet
              viewModel.move(NavID.setupBackup);
            },
          ),
          const Divider(
            height: 0.3,
            thickness: 0.3,
          ),
          ListTile(
            title: Text(S.of(context).todos_setup_2fa,
                style: !viewModel.hadSetup2FA
                    ? FontManager.body2Median(ProtonColors.protonBlue)
                    : FontManager.body2MedianLineThrough(
                        ProtonColors.protonBlue)),
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: ProtonColors.protonBlue, size: 14),
            onTap: () {
              Navigator.of(context).pop(); // pop this modalBottomSheet
              viewModel.move(NavID.securitySetting);
            },
          ),
        ]));
  }
}
