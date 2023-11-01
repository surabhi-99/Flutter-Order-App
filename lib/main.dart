import 'package:flutter/material.dart';
import 'package:order_app/screens/order_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:order_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OrderForm(), // Use the OrderForm widget as the home screen
    );
  }
}
