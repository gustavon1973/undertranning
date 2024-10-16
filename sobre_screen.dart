// imc_screen.dart
import 'package:flutter/material.dart';

class SobreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sobre')),
      body: Center(
        child: Text('Sobre', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}