import 'package:flutter/material.dart';
import 'orderManagementPage.dart';

void main() {
  runApp(const McDonaldsOrderApp());
}

class McDonaldsOrderApp extends StatelessWidget {
  const McDonaldsOrderApp ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'McDonelds Order System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const OrderManagementPage(),
    );
  }
}



