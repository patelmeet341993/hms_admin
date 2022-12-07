import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final IconData? prefixIcon;
  final TextInputType? textInputType;
  final bool isRequired;
  final AutovalidateMode? autovalidateMode;
  final String hint;
  final String? Function(String? value)? validator;
  final EdgeInsets? margin;
  final List<TextInputFormatter>? inputFormatters;

  const CommonTextField({
    Key? key,
    this.textEditingController,
    this.prefixIcon,
    this.textInputType,
    this.isRequired = false,
    this.autovalidateMode,
    this.hint = '',
    this.validator,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      margin: margin,
      child: TextFormField(
        controller: textEditingController,
        style: themeData.textTheme.subtitle2,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          label: getTextFieldLabelWithRequiredStar(label: hint, isRequired: isRequired),
          prefixIcon: prefixIcon != null ? Icon(
            prefixIcon,
            size: 22,
            // color: Styles.onBackground.withAlpha(200),
          ) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
        inputFormatters: inputFormatters,
        keyboardType: textInputType,
        autofocus: false,
        textCapitalization: TextCapitalization.sentences,
        validator: validator,
      ),
    );
  }

  Widget getTextFieldLabelWithRequiredStar({required String label, bool isRequired = false}) {
    return Text.rich(
      TextSpan(
        text: "$label ",
        children: [
          if(isRequired) const TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
