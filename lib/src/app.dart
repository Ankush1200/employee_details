import 'package:flutter/material.dart';
import 'package:pixels_assignment/src/features/home.dart';

class App extends StatelessWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:Colors.yellow),
        useMaterial3: true,
      ),
      home:const MyHomePage(),
    );
  }
}