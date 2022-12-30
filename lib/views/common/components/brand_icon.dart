import 'package:flutter/material.dart';

import '../../../configs/styles.dart';



class BrandIcon extends StatelessWidget {
  double size = 40;
  bool isBorder = true;
   BrandIcon({this.size = 40,this.isBorder = true});

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.all(isBorder?8:0),
        decoration: BoxDecoration(
            border: Border.all(color: isBorder?Colors.black:Colors.transparent,width: 2),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Icon(Icons.vaccines,color: Styles.lightPrimaryColor,size: size));
  }
}


