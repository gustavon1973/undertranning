// imc_screen.dart
import 'package:flutter/material.dart';

class MedidasScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medidas')),
      body: Center(
        child: Text('Cálculo do Medida aqui', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}