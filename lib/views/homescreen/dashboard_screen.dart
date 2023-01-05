import 'package:admin/backend/visit/my_visit_controller.dart';
import 'package:flutter/material.dart';

import '../../configs/styles.dart';
import '../common/components/header_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          InkWell(
              onTap: (){
               // MyVisitController().createDummyVisitDataInFirestore();
              },
              child: HeaderWidget(title: 'DashBoard',)),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
