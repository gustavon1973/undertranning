import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart'; // Import your HomeScreen

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmail() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to HomeScreen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            email: userCredential.user!.email!,
            name: 'User Name', // You can modify this to fetch the user's name
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);

      // Navigate to HomeScreen on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            email: googleUser!.email,
            name: googleUser.displayName ?? 'User', // Use the user's display name
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bem vindo ao Master Class')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text('Login com Google'),
            ),
            SizedBox(height: 20),
            Text('ou', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signInWithEmail,
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to sign up screen
              },
              child: Text('Não tenho cadastro'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to reset password screen
              },
              child: Text('Esqueci a senha'),
            ),
          ],
        ),
      ),
    );
  }
}