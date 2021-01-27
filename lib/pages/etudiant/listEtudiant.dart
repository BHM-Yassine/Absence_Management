import 'dart:async';
import 'dart:ui';
import 'package:attendanceApp/models/absence.dart';
import 'package:attendanceApp/models/etudiant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:attendanceApp/models/promo.dart';
import 'package:attendanceApp/database/dbAppHelper.dart';
import 'package:badges/badges.dart';
import '../absence/absenceDetails.dart';



class ListEtudiant extends StatefulWidget {
  final Promo promo;
  ListEtudiant(this.promo);

  @override
  ListEtudiantState createState() => ListEtudiantState(this.promo);
}

class ListEtudiantState extends State<ListEtudiant> {
  Promo promo;
  ListEtudiantState(this.promo);
  DbAppHelper dbHelper = DbAppHelper();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Etudiant> listEtd;
  int count = 0;
  List<Etudiant> listEtdWithAbs = new List<Etudiant>();
  int countAbs = 0;
  List<bool> inputs = new List<bool> ();
  var now = new DateFormat("dd MMMM yyyy").format(DateTime.now());

  @override
  void initState() {
    super.initState();
    getListEtdByPromo();
  }

  void ItemChange(bool val,int index, Etudiant etd){
    setState(() {
      inputs[index] = val;
      if(!val){
        listEtdWithAbs.remove(etd);
        this.countAbs = listEtdWithAbs.length;
      }
      if(val){
        listEtdWithAbs.add(etd);
        this.countAbs = listEtdWithAbs.length;
      }
    });
  }

  void saveAbsences() async{

    if(listEtdWithAbs != null) {
      for (Etudiant etd in listEtdWithAbs)  {
        Absence absence = new Absence(now, '', 'false', promo.fileName, etd.cne);
        int res = await dbHelper.saveAbsence(absence);
      }
    }
  }

  getListEtdByPromo() {
    final Future<Database> dbFuture = dbHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Etudiant>> etdListFuture = dbHelper.getEtudiantByFiliereList(promo.fileName);

      etdListFuture.then((etdList) {
        setState(() {
          this.listEtd = etdList;
          this.count = etdList.length;
          for(int i=0; i<listEtd.length; i++) {
            inputs.add(false);
          }
        });
      });
    });
  }

  Widget header(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: Color(0xFF650c8e),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: textHeader(context),
    );
  }
  Widget textHeader(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.075),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //textDirection: TextDirection.ltr,
              children: <Widget>[
                Text("Classe", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
                Text(promo.fileName, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 22, fontWeight: FontWeight.w400, color: Colors.white)),
              ],
            ),
          ),
          Container(),
        ],
      ),
    );
  }
  Widget saveButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: size.height * 0.094,
          width: size.width,
            child: RaisedButton(
              color: Color(0xFF650c8e),
              onPressed: () {
                dialogWindowListEtdAbs(context);
              },
              textColor: Colors.white,
              child: Text('Enregistrer', style: TextStyle(fontSize: 20)),
            )
        ),
    );
  }
  Widget noDataDisplay() {
    return Center(child: Text('No Data'));
  }
  Widget listEtdView(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.only(top: size.height * 0.224, left:2.0, right:2, bottom: size.height*0.11),
        child:
        ListView.builder(
            itemCount: this.count,
            itemBuilder: (context, index){
              return Container(
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: CheckboxListTile(
                      activeColor: Color(0xffED3C63),
                      value: inputs[index],
                      title:  ListTile(
                        leading:  Badge(
                          toAnimate: false,
                          badgeColor: Color(0xffED3C63),
                          shape: BadgeShape.circle,
                          padding: EdgeInsets.all(8),
                          badgeContent: Text('${index+1}', style: TextStyle(color: Colors.white, fontSize: 15)),
                        ),
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('${listEtd[index].nom} ${listEtd[index].prenom}',
                                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 15),),
                              Text(listEtd[index].cne,
                                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.normal, fontSize: 12),),
                            ],
                          ),
                        onLongPress: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AbsenceDetails(this.promo, listEtd[index]) ));
                            },
                         ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged:(bool val){
                        ItemChange(val, index, listEtd[index]);
                      }
                    )
                  ),
                ),
              );
            }
        )
    );
  }
  dialogWindowListEtdAbs(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return (listEtdWithAbs.length != 0)
              ?
          Dialog(
            elevation: 20,
            backgroundColor: Color(0xffED3C63),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
            child:Container(
              height: size.height * 0.525,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all((Radius.circular(10))),
                  color: Color(0xffED3C63)
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Container(
                        child: Center(child: Text('List des absences', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)))
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top:4.0),
                      child: Badge(
                          elevation: 5,
                          badgeColor: Color(0xFF650c8e),
                          shape: BadgeShape.square,
                          borderRadius: 15,
                          badgeContent: Text(now, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.white)))
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      height: size.height * 0.282,
                      child: ListView(
                        children: listEtdWithAbs.map((data) => Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 20, bottom: 5),
                              child: Text('>   ${data.nom} ${data.prenom}', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                            ),
                            )).toList(),
                          ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.cancel, size: 40,color: Colors.white,),
                        tooltip: 'Annuler',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check_circle, size: 40,color: Colors.white,),
                        tooltip: 'Confirmer',
                        onPressed: () {
                          saveAbsences();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
              :
          Dialog(
            elevation: 20,
            backgroundColor: Color(0xffED3C63),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
              child: Container(
              height: size.height * 0.356,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all((Radius.circular(10))),
                  color: Color(0xffED3C63)
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                        child: Center(child: Text('List des absences', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)))
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:4.0),
                    child: Badge(
                        elevation: 5,
                        badgeColor: Color(0xFF650c8e),
                        shape: BadgeShape.square,
                        borderRadius: 15,
                        badgeContent: Text(now, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.white)))
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.0562),
                    child: Text('Aucune absence', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.0525),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.cancel, size: 40,color: Colors.white,),
                          tooltip: 'Annuler',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.check_circle, size: 40,color: Colors.white,),
                          tooltip: 'Confirmer',
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget background(BuildContext context) {
    return  Positioned(
        top: 0,
        right: MediaQuery.of(context).size.width * 0.078,
        child: Image(image: AssetImage('assets/images/background2.png'), width: MediaQuery.of(context).size.width * 0.25,)
    );
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            elevation: 0,
            backgroundColor: Color(0xFF650c8e),
            title: Text('Gestion d\'absence', style: TextStyle(color: Colors.white),),
          ),
          body: Stack(
              children: <Widget>[
                if(listEtd == null )
                  Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF650c8e)),),),
                listEtdView(context),
                header(context),
                background(context),
                //if(listEtd.length != 0 && listEtd != null)
                //if(isEndList)
                saveButton(context),
                if(listEtd?.length == 0) noDataDisplay()
              ]
          )
      ),
    );
  }


}
