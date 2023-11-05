import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Augma'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            onChanged: (value) {
              email = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your email',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            textAlign: TextAlign.center,
            onChanged: (value) {
              password = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your password',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              color: Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              elevation: 5.0,
              child: MaterialButton(
                onPressed: () async {
                  try {
                    final userCredential =
                        await _auth.signInWithEmailAndPassword(
                      email: email.trim(),
                      password: password.trim(),
                    );

                    if (userCredential.user != null) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  } on FirebaseAuthException catch (e) {
                    // Handle the error from FirebaseAuth
                    String errorMessage = "An error occurred";
                    if (e.code == 'user-not-found') {
                      errorMessage = 'No user found for that email.';
                    } else if (e.code == 'wrong-password') {
                      errorMessage = 'Wrong password provided for that user.';
                    } else {
                      errorMessage = e.message ??
                          errorMessage; // Use the error message from FirebaseAuth if available
                    }

                    // Show the error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } catch (e) {
                    // Handle any other errors that might occur
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Failed to log in. Please try again later."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
