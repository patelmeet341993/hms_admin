import 'package:admin/views/myapp.dart';
import 'package:flutter/material.dart';

import 'init.dart';

Future<void> main() async {
  await runErrorSafeApp(
    () => runApp(
      const MyApp(),
    ),
    isDev: true,
    hospitalId: "Hospital_1",
  );
}
