import 'package:flutter/material.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/constants/text.style.dart';

class CustomTodos extends StatelessWidget {
  final String title;
  final bool checked;
  final VoidCallback? callback;

  const CustomTodos({
    required this.title,
    super.key,
    this.callback,
    this.checked = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: callback,
        child: Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: ProtonColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: ListTile(
              dense: true,
              leading: Radio<bool>(
                value: true,
                groupValue: checked,
                onChanged: (value) {},
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                activeColor: ProtonColors.protonBlue,
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return ProtonColors.protonBlue;
                  }
                  return ProtonColors.protonBlue;
                }),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 2),
              title: Transform.translate(
                  offset: const Offset(-10, -1),
                  child: Text(
                    title,
                    style: checked
                        ? ProtonStyles.body2Medium(
                                color: ProtonColors.protonBlue)
                            .copyWith(
                            decoration: TextDecoration.lineThrough,
                          )
                        : ProtonStyles.body2Medium(
                            color: ProtonColors.protonBlue),
                  )),
              trailing: checked
                  ? null
                  : Icon(Icons.arrow_forward_ios_rounded,
                      color: ProtonColors.protonBlue, size: 14),
            )));
  }
}
