import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'InteractionDetail.dart';
import 'ComposantsPerso/bottom_navigation_bar.dart'; // Ajoutez cette ligne

class InteractionSearch extends StatefulWidget {
  final String? medicamentId;
  final String? planteId;

  const InteractionSearch({super.key, this.medicamentId, this.planteId});

  @override
  _InteractionSearchState createState() => _InteractionSearchState();
}

class _InteractionSearchState extends State<InteractionSearch> {
  final _medicamentController = TextEditingController();
  final _planteController = TextEditingController();
  List<String> _interaction = [];

  @override
  void initState() {
    super.initState();
    _medicamentController.text = widget.medicamentId ?? '';
    _planteController.text = widget.planteId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche d\'interaction'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Entrez le nom du médicament et de la plante pour rechercher les interactions.'),
              TextField(
                controller: _medicamentController,
                decoration: const InputDecoration(
                  labelText: 'Médicament',
                ),
              ),
              TextField(
                controller: _planteController,
                decoration: const InputDecoration(
                  labelText: 'Plante',
                ),
              ),
              ElevatedButton(
                onPressed: _searchInteraction,
                child: const Text('Chercher'),
              ),
              ..._interaction.map((interaction) => Text('• $interaction')).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _searchInteraction() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '82.165.56.139', 
      port: 3306,
      user: 'root',
      password: 'mdpbdlinux',
      db: 'medoPlante',
    ));

    var result = await conn.query(
      'SELECT * FROM interactions WHERE medicament_id = ? AND plante_id = ?',
      [_medicamentController.text, _planteController.text],
    );

    if (result.isNotEmpty) {
      setState(() {
        _interaction = result.map((row) => row['description'].toString()).toList();
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InteractionDetail(medicamentId: _medicamentController.text, planteId: _planteController.text)),
      );
    } else {
      setState(() {
        _interaction = ['Aucune interaction trouvée.'];
      });
    }
  }
}
