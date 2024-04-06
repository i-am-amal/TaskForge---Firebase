import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'TaskForge',
          style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic,color: Colors.white),
        ),
      ),
    );
  }
}
