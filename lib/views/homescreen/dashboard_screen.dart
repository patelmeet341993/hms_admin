import 'package:flutter/material.dart';
import 'package:hms_models/hms_models.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                String data = await MyUtils.scanQRAndGetData(context: context);
                MyPrint.printOnConsole("data:$data");
              },
              child: const Text("Dashboard Body"),
            ),
          ],
        ),
      ),
    );
  }
}
