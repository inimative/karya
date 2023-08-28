import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  _login () async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.value.text,
        password: _passwordController.value.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Username"),
                  controller: _usernameController,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _login,
                    child: const Text("LOGIN"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
