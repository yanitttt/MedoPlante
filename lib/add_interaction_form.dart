import 'package:flutter/material.dart';
import 'medicament.dart';
import 'plante.dart';
import 'package:mysql1/mysql1.dart';

class AddInteractionForm extends StatefulWidget {
  const AddInteractionForm({super.key});

  @override
  _AddInteractionFormState createState() => _AddInteractionFormState();
}

class _AddInteractionFormState extends State<AddInteractionForm> {
  final _formKey = GlobalKey<FormState>();
  final _medicamentController = TextEditingController();
  final _planteController = TextEditingController();
  final _descriptionController = TextEditingController();


  Future<List<Medicament>> _fetchMedicaments() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '82.165.56.139', 
    port: 3306,
    user: 'root',
    password: 'mdpbdlinux',
    db: 'medoPlante',
  ));

  var result = await conn.query('SELECT * FROM medicaments');

  List<Medicament> medicaments = result.map((row) => Medicament(row['id'], row['nom'])).toList();

  return medicaments;
}

Future<Medicament?> _fetchMedicament(String nom) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '82.165.56.139', 
    port: 3306,
    user: 'root',
    password: 'mdpbdlinux',
    db: 'medoPlante',
  ));

  var result = await conn.query('SELECT * FROM medicaments WHERE nom = ?', [nom]);

  if (result.isNotEmpty) {
    return Medicament(result.first['id'], result.first['nom']);
  } else {
    return null;
  }
}

Future<Plante?> _fetchPlante(String nom) async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '82.165.56.139', 
    port: 3306,
    user: 'root',
    password: 'mdpbdlinux',
    db: 'medoPlante',
  ));

  var result = await conn.query('SELECT * FROM plantes WHERE nom = ?', [nom]);

  if (result.isNotEmpty) {
    return Plante(result.first['id'], result.first['nom']);
  } else {
    return null;
  }
}


Future<List<Plante>> _fetchPlantes() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: '82.165.56.139', 
    port: 3306,
    user: 'root',
    password: 'mdpbdlinux',
    db: 'medoPlante',
  ));

  var result = await conn.query('SELECT * FROM plantes');

  List<Plante> plantes = result.map((row) => Plante(row['id'], row['nom'])).toList();

  return plantes;
}



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<List<Medicament>>(
            future: _fetchMedicaments(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DropdownButtonFormField<Medicament>(
                  decoration: const InputDecoration(
                    labelText: 'Médicament',
                  ),
                  value: null,
                  items: snapshot.data?.map((medicament) {
                    return DropdownMenuItem<Medicament>(
                      value: medicament,
                      child: Text(medicament.nom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _medicamentController.text = value?.nom ?? '';
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez choisir un médicament';
                    }
                    return null;
                  },
                );
              } else if (snapshot.hasError) {
                return Text("Erreur : ${snapshot.error}");
              }

              // Par défaut, affichez un indicateur de chargement.
              return const CircularProgressIndicator();
            },
          ),
          FutureBuilder<List<Plante>>(
            future: _fetchPlantes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DropdownButtonFormField<Plante>(
                  decoration: const InputDecoration(
                    labelText: 'Plante',
                  ),
                  value: null,
                  items: snapshot.data?.map((plante) {
                    return DropdownMenuItem<Plante>(
                      value: plante,
                      child: Text(plante.nom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _planteController.text = value?.nom ?? '';
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez choisir une plante';
                    }
                    return null;
                  },
                );
              } else if (snapshot.hasError) {
                return Text("Erreur : ${snapshot.error}");
              }

              // Par défaut, affichez un indicateur de chargement.
              return const CircularProgressIndicator();
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir une description';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final conn = await MySqlConnection.connect(ConnectionSettings(
                    host: '82.165.56.139', 
                    port: 3306,
                    user: 'root',
                    password: 'mdpbdlinux',
                    db: 'medoPlante',
                  ));
                  var medicament = await _fetchMedicament(_medicamentController.text);
                  var plante = await _fetchPlante(_planteController.text);
                  if (medicament != null && plante != null) {
                    await conn.query(
                      'insert into interactions (medicament_id, plante_id, description) values (?, ?, ?)',
                      [medicament.id, plante.id, _descriptionController.text],
                    );
                  }
                }
              },
              child: const Text('Ajouter'),
            ),
          ),
        ],
      ),
    );
  }
}