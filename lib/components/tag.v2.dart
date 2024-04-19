import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/theme/theme.font.dart';

class TagV2 extends StatelessWidget {
  final int index;
  final String text;
  final double width;

  const TagV2({
    super.key,
    this.text = "",
    this.index = 1,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
        decoration: BoxDecoration(
            color: ProtonColors.white,
            borderRadius: BorderRadius.circular(40.0)),
        child: Row(children: [
          SizedBox(
              width: 18,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(index.toString(),
                      style: FontManager.body2Regular(ProtonColors.textNorm)))),
          const SizedBox(width: 20),
          Text(
            text,
            style: FontManager.body2Regular(ProtonColors.textNorm),
          )
        ]));
  }
}
