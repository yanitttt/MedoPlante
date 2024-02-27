import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../LoginForm.dart'; // Assurez-vous d'importer LoginForm
import '../models/SecureStorage.dart'; // Assurez-vous d'importer SecureStorage
import '../models/dao.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}



class _ProfilePageState extends State<ProfilePage> {
  String email = 'utilisateur@example.com';

  void _logout() async {
    await SecureStorage().deleteSession();
    bool isLogged = await SecureStorage().isLogged();
    print(isLogged.toString()); // Imprime l'état de connexion après la première suppression

    if (!isLogged) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginForm()),
      );
    }
  }

  

Future<Map> _loadId() async {
  String? id = await SecureStorage().readSecureData('id');

  Dao dao = await Dao.getInstance();

  // Utilisez l'instance pour appeler les méthodes de Dao
  Results userResults = await dao.fetchUserById(int.parse(id!));

  Map userDefault = {
    'id': 5,
    'username': 'Jean Jack',
    'role_id': 2,
    'password': 'test123',
  };

  // Convertissez Results en Map ou utilisez userDefault si Results est vide
  Map user = userResults.isNotEmpty ? userResults.first.fields : userDefault;

  return user;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 10),
FutureBuilder<String>(
  future: _loadId().then((value) => value['username'] ?? 'Utilisateur inconnu'),
  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Nom d\'utilisateur: ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            snapshot.data ?? 'Utilisateur inconnu',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      );
    }
  },
),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Email: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Mettre à jour le profil
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                ),
                child: const Text('Mettre à jour le profil'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                ),
                child: const Text('Déconnexion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
