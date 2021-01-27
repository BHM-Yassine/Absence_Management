import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:attendanceApp/models/etudiant.dart';
import 'package:attendanceApp/pages/classes/parseFile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'package:attendanceApp/models/promo.dart';
import 'package:attendanceApp/database/dbAppHelper.dart';
import 'package:csv/csv.dart';
import '../etudiant/listEtudiant.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  DbAppHelper dbHelper = DbAppHelper();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Promo> promoList;
  int count = 0;

  TextEditingController fileNameController = new TextEditingController();
  String fileName;
  File file;
  List<List<dynamic>> fileData = [];

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  void executeAddPromo() async {

    file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['csv']
    );

    fileNameController.text = "";

    print(file.path);

    addPromo(Promo(fileName,file.path));

    saveFileToDataBase(file.path, fileName);

    //getLisEtdFromFileToDataBase(file.path, fileName);

    showNotificationClasses('Ajout avec success');
  }

  showNotificationClasses(String msg) {
    scaffoldKey.currentState.showSnackBar(
        SnackBar(
          elevation: 10,
          backgroundColor: Colors.white,
          content: Container(
              child: Text(msg, style: TextStyle(color: Color(0xFF650c8e), fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),)
          ),
        )
    );
  }

  /*void getLisEtdFromFileToDataBase(String pathFile, String promoName) async {

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
  }*/

  void showAddPromoDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: size.height * 0.27,
            width: size.width * 0.312,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all((Radius.circular(15))),
                color: Color(0xffED3C63)
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(),
                      Text('Ajouter une classe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                      Container(),
                    ],
                  ),
                ),
                Container(
                  width: size.width*0.487,
                  child: TextField(
                    controller: fileNameController,
                    decoration: InputDecoration(
                        hintText: 'Nom de la classe',
                        hintStyle: TextStyle(fontSize: 13),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70.withOpacity(0.6))
                        )
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                    onChanged: (text){
                      setState(() {
                        this.fileName = text;
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
                              fileNameController.text = "";
                            },
                          ),
                        ),
                        SizedBox(
                          width: size.width*0.187,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            color: Color(0xffa85acc),
                            child: Icon(Icons.cloud_upload, color: Colors.white, size: 30,),
                            onPressed: () {
                              executeAddPromo();
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

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Promo>> promoListFuture = dbHelper.getPromoList();

      promoListFuture.then((promoList) {
        if(mounted) {
          setState(() {
            this.promoList = promoList;
            this.count = promoList.length;
          });
        }
      });
    });
  }

  void addPromo(Promo promo) async {
    int resultat = await dbHelper.savePromo(promo);
    if(resultat != 0) {
      if(mounted) {
        setState(() {
          this.updateListView();
        });
      }
    }
  }

  void navigateToListEtudiant(Promo promo) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ListEtudiant(promo);
    }));
  }

  Widget header(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      child: Container(
            height: size.height*0.325,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                //bottomRight: Radius.circular(50),
              ),
            ),
        child: textHeader(context),
      ),
    );
  }

  Widget textHeader(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.224),
            child: Text("Classes", style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: Color(0xFF650c8e))),
            //
          ),
          Container(),
        ],
      ),
    );
  }

  Widget addPromoButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * 0.272,
      right: size.width * 0.094,
      child: Container(
          child: FloatingActionButton(
              elevation: 20,
              child: Icon(Icons.add, size: 50,),
              backgroundColor: Color(0xffED3C63),
              onPressed:() {
                showAddPromoDialog(context);
              }
          ),
      ),
    );
  }

  Widget promoListView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: ListView.builder(
          padding: EdgeInsets.only(top: size.height * 0.44),
          itemCount: this.count,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10.0, bottom: 10),
              child: Container(
                    height: size.height*0.094,
                    decoration: BoxDecoration(
                      color: Color(0xffED3C63),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.2),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(this.promoList[index].fileName, style: TextStyle(color: Color(0xffffffff), fontSize: 20, fontWeight: FontWeight.bold),),
                      trailing: Icon(Icons.navigate_next,color: Colors.white,),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListEtudiant(promoList[index])));
                        //navigateToListEtudiant(this.promoList[index]);
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
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Color(0xFF650c8e)
          ),
          elevation: 0,
        ),
        //key: scaffoldKey,
        //drawer: Menu(),
        backgroundColor: Color(0xFF650c8e),
          body:
          Stack(
            children: <Widget>[
              if(promoList == null )
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.224),
                child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),),
              ),
              promoListView(context),
              header(context),
              Positioned(
                  left: size.width *  0.218,
                  child: Image(image: AssetImage('assets/images/background.png'), width: size.width * 0.6,)),
              //background(),
              addPromoButton(context),
              if(promoList?.length == 0) noDataDisplay(context),
            ],
          )
      ),
    );
  }
}

