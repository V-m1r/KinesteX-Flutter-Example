// import 'package:KinesteX_B2B/kinestex_web_view_example1.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
import 'home.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => KinesteXViewState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinesteX SDK App',
      home: const MyHomePage(),
      theme: ThemeData(primarySwatch: Colors.blue),

      // Updated CircularProgressIndicator with size and centering
    );
  }
}
