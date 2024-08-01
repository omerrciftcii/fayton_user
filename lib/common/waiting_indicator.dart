import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:userapp/common/assets.dart';


class CustomWaitingIndicator extends StatelessWidget {
  const CustomWaitingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AssetPaths.waitingIndicator,
      height: 100,
    );
  }
}
