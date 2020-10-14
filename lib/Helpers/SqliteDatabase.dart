import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:ufly/Objetos/Localizacao.dart';
import 'package:ufly/Objetos/User.dart';


import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


Future<Database> _openDatabase() async {
  if (database != null) {
    return database;
  }

  // get the application documents directory

  var dir;
  try {
    dir = await getApplicationDocumentsDirectory();
    print('dir ${dir}');
    await dir.create(recursive: true);
    // build the database path
    var dbPath = join(dir.path, 'ufly.db');
    // open the database
    return await databaseFactoryIo.openDatabase(dbPath);
  } catch (err) {
    dir = '/data/user/0/com.example.ufly/app_flutter';
    var dbPath = join(dir, 'ufly.db');
    // open the database
    return await databaseFactoryIo.openDatabase(dbPath);
  }
  print("PATH LALAL ${dir}"); // make sure it exists
}

SqliteDatabase() {
  _openDatabase();
}

Future<User> getUser() async {
  // Get the records
  Database database = await _openDatabase();

  StoreRef store = intMapStoreFactory.store('user');

  final recordSnapshot = await store.find(database);
  print("[getUser]");
  User u;

  recordSnapshot.forEach((RecordSnapshot record) {
    print("[record] ${record.value}");
    u = User.fromJson(record.value);
  });

  return u;
}



void logUser(User user) async {
  Database database = await _openDatabase();

  var store = intMapStoreFactory.store('user');
  await store.add(database, user.toJson());

  //  _getLocations();
}
DeletarUser() async {
  Database database = await _openDatabase();
  var store = intMapStoreFactory.store('user');
  await store.delete(database);
}

void add(Localizacao l) async {
  Database database = await _openDatabase();

  var store = intMapStoreFactory.store('locations');
  await store.add(database, l.toJson());
  print("ADICIONOU LOCALIZAÇÂO LOL ${l.toString()}");
  //  _getLocations();
}

DeletarPontos() async {
  Database database = await _openDatabase();
  var store = intMapStoreFactory.store('locations');
  await store.delete(database);
  //  _getLocations();
}

Future<List<Localizacao>> getAll() async {
  List<Localizacao> listTemp = new List();
  // Get the records
  Database database = await _openDatabase();

  StoreRef store = intMapStoreFactory.store('locations');

  final recordSnapshot = await store.find(database);
  print("[getLocations]");

  recordSnapshot.forEach((RecordSnapshot record) {
    print("[record] ${record.value}");
    listTemp.add(Localizacao.fromJson(record.value));
  });

  return listTemp;
}

Database database;
