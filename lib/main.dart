import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Inisialisasi Hive
  await Hive.openBox('database_identity'); // Membuka box untuk identitas database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agus Plastik',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Montserratt'),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
