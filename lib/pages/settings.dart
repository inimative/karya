import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const Divider(),
            ListTile(
              visualDensity: VisualDensity.compact,
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Logout"),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
