import 'package:flutter/material.dart';

import 'common_text.dart';

class CommonButton extends StatelessWidget {
  String buttonName;
  Function()? onTap;
  double borderRadius = 4;
  double? width;
  double verticalPadding=10,horizontalPadding=10;
  FontWeight fontWeight = FontWeight.bold;
   CommonButton({required this.buttonName,required this.onTap,this.borderRadius=4,this.width,this.horizontalPadding=10,
     this.verticalPadding=10,
     this.fontWeight=FontWeight.bold,
   });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: verticalPadding,horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: themeData.primaryColor,
          borderRadius: BorderRadius.circular(borderRadius)
        ),
        child: CommonText(text: buttonName,fontWeight:fontWeight,color: Colors.white,textAlign: TextAlign.center,),
      ),
    );
  }
}
