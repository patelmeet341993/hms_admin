import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'common_button.dart';
import 'common_text.dart';

class QRCodeView extends StatelessWidget {
  String userId;
  QRCodeView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width*.9,
        //height: MediaQuery.of(context).size.height*.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400,width: 6)
              ),
              child: QrImage(
                data: userId,
                version: QrVersions.auto,
                padding: EdgeInsets.zero,
                gapless: false,
                embeddedImageEmitsError: true,
                errorStateBuilder: (context,obj){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical:10),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FeatherIcons.alertOctagon),
                        SizedBox(height:8),
                        CommonText(text: "Some Error in Generating Image Please Try again",textAlign: TextAlign.center),
                        SizedBox(height:8),
                        CommonButton(buttonName: "Try Again",
                          onTap: (){
                          },
                          verticalPadding: 3,
                          fontWeight: FontWeight.normal,
                          borderRadius: 2,)
                      ],
                    ),
                  );
                },
                embeddedImage: AssetImage('assets/extra/viren.jpg',),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(80, 80),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






