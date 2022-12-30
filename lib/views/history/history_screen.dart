import 'package:flutter/material.dart';

import '../../configs/styles.dart';
import '../common/components/header_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(title: 'History',),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
