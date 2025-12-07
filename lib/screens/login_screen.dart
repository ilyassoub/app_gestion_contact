import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'contacts_list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),

            SizedBox(height: 12),

            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),

            SizedBox(height: 20),

            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text("Se connecter"),
                    onPressed: () async {
                      setState(() => loading = true);

                      try {
                        await auth.signIn(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => ContactsListScreen()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erreur : $e")),
                        );
                      }

                      setState(() => loading = false);
                    },
                  ),

            TextButton(
              child: Text("Créer un compte"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignupScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
