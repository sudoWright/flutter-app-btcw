import 'package:flutter/material.dart';
import 'package:wallet/constants/proton.color.dart';

class CustomFullpageLoading extends StatelessWidget {
  const CustomFullpageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(color: ProtonColors.white),
          ],
        ),
      ),
    );
  }
}
