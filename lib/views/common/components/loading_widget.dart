import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: themeData.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Center(child: LoadingAnimationWidget.fourRotatingDots(color: themeData.primaryColor, size: 50)),
    );
  }
}
