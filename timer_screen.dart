// imc_screen.dart
import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('timer')),
      body: Center(
        child: Text('Timer', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}