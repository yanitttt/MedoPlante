import 'package:flutter/material.dart';
import 'package:medo_plante_1/ComposantsPerso/bottom_navigation_bar.dart';
import 'package:medo_plante_1/models/SecureStorage.dart';
import 'package:mysql1/mysql1.dart';

class LoginPage extends StatefulWidget {

const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
    final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();



    void checkLoginStatus() async {
    bool isLogged = await SecureStorage().isLogged();
    if (isLogged) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CustomBottomNavigationBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            Text("Hello World", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), // Reduced font size
            SizedBox(height: 10),
            Text("Heureux de vous revoir !", style: TextStyle(fontSize: 20),), // Reduced font size
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    hintText: 'Nom d\'utilisateur',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16), // Reduced font size
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    hintText: 'Mot de passe',
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16), // Reduced font size
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12)),
                child: Center(
                  
                  child: GestureDetector(
  onTap: () {
    // Handle your click event here
    print('Connexion clicked');
    _login();
  },
  child: Text(
    'Connexion', 
    style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
  ),
), // Reduced font size
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pas de compte ?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),), // Reduced font size
                Text("S'inscrire", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),), // Reduced font size
              ],
            ),
          ],
        ),
      ))
    );
  }


void _login() async {
  try {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '82.165.56.139', 
      port: 3306,
      user: 'root',
      password: 'mdpbdlinux',
      db: 'medoPlante',
    ));

    var result = await conn.query(
      'SELECT id FROM utilisateurs WHERE username = ? AND password = ?',
      [_usernameController.text, _passwordController.text],
    );

    if (result.isNotEmpty) {
      // L'utilisateur est connecté
      SecureStorage().createSession(result.first[0]);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CustomBottomNavigationBar()),
      );
    } else {
      print("Informations de connexion incorrectes");
      // Afficher un message d'erreur à l'utilisateur
    }
  } catch (e) {
    print("Erreur de connexion à la base de données: $e");
    // Afficher un message d'erreur à l'utilisateur
  }
}








  
}

