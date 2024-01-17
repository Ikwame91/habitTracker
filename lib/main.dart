import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/homepage.dart';
import 'package:habit_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Themeprovider()),
    ],
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<Themeprovider>(context).themeData,
      home: const HomePage(),
    );
  }
}
