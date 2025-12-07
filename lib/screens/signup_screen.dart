import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
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
                    child: Text("Créer un compte"),
                    onPressed: () async {
                      setState(() => loading = true);

                      try {
                        await auth.signUp(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Compte créé ! Connectez-vous.")),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
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
              child: Text("Déjà un compte ? Se connecter"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
