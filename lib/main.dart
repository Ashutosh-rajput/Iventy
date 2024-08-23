import 'package:flutter/material.dart';
import './screens/homepage.dart';
// import './models/db_model.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'database_helper.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

void main() async {
  if (kIsWeb) {
    // If it's a web app, no initialization needed.
  } else if (defaultTargetPlatform == TargetPlatform.windows) {
    // Initialize sqflite for desktop platforms
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // final db = DatabaseConnect();
  // await db.clearDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      restorationScopeId: "Test",
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
