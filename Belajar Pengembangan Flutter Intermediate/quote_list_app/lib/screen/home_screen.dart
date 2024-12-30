yimport 'package:flutter/material.dart';
 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quote List App"),
      ),
      body: Center(
        child: Text(
          "This is Quote List App",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}

