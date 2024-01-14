import 'package:flutter/material.dart';
import 'loginForm.dart';
import 'models/dao.dart';
import 'package:mysql1/mysql1.dart';



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
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Medo-Plante'),
      ),
      body: const LoginForm(),
    ),
  ));

  InteractionSearcher._searchInteraction();
}