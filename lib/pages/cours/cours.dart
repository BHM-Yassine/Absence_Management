import 'dart:io';
import 'package:attendanceApp/database/dbAppHelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:attendanceApp/models/cours.dart';
import 'dart:async';
import 'dart:core';

import 'courViewer.dart';

class CoursPage extends StatefulWidget {
  @override
  _CoursPageState createState() => _CoursPageState();
}

class _CoursPageState extends State<CoursPage> {
  DbAppHelper dbHelper = DbAppHelper();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Cour> courList;
  int count = 0;

  TextEditingController courNameController = new TextEditingController();
  String courName;

  File file;

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Cour>> courListFuture = dbHelper.getCourList();

      courListFuture.then((courList) {
        if(mounted){
        setState(() {
          this.courList = courList;
          this.count = courList.length;
        });
      }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void showAddCourDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: size.height * 0.25,
            width: size.width * 0.312,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all((Radius.circular(15))),
                color: Color(0xffa85acc)
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(),
                      Text('Ajouter un cours', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                      Container(),
                    ],
                  ),
                ),
                Container(
                  width: size.width*0.487,
                  child: TextField(
                    controller: courNameController,
                    decoration: InputDecoration(
                        hintText: 'Libelle cours',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70.withOpacity(0.6))
                        )
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                    onChanged: (text){
                      setState(() {
                        this.courName = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(),
                      Container(),
                      SizedBox(
                        width: size.width*0.282,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          color: Color(0xffffffff),
                          child: Text("Annuler", style: TextStyle(color: Color(0xffa85acc), fontWeight: FontWeight.bold, fontSize: 15),),
                          onPressed: () {
                            Navigator.pop(context);
                            courNameController.text = "";
                          },
                        ),
                      ),
                      SizedBox(
                        width: size.width*0.187,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          color: Color(0xFF650c8e),
                          child: Icon(Icons.cloud_upload, color: Colors.white, size: 30,),
                          onPressed: () {
                            executeAddCour();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(),
                      Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addCour(Cour cour) async {
    int resultat = await dbHelper.saveCour(cour);
    if(resultat != 0) {
      if(mounted) {
        setState(() {
          this.updateListView();
        });
      }
    }
  }

  void executeAddCour() async {
    file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['pdf']
    );

    courNameController.text = "";

    addCour(Cour(courName,file.path));

    showNotification('Ajout avec success');
  }

  void showNotification(String msg) {
    scaffoldKey.currentState.showSnackBar(
        SnackBar(
          elevation: 10,
          backgroundColor: Colors.white,
          content: Container(
              child: Text(msg, style: TextStyle(color: Color(0xffED3C63), fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),)
          ),
        )
    );
  }

  void showAlertDialogForDelete(Cour cour) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(),
                            Text('Suppression', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                            Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(),
                            Text('Êtes-vous sûr de vouloir \nsupprimer ?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white),),
                            Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: SizedBox(
                            width: 60,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                              child: Text("Oui", style: TextStyle(color: Color(0xffa85acc)),),
                              onPressed: () {
                                deleteCour(cour);
                                Navigator.pop(context);
                              },
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            child: Text("Non", style: TextStyle(color: Color(0xffa85acc)),),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            elevation: 20,
            backgroundColor: Color(0xffa85acc),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          );
        }
    );}

  void deleteCour(Cour cour) async {
    int res = await dbHelper.deleteCour(cour.id);
    if(res != 0) {
      if(mounted) {
        setState(() {
          updateListView();
          showNotification('Cours supprimé');
        });
      }
    }
  }


  Widget header(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.225,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xffED3C63),
            offset: Offset(1.0, 1.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: textHeader(context),
    );
  }

  Widget textHeader(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text("Cours", style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: Color(0xFF650c8e))),
          Container(),
        ],
      ),
    );
  }

  Widget addCourButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * 0.17,
      right: size.width * 0.094,
      child: Container(
        child: FloatingActionButton(
            elevation: 20,
            child: Icon(Icons.add, size: 50,),
            backgroundColor: Color(0xFF650c8e),
            onPressed:() {
              showAddCourDialog(context);
            }
        ),
      ),
    );
  }

  Widget courListView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: size.height * 0.34),
        itemCount: this.count,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10.0, bottom: 10),
            child: Container(
                height: size.height*0.094,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(0.2),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(this.courList[index].courName, style: TextStyle(color: Color(0xffED3C63), fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete_outline,color: Color(0xffED3C63),),
                    onTap: () {
                      showAlertDialogForDelete(courList[index]);
                    },
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CourViewer(courList[index])));
                  },
                )
            ),
          );
        },
      ),
    );
  }

  Widget noDataDisplay(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size.height*0.224),
      child: Center(child: Text('No Data', style: TextStyle(fontSize: 15, color: Colors.white),)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold (
          key: scaffoldKey,
          backgroundColor: Color(0xffED3C63),
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Color(0xFF650c8e)
            ),
            elevation: 0,
          ),
          body: Stack(
            children: <Widget>[
              if(courList == null )
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.224),
                  child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),),
                ),
              courListView(context),
              header(context),
              addCourButton(context),
              if(courList?.length == 0) noDataDisplay(context)
            ],
          )
      ),
    );
  }
}

