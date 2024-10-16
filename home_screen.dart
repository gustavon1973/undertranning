import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  final String name;

  HomeScreen({required this.email, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $name'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('O que vamos fazer hoje?', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureButton(context, 'Personal Treinos', () {
                  // Navigate to Personal Treinos screen
                }),
                _buildFeatureButton(context, 'Meus Treinos', () {
                  // Navigate to Meus Treinos screen
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureButton(context, 'IMC', () {
                  // Navigate to IMC screen
                }),
                _buildFeatureButton(context, 'Medidas', () {
                  // Navigate to Medidas screen
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureButton(context, 'Timer', () {
                  // Navigate to Timer screen
                }),
                _buildFeatureButton(context, 'Sobre', () {
                  // Navigate to Sobre screen
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(100, 100),
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }
}