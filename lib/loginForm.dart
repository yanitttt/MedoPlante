import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'interactionSearch.dart';
import 'ComposantsPerso/bottom_navigation_bar.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nom d\'utilisateur',
                labelStyle: const TextStyle(color: Colors.black),
                border: const OutlineInputBorder(),
                fillColor: Colors.deepPurple.shade100,
                filled: true,
                prefixIcon: const Icon(Icons.person, color: Colors.deepPurple),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: const TextStyle(color: Colors.black),
                border: const OutlineInputBorder(),
                fillColor: Colors.deepPurple.shade100,
                filled: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Effet de bord arrondi
                ),
                elevation: 10, // Effet d'ombre
              ),
              child: const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }

void _login() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '82.165.56.139', 
    port: 3306,
    user: 'root',
    password: 'mdpbdlinux',
    db: 'medoPlante',
  ));

  var result = await conn.query(
    'SELECT * FROM utilisateurs WHERE username = ? AND password = ?',
    [_usernameController.text, _passwordController.text],
  );

  if (result.isNotEmpty) {
    // L'utilisateur est connecté
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()), // Modifiez cette ligne
    );
  } else {
    // Les informations de connexion sont incorrectes
  }
}

}
