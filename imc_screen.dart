// imc_screen.dart
import 'package:flutter/material.dart';

class IMCScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IMC')),
      body: Center(
        child: Text('Cálculo do IMC aqui', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}