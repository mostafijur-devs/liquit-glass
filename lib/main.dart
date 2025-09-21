import 'package:flutter/material.dart';
import 'liquid_glass/liquid_morphing_demo.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid glass',
      debugShowCheckedModeBanner: false,
      home: LiquidMorphingDemo(),
    );
  }
}




