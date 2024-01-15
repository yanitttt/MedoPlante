import 'package:flutter/material.dart';
import 'interaction.dart';
import 'medicament.dart';
import 'plante.dart';
import 'package:mysql1/mysql1.dart';
import 'add_interaction_form.dart';

class InteractionList extends StatefulWidget {
  const InteractionList({super.key});

  @override
  _InteractionListState createState() => _InteractionListState();
}

class _InteractionListState extends State<InteractionList> {
  final List<Interaction> _interactions = []; // Liste des interactions
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des interactions'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildInteractions(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
          return const Dialog(
            child: AddInteractionForm(),
          );
  },
          );
        }, 
        tooltip: 'Ajouter une interaction',
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _pushSaved() {
    // Fonction pour afficher les interactions sauvegardées
  }

Widget _buildInteractions() {
  return FutureBuilder<List<Interaction>>(
    future: _fetchInteractions(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            var interaction = snapshot.data?[index];
            return ListTile(
              tileColor: index % 2 == 0 ? Colors.white : Colors.grey[200],
              title: Text('${interaction?.medicament.nom} - ${interaction?.plante.nom}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              subtitle: Text(interaction?.description ?? '', style: const TextStyle(color: Colors.black)),
            );
          },
        );
      } else if (snapshot.hasError) {
        return Text("Erreur : ${snapshot.error}", style: const TextStyle(color: Colors.black));
      }

      // Par défaut, affichez un indicateur de chargement.
      return const CircularProgressIndicator();
    },
  );
}
}


Future<List<Interaction>> _fetchInteractions() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '82.165.56.139', 
      port: 3306,
      user: 'root',
      password: 'mdpbdlinux',
      db: 'medoPlante',
    ));

  var result = await conn.query(
    'SELECT medicaments.nom as medicament, plantes.nom as plante, interactions.description as description '
    'FROM interactions '
    'JOIN medicaments ON interactions.medicament_id = medicaments.id '
    'JOIN plantes ON interactions.plante_id = plantes.id'
  );
  

  List<Interaction> interactions = result.map((row) => Interaction(
    Medicament(-1,row['medicament']), 
    Plante(-1,row['plante']), 
    row['description'].toString(),
  )).toList();

  return interactions;
}


