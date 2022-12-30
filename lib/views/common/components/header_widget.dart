import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  String title;
  Widget? suffixWidget;
  HeaderWidget({required this.title,this.suffixWidget});
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 30,
                    //color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.suffixWidget != null ? widget.suffixWidget! : Container()
              ],
            ),
          ),
          // if (!AppResponsive.isMobile(context)) ...{
          //   Spacer(),
          //   Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       navigationIcon(icon: Icons.search),
          //       navigationIcon(icon: Icons.send),
          //       navigationIcon(icon: Icons.notifications_none_rounded),
          //     ],
          //   )
          // }
        ],
      ),
    );
  }

  Widget navigationIcon({icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }
}
