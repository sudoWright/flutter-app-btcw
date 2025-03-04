import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/constants/text.style.dart';

class TextField2FA extends StatefulWidget {
  final double width;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool showEnabledBorder;
  final void Function(String)? onChanged;
  final Color color;
  final TextInputAction? textInputAction;
  final int? maxLength;

  const TextField2FA({
    required this.width,
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.color = Colors.transparent,
    this.showEnabledBorder = true,
    this.textInputAction,
    this.onChanged,
    this.maxLength = 1,
  });

  @override
  TextFieldTextState createState() => TextFieldTextState();
}

class TextFieldTextState extends State<TextField2FA> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        child: Center(
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            style: ProtonWalletStyles.twoFACode(
                color: Theme.of(context).colorScheme.primary),
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            minLines: 1,
            maxLength: widget.maxLength,
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                hintText: widget.hintText,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: ProtonColors.textHint,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: ProtonColors.protonBlue, width: 2),
                ),
                counterStyle: const TextStyle(
                  height: double.minPositive,
                ),
                counterText: ""),
          ),
        ));
  }

  Widget buildTagWidget(String tag) {
    return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Chip(
          backgroundColor: ProtonColors.backgroundNorm,
          label: Text(tag,
              style: ProtonStyles.body2Medium(
                  color: ProtonColors.protonBlue)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: ProtonColors.backgroundNorm),
          ),
          onDeleted: () {
            setState(() {
              widget.controller!.text = "";
            });
          },
        ));
  }
}
