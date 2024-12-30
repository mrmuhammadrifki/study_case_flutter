import 'dart:math';

import 'package:declarative_navigation/common.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final double _size = 100.0;

  final Tween<double> _animationTween = Tween(begin: 0, end: pi * 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: _animationTween,
              duration: const Duration(seconds: 3),
              builder: (context, double value, child) {
                return Transform.rotate(
                  angle: value,
                  child: Image.asset(
                    "assets/loading_indikator.png",
                    height: _size,
                    width: _size,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)?.loading ?? '')
          ],
        ),
      ),
    );
  }
}
