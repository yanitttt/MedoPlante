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

  Future<Results> fetchById(String tableName, String id) async {
    var result = await _connection.query('SELECT * FROM $tableName WHERE id = ?', [id]);
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

  /* ================================== SECTION PLANTES ================================== */
  
  Future<Results> fetchAllPlantes() async {
    var result = await _connection.query('SELECT * FROM plantes');
    return result;
}

  Future<Results> fetchPlanteNameById(int id) async {
    var result = await _connection.query('SELECT nom FROM plantes WHERE id = ?', [id]);
    return result;
}

  // Ajoutez plus de méthodes au besoin...
}