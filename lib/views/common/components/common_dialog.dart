/*
* File : Location Permission Dialog
* Version : 1.0.0
* */

import 'package:flutter/material.dart';

import '../../../packages/flux/utils/spacing.dart';
import '../../../packages/flux/widgets/button/button.dart';
import '../../../packages/flux/widgets/text/text.dart';
import 'common_text.dart';


class CommonDialog extends StatelessWidget {
  final String text;
  final String leftText ,rightText;
  final IconData? icon;
  final Function()? rightOnTap;
  final Function()? leftOnTap;

  const CommonDialog({
    Key? key,
    required this.text,
    this.icon,
    this.leftText = "No",
    this.rightText = "Yes",
    this.leftOnTap,
    this.rightOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData=Theme.of(context);
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: FxSpacing.all(20),
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                icon!=null?Container(
                  margin: FxSpacing.right(16),
                  child: Icon(
                    icon,
                    size: 28,
                    color:Colors.black,
                  ),
                ):const SizedBox.shrink(),
                FxSpacing.width(8),
                Expanded(
                  child: CommonText(
                    text: text,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Container(
                margin: FxSpacing.top(8),
                alignment: AlignmentDirectional.centerEnd,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: FxButton.text(
                          onPressed: () {
                            if(leftOnTap == null){
                              Navigator.pop(context);
                            }else{
                              leftOnTap!();
                            }
                          },
                          splashColor: Colors.white,
                          child: FxText.bodyMedium(leftText,
                              fontWeight: 700, letterSpacing: 0.4)),
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: rightOnTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: BoxDecoration(
                            color: themeData.primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                            child: FxText.bodyMedium(rightText,
                                letterSpacing: 0.4,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}