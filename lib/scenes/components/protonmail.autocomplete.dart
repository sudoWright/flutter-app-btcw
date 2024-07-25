import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/helper/avatar.color.helper.dart';
import 'package:wallet/helper/common_helper.dart';
import 'package:wallet/l10n/generated/locale.dart';
import 'package:wallet/models/contacts.model.dart';
import 'package:wallet/theme/theme.font.dart';

class ProtonMailAutoComplete extends StatelessWidget {
  final List<ContactsModel> emails;
  final Color color;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String? labelText;
  final String? hintText;
  final VoidCallback? callback;
  final bool? showBorder;
  final Color? itemBackgroundColor;
  final bool updateTextController;
  final bool showQRcodeScanner;
  final double maxHeight;

  const ProtonMailAutoComplete({
    required this.emails,
    required this.textEditingController,
    required this.focusNode,
    super.key,
    this.callback,
    this.labelText,
    this.hintText,
    this.color = Colors.transparent,
    this.showBorder = true,
    this.maxHeight = 320,
    this.itemBackgroundColor,
    this.updateTextController = true,
    this.showQRcodeScanner = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => RawAutocomplete<ContactsModel>(
            textEditingController: textEditingController,
            focusNode: focusNode,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return emails;
              }
              return emails.where((ContactsModel protonContactEmail) {
                return protonContactEmail.email
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()) ||
                    protonContactEmail.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (ContactsModel selection) {
              if (updateTextController) {
                textEditingController.text = selection.email;
              }
              if (callback != null) {
                callback!();
              }
              focusNode.unfocus();
            },
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<ContactsModel> onSelected,
                Iterable<ContactsModel> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: maxHeight,
                    maxWidth: constraints.biggest.width,
                  ),
                  decoration: BoxDecoration(
                    color: itemBackgroundColor ?? ProtonColors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: options.map((ContactsModel option) {
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Column(children: [
                          option.name != option.email
                              ? ListTile(
                                  leading: getEmailAvatar(option.name),
                                  title: Text(option.name),
                                  subtitle: Text(option.email),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: getEmailAvatar(option.name),
                                    title: Text(option.name),
                                  ),
                                ),
                          // const Padding(
                          //     padding: EdgeInsets.symmetric(
                          //         horizontal: defaultPadding),
                          //     child: Divider(
                          //       thickness: 0.2,
                          //       height: 1,
                          //     )),
                        ]),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(18.0)),
                  border: showBorder!
                      ? Border.all(
                          width: 1.6,
                          color: focusNode.hasFocus
                              ? ProtonColors.interactionNorm
                              : ProtonColors.protonShades20,
                        )
                      : null,
                ),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  style: FontManager.body1Median(ProtonColors.textNorm),
                  onFieldSubmitted: (value) {
                    if (callback != null) {
                      callback!();
                    }
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: showQRcodeScanner
                        ? IconButton(
                            onPressed: () {
                              if (Platform.isAndroid || Platform.isIOS) {
                                focusNode.unfocus();
                                showQRScanBottomSheet(
                                    context, textEditingController, callback);
                              }
                            },
                            icon: Icon(Icons.qr_code_rounded,
                                size: 26, color: ProtonColors.textWeak),
                          )
                        : null,
                    labelText: labelText,
                    labelStyle:
                        FontManager.textFieldLabelStyle(ProtonColors.textWeak),
                    hintText: hintText,
                    hintStyle:
                        FontManager.textFieldLabelStyle(ProtonColors.textHint),
                    contentPadding: const EdgeInsets.only(
                        left: 10, right: 10, top: 4, bottom: 16),
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    border: InputBorder.none,
                    errorStyle: const TextStyle(height: 0),
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              );
            }));
  }
}

Widget getEmailAvatar(String name) {
  return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AvatarColorHelper.getBackgroundColor(
            AvatarColorHelper.getIndexFromString(name)),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Center(
        child: Text(
          CommonHelper.getFirstNChar(name, 1).toUpperCase(),
          style: FontManager.body2Median(
            AvatarColorHelper.getTextColor(
                AvatarColorHelper.getIndexFromString(name)),
          ),
        ),
      ));
}

void showQRScanBottomSheet(BuildContext context,
    TextEditingController textEditingController, VoidCallback? callback) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    S.of(context).scan_btc_address,
                    style: FontManager.body2Regular(ProtonColors.textNorm),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: MobileScanner(
                    onDetect: (capture) {
                      try {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          textEditingController.text = barcode.rawValue ?? "";
                          if (callback != null) {
                            Navigator.of(context).pop();
                            callback();
                          }
                          break;
                        }
                      } catch (e) {
                        CommonHelper.showErrorDialog(e.toString());
                      }
                    },
                  )),
            ])),
      );
    },
  );
}
