import 'package:flutter/material.dart';
import 'package:medo_plante_1/login_page.dart';
import 'loginForm.dart';
import 'models/dao.dart';
import 'package:mysql1/mysql1.dart';
import 'models/SecureStorage.dart';
import 'ComposantsPerso/bottom_navigation_bar.dart';



class InteractionSearcher {
  static void _searchInteraction() async {
    // Obtenez une instance de Dao
    Dao dao = await Dao.getInstance();

    // Utilisez l'instance pour appeler les méthodes de Dao
    Results medicaments = await dao.fetchMedicamentNameById(1);

    print(medicaments);
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Interactions Médicament-Plante',
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
    ),
    home: FutureBuilder<bool>(
      future: SecureStorage().isLogged(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.data == true) {
            return Scaffold(
              appBar: AppBar(
                //title: const Text('Medo-Plante'),
              ),
              body: const CustomBottomNavigationBar(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                //title: const Text('Medo-Plante'),
              ),
              body: const LoginPage(),
            );
          }
        }
      },
    ),
  ));
  InteractionSearcher._searchInteraction();
}
