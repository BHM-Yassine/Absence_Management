import 'dart:io';
import 'package:attendanceApp/database/dbAppHelper.dart';
import 'package:attendanceApp/models/etudiant.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

List<List<dynamic>> fileData = [];
DbAppHelper dbHelper = DbAppHelper();



void saveFileToDataBase(String pathFile, String promoName) async {

  // get list from file
  final myData = await File(pathFile).readAsString();
  fileData = CsvToListConverter(fieldDelimiter: ";").convert(myData);
  List<Etudiant> list = [] ;

  for(int i=1; i< fileData.length; i++) {
    list.add(Etudiant(fileData[i][0],fileData[i][1],fileData[i][2],promoName));
  }

  // save the list in datavase
  for (Etudiant etd in list) {
    await dbHelper.saveEtudiant(etd);
  }
}