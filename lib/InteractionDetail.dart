import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'models/dao.dart';

class InteractionDetail extends StatefulWidget {
  final String medicamentId;
  final String planteId;

  const InteractionDetail({Key? key, required this.medicamentId, required this.planteId}) : super(key: key);

  @override
  _InteractionDetailState createState() => _InteractionDetailState();
}

class _InteractionDetailState extends State<InteractionDetail> {
  final Map<String, String> _interactionCleVal = {};
  String medicamentName = '';
  String planteName = '';

  @override
  void initState() {
    super.initState();
    _fetchNames();
    _fetchInteraction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails des interactions'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'Médicament: ',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      Text(
                        medicamentName,
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Plante: ',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      Text(
                        planteName,
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _interactionCleVal.length,
              itemBuilder: (context, index) {
                String key = _interactionCleVal.keys.elementAt(index);
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ExpansionTile(
                    leading: const Icon(Icons.medical_services, color: Colors.blueGrey),
                    title: Text(key, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(_interactionCleVal[key]!, style: const TextStyle(fontSize: 16.0, color: Colors.blueGrey)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

    void _fetchNames() async {
      Dao dao = await Dao.getInstance();

      // Utilisez l'instance pour appeler les méthodes de Dao
      Results mName = await dao.fetchMedicamentNameById(int.parse((widget.medicamentId)));
      
      Results pName = await dao.fetchPlanteNameById(int.parse((widget.planteId)));

      setState(() {
        medicamentName = mName.first[0].toString();
        planteName = pName.first[0].toString();
      });
      
  }

  void _fetchAllDatas() async {
      // Affichez les résultats
  }


  void _fetchInteraction() async {
      // Affichez les résultats
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '82.165.56.139', 
      port: 3306,
      user: 'root',
      password: 'mdpbdlinux',
      db: 'medoPlante',
    ));

    var result = await conn.query(
      'SELECT * FROM interactions WHERE medicament_id = ? AND plante_id = ?',
      [widget.medicamentId, widget.planteId],
    );

    if (result.isNotEmpty) {
      setState(() {
        //_interaction = result.map((row) => row['titre'].toString()).toList();
        //Map qui contient en cle row['titre'] et en valeur row['description']
        for (var row in result) {
        _interactionCleVal[row['titre'].toString()] = row['description'].toString();
      }
      });
    } else {
      setState(() {
        //_interaction = ['Aucune interaction trouvée.'];
      });
    }
  }

}