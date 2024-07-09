import 'dart:math';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallet/constants/assets.gen.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/helper/avatar.color.helper.dart';
import 'package:wallet/helper/common_helper.dart';
import 'package:wallet/l10n/generated/locale.dart';
import 'package:wallet/managers/features/models/wallet.list.dart';
import 'package:wallet/managers/features/wallet.list.bloc.dart';
import 'package:wallet/scenes/home.v3/bottom.sheet/upgrade.intro.dart';
import 'package:wallet/scenes/home.v3/home.view.dart';
import 'package:wallet/scenes/home.v3/home.viewmodel.dart';
import 'package:wallet/theme/theme.font.dart';

typedef WalletCallback = void Function(WalletMenuModel wallet);
typedef SelectedCallback = void Function(
  WalletMenuModel wallet,
  AccountMenuModel account,
);
typedef DeleteCallback = void Function(
  WalletMenuModel wallet,
  bool hasBalance,
  bool isInvalidWallet,
);

class SidebarWalletItems extends StatelessWidget {
  final WalletListBloc walletListBloc;
  final WalletCallback? addAccount;
  final SelectedCallback? selectAccount;
  final DeleteCallback? onDelete;
  final WalletCallback? updatePassphrase;
  final WalletCallback? selectWallet;
  final HomeViewModel? viewModel;

  const SidebarWalletItems({
    super.key,
    required this.walletListBloc,
    this.addAccount,
    this.selectAccount,
    this.onDelete,
    this.updatePassphrase,
    this.selectWallet,
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletListBloc, WalletListState>(
      bloc: walletListBloc,
      builder: (context, state) {
        if (state.initialized) {
          return Column(
            children: [
              for (WalletMenuModel wlMenu in state.walletsModel)
                ListTileTheme(
                  contentPadding: const EdgeInsets.only(
                    left: defaultPadding,
                    right: 10,
                  ),
                  child: wlMenu.hasValidPassword
                      ? ExpansionTile(
                          shape: const Border(),
                          collapsedBackgroundColor: wlMenu.isSelected
                              ? ProtonColors.drawerBackgroundHighlight
                              : Colors.transparent,
                          backgroundColor: wlMenu.isSelected
                              ? ProtonColors.drawerBackgroundHighlight
                              : Colors.transparent,
                          initiallyExpanded: wlMenu.hasValidPassword,
                          leading: SvgPicture.asset(
                            "assets/images/icon/wallet-${state.walletsModel.indexOf(wlMenu) % 4}.svg",
                            fit: BoxFit.fill,
                            width: 18,
                            height: 18,
                          ),
                          title: Transform.translate(
                            offset: const Offset(-8, 0),
                            // Build title
                            child: _buildTitle(
                              context,
                              walletListBloc,
                              state,
                              wlMenu,
                            ),
                          ),
                          iconColor: ProtonColors.textHint,
                          collapsedIconColor: ProtonColors.textHint,
                          children: _buildExpansionChildren(
                            context,
                            walletListBloc,
                            state,
                            wlMenu,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            updatePassphrase?.call(wlMenu);
                          },
                          child: ListTile(
                            shape: const Border(),
                            leading: SvgPicture.asset(
                              "assets/images/icon/wallet-${state.walletsModel.indexOf(wlMenu) % 4}.svg",
                              fit: BoxFit.fill,
                              width: 18,
                              height: 18,
                            ),
                            title: Transform.translate(
                              offset: const Offset(-8, 0),
                              // Build title
                              child: _buildTitle(
                                context,
                                walletListBloc,
                                state,
                                wlMenu,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                onDelete?.call(wlMenu, false, true);
                              },
                              child: Icon(Icons.delete_forever_rounded,
                                  size: 24, color: ProtonColors.signalError),
                            ),
                            iconColor: ProtonColors.textHint,
                          ),
                        ),
                ),
            ],
          );
        }
        return Padding(
            padding: const EdgeInsets.only(left: defaultPadding),
            child: CircularProgressIndicator(
              color: ProtonColors.white,
            ));
      },
    );
  }

  Widget _buildTitle(
    BuildContext context,
    WalletListBloc bloc,
    WalletListState state,
    WalletMenuModel wlModel,
  ) {
    if (wlModel.hasValidPassword) {
      return GestureDetector(
        onTap: () => {selectWallet?.call(wlModel)},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: min(MediaQuery.of(context).size.width - 180,
                      drawerMaxWidth - 110),
                  child: Text(
                    wlModel.walletName,
                    style: FontManager.captionSemiBold(
                      AvatarColorHelper.getTextColor(
                          state.walletsModel.indexOf(wlModel)),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "${wlModel.accountSize} accounts",
                  style: FontManager.captionRegular(ProtonColors.textHint),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              updatePassphrase?.call(wlModel);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: min(MediaQuery.of(context).size.width - 250,
                            drawerMaxWidth - 180),
                        child: Text(
                          wlModel.walletName,
                          style: FontManager.captionSemiBold(
                            AvatarColorHelper.getTextColor(
                                state.walletsModel.indexOf(wlModel)),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "${wlModel.accountSize} accounts",
                        style:
                            FontManager.captionRegular(ProtonColors.textHint),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.lock_rounded,
                      color: ProtonColors.signalSuccess,
                      size: 22,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      );
    }
  }

  /// build accounts
  List<Widget> _buildExpansionChildren(
    BuildContext context,
    WalletListBloc bloc,
    WalletListState state,
    WalletMenuModel wlModel,
  ) {
    final List<Widget> children = [];
    if (wlModel.hasValidPassword) {
      for (AccountMenuModel actModel in wlModel.accounts) {
        children.add(
          Material(
            color: ProtonColors.drawerBackground,
            child: ListTile(
              tileColor: actModel.isSelected
                  ? ProtonColors.drawerBackgroundHighlight
                  : ProtonColors.drawerBackground,
              onTap: () {
                selectAccount?.call(wlModel, actModel);
              },

              /// set wallet icon
              leading: Container(
                margin: const EdgeInsets.only(left: 10),
                child: SvgPicture.asset(
                  "assets/images/icon/wallet-account-${wlModel.currentIndex}.svg",
                  fit: BoxFit.fill,
                  width: 16,
                  height: 16,
                ),
              ),

              /// wallet title: include name and balance
              title: Transform.translate(
                offset: const Offset(-4, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CommonHelper.getFirstNChar(actModel.label, 20),
                      style: FontManager.captionMedian(
                        AvatarColorHelper.getTextColor(
                            state.walletsModel.indexOf(wlModel)),
                      ),
                    ),

                    /// balance
                    getWalletAccountBalanceWidget(
                      context,
                      actModel,
                      AvatarColorHelper.getTextColor(
                          state.walletsModel.indexOf(wlModel)),
                      viewModel?.displayBalance ?? true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      children.add(
        Material(
          color: ProtonColors.drawerBackground,
          child: ListTile(
            onTap: () {
              if (wlModel.accounts.length < freeUserWalletAccountLimit) {
                addAccount?.call(wlModel);
              } else {
                if (viewModel == null) {
                  CommonHelper.showSnackbar(
                    context,
                    S.of(context).freeuser_wallet_account_limit(
                        freeUserWalletAccountLimit),
                  );
                } else {
                  UpgradeIntroSheet.show(context, viewModel!);
                }
              }
            },
            tileColor: ProtonColors.drawerBackground,
            leading: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Assets.images.icon.addAccount.svg(
                fit: BoxFit.fill,
                width: 16,
                height: 16,
              ),
            ),
            title: Transform.translate(
              offset: const Offset(-4, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).add_account,
                          style: FontManager.captionRegular(
                              ProtonColors.textHint)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return children;
  }

  // update wallet account balance widget
  Widget getWalletAccountBalanceWidget(
    BuildContext context,
    AccountMenuModel accountModel,
    Color textColor,
    bool displayBalance,
  ) {
    if (displayBalance) {
      return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(accountModel.currencyBalance,
            style: FontManager.captionSemiBold(textColor)),
        Text(accountModel.btcBalance,
            style: FontManager.overlineRegular(ProtonColors.textHint))
      ]);
    } else {
      return Blur(
        blur: 3,
        blurColor: ProtonColors.drawerBackground,
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(accountModel.currencyBalance,
              style: FontManager.captionSemiBold(textColor)),
          Text(accountModel.btcBalance,
              style: FontManager.overlineRegular(ProtonColors.textHint))
        ]),
      );
    }
  }
}
