import 'package:flutter/material.dart';

import '../../configs/styles.dart';
import '../common/components/header_widget.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({Key? key}) : super(key: key);

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(title: 'Treatment',),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
