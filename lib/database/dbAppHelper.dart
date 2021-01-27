import 'package:attendanceApp/models/absence.dart';
import 'package:attendanceApp/models/cours.dart';
import 'package:attendanceApp/models/etudiant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import 'package:attendanceApp/models/promo.dart';

class DbAppHelper {

  static DbAppHelper dbHelper; // will be initialse only once
  static Database database;

  DbAppHelper.createInstance();

  factory DbAppHelper() { // factory car il va retourner une valeur
    if(dbHelper == null) { // la creation d'une instance ssi l objet est null
      dbHelper = DbAppHelper.createInstance();
    }
    return dbHelper;
  }

  String colId = 'id';
  String promoTable = 'promo'; String colFileName = 'fileName'; String colFilePath = 'filePath';
  String courTable = 'cour'; String colCourName = 'courName'; String colCourPath = 'courPath';
  String etudiantTable = 'etudiant'; String colNom = 'nom'; String colPrenom = 'prenom'; String colFiliere = 'filiere'; String colCne = 'cne';
  String absenceTable = 'absence'; String colDate = 'date'; String colObservation = 'observation'; String colJustify = 'justify'; String colAbsCne = 'cne'; String colAbsPromo = 'promo';

  Future<Database> get _database async {
    if(database == null) {
      database = await initializeDatabase();
    }
    return database;
  }

  Future<Database> initializeDatabase () async {
    Directory dir = await getApplicationDocumentsDirectory(); // pour recupere le path vers le database
    String path = dir.path + 'appDatabase.db';
    var appDatabase = await openDatabase(path, version: 1, onCreate: createDatabase); // creer la db avec le chemin crre
    return appDatabase;
  }

  void deletDatabase() async{
    Directory dir = await getApplicationDocumentsDirectory(); // pour recupere le path vers le database
    String path = dir.path + 'appDatabase.db';
    await deleteDatabase(path);
  }

  void createDatabase(Database db, int version) async {
    await db.execute('CREATE TABLE $promoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colFileName TEXT, $colFilePath TEXT)');
    await db.execute('CREATE TABLE $courTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCourName TEXT, $colCourPath TEXT)');
    await db.execute('CREATE TABLE $etudiantTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colCne TEXT, $colNom TEXT, $colPrenom TEXT, $colFiliere TEXT)');
    await db.execute('CREATE TABLE $absenceTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDate TEXT, $colObservation TEXT, $colJustify TEXT, $colAbsCne TEXT, $colAbsPromo TEXT)');
  }

  // ---- Promo Table Operation ----- //

  Future<List<Map<String, dynamic>>> getPromoMapList() async {
    Database db = await this._database;
     var resultat = await db.rawQuery('SELECT * FROM $promoTable ORDER BY $colId DESC');
    //var resultat = await db.query(promoTable');
    return resultat;
  }

  Future<List<Promo>> getPromoList() async {
    var promoMapList = await getPromoMapList();
    int count = promoMapList.length;

    List<Promo> promoList = List<Promo>();
    for(int i = 0; i<count; i++ ) {
      promoList.add(Promo.getMap(promoMapList[i]));
    }
    return promoList;
  }

  Future<int> savePromo(Promo promo) async {
    Database db = await this._database;
    var resultat = await db.insert(promoTable, promo.toMap());
    return resultat;
  }

  Future<int> updatePromo(Promo promo) async {
    Database db = await this._database;
    var resultat = await db.update(promoTable, promo.toMap(), where: '$colId = ?', whereArgs: [promo.id]);
    return resultat;
  }

  Future<int> deletePromo(int id) async {
    Database db = await this._database;
    var resultat = await db.rawDelete('DELETE FORM $promoTable WHERE $colId = $id');
    return resultat;
  }

  Future<int> deleteAllPromo() async {
    Database db = await this._database;
    //var resultat = await db.delete(promoTable, where: '$colId = ?', whereArgs: [id]);
    var resultat = await db.rawDelete('DELETE * FORM $promoTable');
    return resultat;
  }

  Future<int> getCountPromo() async {
    Database db = await this._database;
    List<Map<String, dynamic>> countAll = await db.rawQuery('SELECT COUNT (*) FROM $promoTable');
    int resultat = Sqflite.firstIntValue(countAll);
    return resultat;
  }

  // ---- Cour Table Operation ---- //

  Future<List<Map<String, dynamic>>> getCourMapList() async {
    Database db = await this._database;
    var resultat = await db.rawQuery('SELECT * FROM $courTable ORDER BY $colId DESC');
    return resultat;
  }

  Future<List<Cour>> getCourList() async {
    var courMapList = await getCourMapList();
    int count = courMapList.length;

    List<Cour> courList = List<Cour>();
    for(int i = 0; i<count; i++ ) {
      courList.add(Cour.getMap(courMapList[i]));
    }
    return courList;
  }

  Future<int> saveCour(Cour cour) async {
    Database db = await this._database;
    var resultat = await db.insert(courTable, cour.toMap());
    return resultat;
  }

  Future<int> deleteCour(int id) async {
    Database db = await this._database;
    var resultat = await db.rawDelete('DELETE FROM $courTable WHERE $colId = $id');
    return resultat;
  }

  Future<int> getCountCour() async {
    Database db = await this._database;
    List<Map<String, dynamic>> countAll = await db.rawQuery('SELECT COUNT (*) FROM $courTable');
    int resultat = Sqflite.firstIntValue(countAll);
    return resultat;
  }


  // ---- Etudiant Table Operation ---- //

  Future<List<Map<String, dynamic>>> getEtudiantByFiliereMapList(String filiere) async {
    Database db = await this._database;
    //var resultat = await db.rawQuery('SELECT * FROM $etudiantTable WHERE $colFiliere = $filiere ');
    var resultat  = await db.query(etudiantTable, where: '$colFiliere = ?', whereArgs: [filiere]);
    return resultat;
  }

  Future<List<Etudiant>> getEtudiantByFiliereList(String filiere) async {
    var etudiantMapList = await getEtudiantByFiliereMapList(filiere);
    int count = etudiantMapList.length;

    List<Etudiant> etudiantList = List<Etudiant>();
    for(int i = 0; i<count; i++ ) {
      etudiantList.add(Etudiant.getMap(etudiantMapList[i]));
    }
    return etudiantList;
  }

  Future<int> saveEtudiant(Etudiant etudiant) async {
    Database db = await this._database;
    var resultat = await db.insert(etudiantTable, etudiant.toMap());
    return resultat;
  }

  Future<int> getCountEtudiant() async {
    Database db = await this._database;
    List<Map<String, dynamic>> countAll = await db.rawQuery('SELECT COUNT (*) FROM $etudiantTable');
    int resultat = Sqflite.firstIntValue(countAll);
    return resultat;
  }

  // ----- Absence Table Operation ---- //

  Future<int> saveAbsence(Absence absence) async {
    Database db = await this._database;
    var resultat = await db.insert(absenceTable, absence.toMap());
    return resultat;
  }

  Future<int> updateAbsence(Absence absence) async {
    Database db = await this._database;
    var resultat = await db.update(absenceTable, absence.toMap(), where: '$colId = ?', whereArgs: [absence.id]);
    return resultat;
  }

  Future<int> deleteAbsence(int id) async {
    Database db = await this._database;
    var resultat = await db.rawDelete('DELETE FROM $absenceTable WHERE $colId = $id');
    return resultat;
  }

  Future<int> getCountAbsNonJustifie(String filiere, String cne) async {
    Database db = await this._database;
    List<Map<String, dynamic>> countAll = await db.rawQuery('SELECT COUNT (*) FROM $absenceTable WHERE $colAbsPromo = "$filiere" AND $colAbsCne = "$cne" AND $colJustify = "false"');
    int resultat = Sqflite.firstIntValue(countAll);
    return resultat;
  }

  Future<int> getCountAbs(String filiere, String cne) async {
    Database db = await this._database;
    List<Map<String, dynamic>> countAll = await db.rawQuery('SELECT COUNT (*) FROM $absenceTable WHERE $colAbsPromo = "$filiere" AND $colAbsCne = "$cne"');
    int resultat = Sqflite.firstIntValue(countAll);
    return resultat;
  }

  Future<List<Map<String, dynamic>>> getAbsenceEtdMapList(String filiere, String cne) async {
    Database db = await this._database;
    var resultat = await db.rawQuery('SELECT * FROM $absenceTable WHERE $colAbsPromo = "$filiere" AND $colAbsCne = "$cne"');
    return resultat;
  }

  Future<List<Absence>> getAbsenceEtdList(String filiere, String cne) async {
    var absenceMapList = await getAbsenceEtdMapList(filiere,cne);
    int count = absenceMapList.length;

    List<Absence> absenceList = List<Absence>();
    for(int i = 0; i<count; i++ ) {
      absenceList.add(Absence.getMap(absenceMapList[i]));
    }
    return absenceList;
  }

  Future<List<Map<String, dynamic>>> getAllAbsenceMapList() async {
    Database db = await this._database;
    var resultat = await db.rawQuery('SELECT * FROM $absenceTable');
    return resultat;
  }

  Future<List<Absence>> getAllAbsenceList() async {
    var absenceMapList = await getAllAbsenceMapList();
    int count = absenceMapList.length;

    List<Absence> absenceList = List<Absence>();
    for(int i = 0; i<count; i++ ) {
      absenceList.add(Absence.getMap(absenceMapList[i]));
    }
    return absenceList;
  }


}