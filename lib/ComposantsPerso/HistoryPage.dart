import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../models/dao.dart';
import '../models/SecureStorage.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _filterType = 'Date';
  String _filterValue = '';
  List<Map<String, dynamic>> _historyData = [];
  Map<String, List<Map<String, dynamic>>> groupedHistory = {}; // Définissez groupedHistory ici

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

void _groupHistory() {
  groupedHistory = {};

  for (var item in _historyData) {
    String key = DateFormat('dd/MM/yyyy').format(item['date_rech']);
    if (groupedHistory.containsKey(key)) {
      groupedHistory[key]!.add(item);
    } else {
      groupedHistory[key] = [item];
    }
    }
}


  void _fetchHistory() async {
    Dao dao = await Dao.getInstance();

    String? id = await SecureStorage().readSecureData('id');

    if (id != null) {
      Results results = await dao.fetchHistoriqueByUserId(int.parse(id));
      print(" ========================================= RESULTATS =========================================  ");
      //afficher chaque resultat dans la console
      for (var element in results) {
        //print(element);
      }

      setState(() {
        _historyData = results.map((row) => row.fields).toList();
      });

      //parcourir chaque element de _historyData
      for (var element in _historyData) {
        //ajouer le nom du medicament dans la liste
        dao.fetchMedicamentNameById(element['id_medicament_rech']).then((value) {
          setState(() {
            //creer un champ 'medicament_name' de tableai _historyData
            
            element['medicament_name'] = value.first.fields['nom'];
          });
        });

        //ajouer le nom de la plante dans la liste
        dao.fetchPlanteNameById(element['id_plante_rech']).then((value) {
          setState(() {
            element['plante_name'] = value.first.fields['nom'];
          });
        });
      }

      _groupHistory(); // Appelez _groupHistory ici

      for (var element in _historyData) {
        print(element);
      }
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Historique', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.deepPurple,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Historique',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _filterType,
            onChanged: (String? newValue) {
              setState(() {
                if (newValue != null) {
                  _filterType = newValue;
                }
              });
            },
            items: <String>['Date', 'ID Médicament', 'ID Plante']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                _filterValue = value;
              });
            },
            decoration: const InputDecoration(
              labelText: "Entrez la valeur du filtre",
            ),
          ),
ElevatedButton(
  onPressed: () {
    // Ajoutez votre logique pour filtrer l'historique ici
    setState(() {
      _historyData = _historyData.where((item) {
        switch (_filterType) {
          case 'Date':
            return DateFormat('dd/MM/yyyy').format(item['date_rech']).contains(_filterValue);
          case 'ID Médicament':
            return item['id_medicament_rech'].toString().contains(_filterValue);
          case 'ID Plante':
            return item['id_plante_rech'].toString().contains(_filterValue);
          default:
            return true;
        }
      }).toList();
      _groupHistory();
    });
  },
  child: const Text('Filtrer'),
),

          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: groupedHistory.keys.length,
              itemBuilder: (context, index) {
                String title = groupedHistory.keys.elementAt(index);
                List<Map<String, dynamic>> items = groupedHistory[title]!;
                return ExpansionTile(
                  title: Text(title),
                  children: items.map((item) {
                    String date = DateFormat('dd/MM/yyyy').format(item['date_rech']);
                    String heure = DateFormat('HH:mm').format(item['date_rech']);
                    String medicamentId = item['id_medicament_rech'].toString() ?? '';
                    String medicamentName = item['medicament_name'] ?? '';
                    String planteName = item['plante_name'] ?? '';
                    // Ajoutez ici les autres champs que vous souhaitez afficher
                    return ListTile(
                      title: Text('\tHeure: $heure'),
                      subtitle: Text('\tMédicament : $medicamentName, Plante : $planteName'),
                      // Utilisez des Text widgets pour afficher les autres champs
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

}