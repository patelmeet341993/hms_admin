import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../configs/styles.dart';
import '../../../packages/flux/themes/text_style.dart';
import '../../../packages/flux/widgets/text_field/text_field.dart';

class CommonTextField extends StatelessWidget {

  const CommonTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return FxTextField(
      focusedBorderColor: themeData.primaryColor,

      cursorColor: themeData.primaryColor,
      textFieldStyle: FxTextFieldStyle.outlined,
      labelText: 'Search a doctor or health issue',
      labelStyle: FxTextStyle.bodySmall(
          color: Colors.grey, xMuted: true),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      fillColor: Styles.cardColor,
      prefixIcon: Icon(
        FeatherIcons.search,
        color: themeData.primaryColor,
        size: 20,
      ),
    );
  }
}
