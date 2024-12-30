import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
 
void main() {
  runApp(const QuoteListApp());
}
 
class QuoteListApp extends StatelessWidget {
  const QuoteListApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quote List App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      );
  }
}