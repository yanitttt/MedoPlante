import 'package:mysql1/mysql1.dart';

class Dao {
  final MySqlConnection _connection;

  Dao(this._connection);

  static Future<Dao> getInstance() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '82.165.56.139', 
      port: 3306,
      user: 'root',
      password: 'mdpbdlinux',
      db: 'medoPlante',
    ));
    return Dao(conn);
  }

  Future<Results> fetchAll(String tableName) async {
    var result = await _connection.query('SELECT * FROM $tableName');
    return result;
  }


  /* ================================== SECTION UTILISATEURS ================================== */

  Future<Results> fetchUserById(int id) async {
    var result = await _connection.query('SELECT * FROM utilisateurs WHERE id = ?', [id]);
    return result;
  }


  Future<Results> fetchAllUsers() async {
    var result = await _connection.query('SELECT * FROM utilisateurs');
    return result;
  }

  Future<Results> login(String username, String password) async {
    var result = await _connection.query(
      'SELECT * FROM utilisateurs WHERE username = ? AND password = ?',
      [username, password],
    );
    return result;
  }

  /* ================================== SECTION MEDICAMENTS ================================== */

  Future<Results> fetchAllMedicaments() async {
  var result = await _connection.query('SELECT * FROM medicaments');
  return result;
}

  Future<Results> fetchMedicamentNameById(int id) async {
    var result = await _connection.query('SELECT nom FROM medicaments WHERE id = ?', [id]);
    return result;
}

  //getNameById
  Future<Results> getMedicamentNameById(int id) async {
    var result = await _connection.query('SELECT * FROM medicaments WHERE id = ?', [id]);
    return result;
}

  /* ================================== SECTION PLANTES ================================== */
  
  Future<Results> fetchAllPlantes() async {
    var result = await _connection.query('SELECT * FROM plantes');
    return result;
}

  Future<Results> fetchPlanteNameById(int id) async {
    var result = await _connection.query('SELECT nom FROM plantes WHERE id = ?', [id]);
    return result;
}

  Future<Results> getPlanteNameById(int id) async {
    var result = await _connection.query('SELECT * FROM plantes WHERE id = ?', [id]);
    return result;
}


  
  /* ================================== SECION HISTORIQUE ================================== */

  Future<Results> fetchAllHistorique() async {
    var result = await _connection.query('SELECT * FROM historique_recherches');
    return result;
  }

  Future<Results> fetchHistoriqueById(int id) async {
    var result = await _connection.query('SELECT * FROM historique_recherches WHERE id = ?', [id]);
    return result;
  }

  Future<Results> fetchHistoriqueByUserId(int id) async {
    var result = await _connection.query('SELECT * FROM historique_recherches WHERE id_utilisateur = ?', [id]);
    return result;
  }

  //Donner l'histo d'un utilisateur par son id apres une date donnée
  Future<Results> fetchHistoriqueByUserIdAfterDate(int id, String date) async {
    var result = await _connection.query('SELECT * FROM historique_recherches WHERE id_utilisateur = ? AND date > ?', [id, date]);
    return result;
  }


}