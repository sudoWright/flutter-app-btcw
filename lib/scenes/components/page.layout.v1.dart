import 'package:flutter/material.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/scenes/components/back.button.v1.dart';
import 'package:wallet/theme/theme.font.dart';

class PageLayoutV1 extends StatelessWidget {
  final Widget? child;
  final Widget? headerWidget;
  final Widget? bottomWidget;
  final String? title;
  final double? borderRadius;
  final Color? backgroundColor;
  final bool showHeader;

  /// we will expanded the child to match parent height if set it to true
  final bool expanded;

  const PageLayoutV1({
    super.key,
    this.child,
    this.headerWidget,
    this.bottomWidget,
    this.title,
    this.borderRadius,
    this.backgroundColor,
    this.showHeader = true,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(borderRadius ?? 24.0)),
        color: backgroundColor ?? ProtonColors.backgroundProton,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showHeader)
                headerWidget ??
                    BackButtonV1(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
              expanded
                  ? Expanded(
                      child: buildMain(context),
                    )
                  : buildMain(context),
              if (bottomWidget != null) bottomWidget!,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMain(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: defaultPadding),
        if (title != null)
          Text(title!, style: FontManager.titleSubHero(ProtonColors.textNorm)),
        if (child != null) child!,
      ]),
    );
  }
}
