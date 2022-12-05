import 'package:flutter/material.dart';

class CommonPrimaryButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool filled;
  final EdgeInsets? margin, padding;

  const CommonPrimaryButton({
    Key? key,
    this.text = "",
    this.onTap,
    this.filled = true,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    List<BoxShadow> boxShadow = [
      BoxShadow(
        color: Color(0xff343987).withOpacity(0.15),
        offset: const Offset(0, 4),
        blurRadius: 4,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0xff000000).withOpacity(0.25),
        offset: const Offset(0, 4),
        blurRadius: 4,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0xff000000).withOpacity(0.12),
        offset: const Offset(4, 0),
        blurRadius: 4,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0xff343987).withOpacity(0.12),
        offset: const Offset(0, 4),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.all(filled ? 0 : 2.0),
        decoration: filled ? null : BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff51559A),
              Color(0xff7B7D9A)
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: boxShadow,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.only(top: 16, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            color: filled ? null : themeData.colorScheme.background,
            gradient: filled ? const LinearGradient(
              colors: [
                Color(0xff23287C),
                Color(0xff3D406C),
              ],
            ) : null,
            boxShadow: boxShadow,
          ),
          child: Stack(
            //overflow: Overflow.visible,
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: themeData.textTheme.subtitle1,
                ),
              ),
              /*Positioned(
                right: 16,
                child: ClipOval(
                  child: Container(
                    color: Colors.white,
                    // button color
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.arrow_forward,
                          color: themeData.primaryColor,
                          size: 18,
                        )),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
