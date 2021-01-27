import 'package:attendanceApp/models/absence.dart';
import 'package:attendanceApp/models/etudiant.dart';
import 'package:attendanceApp/models/promo.dart';
import 'package:attendanceApp/database/dbAppHelper.dart';
import 'package:flutter/material.dart';

class AbsenceDetails extends StatefulWidget {
  final Promo promo;
  final Etudiant etudiant;

  AbsenceDetails(this.promo, this.etudiant);

  @override
  AbsenceDetailsState createState() => AbsenceDetailsState(this.promo, this.etudiant);
}

class AbsenceDetailsState extends State<AbsenceDetails> {
  final Promo promo;
  final Etudiant etudiant;
  AbsenceDetailsState(this.promo, this.etudiant);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  DbAppHelper dbHelper = DbAppHelper();
  List<Absence> listAbsence;
  int count = 0;
  int nbAbsNonJustifie = 0;

  TextEditingController justificationController = new TextEditingController();
  String justification;

  void getNbAbsNonJustifie() {
    Future<int> nb = dbHelper.getCountAbsNonJustifie(promo.fileName, etudiant.cne);
    nb.then((value) {
      setState(() {
        this.nbAbsNonJustifie = value;
      });
    });
  }
  void updateListView() {
    Future<List<Absence>> listAbsenceFuture = dbHelper.getAbsenceEtdList(promo.fileName, etudiant.cne);
    listAbsenceFuture.then((listAbs) {
      setState(() {
        this.listAbsence = listAbs;
        this.count = listAbs.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateListView();
    getNbAbsNonJustifie();
  }

  void showNotification(String msg) {
    scaffoldKey.currentState..showSnackBar(
        SnackBar(
          elevation: 10,
          backgroundColor: Color(0xffED3C63),
          content: Container(
              child: Text(msg, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),)
          ),
        )
    );
  }

  void showAlertDialogForDelete(Absence absence) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height*0.28,
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
                              child: Text("Oui", style: TextStyle(color: Color(0xffED3C63)),),
                              onPressed: () {
                                print('Oui');
                                deleteAbsence(absence);
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
                            child: Text("Non", style: TextStyle(color: Color(0xffED3C63)),),
                            onPressed: () {
                              print('Non');
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
            backgroundColor: Color(0xffED3C63),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          );
        }
    );}

  void deleteAbsence(Absence absence) async {
    int res = await dbHelper.deleteAbsence(absence.id);
    if(res != 0) {
      setState(() {
        updateListView();
        getNbAbsNonJustifie();
        showNotification('Absence supprimée');
      });
    }
  }

  void showDetailAbsence(Absence absence)  {
    justification = absence.observation;
    justificationController.text = absence.observation;
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 20,
          backgroundColor: Color(0xffED3C63),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          child: Container(
            height: size.height * 0.27,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(),
                      Text('Observation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                      Container(),
                    ],
                  ),
                ),
                Container(
                  width: size.width*0.6,
                  child: TextField(
                    controller: justificationController,
                    decoration: InputDecoration(
                        hintText: 'Justification',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70.withOpacity(0.6))
                        )
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                    onChanged: (text){
                      setState(() {
                        this.justification = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: size.width*0.282,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      color: Color(0xffffffff),
                      child: Text("Modifier", style: TextStyle(color: Color(0xffa85acc), fontWeight: FontWeight.bold, fontSize: 15),),
                      onPressed: () {
                        this.justificationController.text = "";
                        onUpdateAbsence(absence);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onUpdateAbsence(Absence absence) async {
    if(justification == "") {
      absence.observation = justification;
      absence.justify = "false";
    }
    if(justification != "") {
      absence.observation = justification;
      absence.justify = "true";
    }

    int res = await dbHelper.updateAbsence(absence);
    if(res != 0) {
      setState(() {
        updateListView();
        getNbAbsNonJustifie();
      });
      showNotification('Absence modifiée');
    }

  }

  Widget noDataDisplay(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size.height*0.224),
      child: Center(child: Text('No Data', style: TextStyle(fontSize: 15, color: Color(0xffED3C63)),)),
    );
  }
  Widget header(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.228,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: Color(0xffED3C63),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          //bottomRight: Radius.circular(35),
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
            padding: EdgeInsets.only(top: size.height * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //textDirection: TextDirection.ltr,
              children: <Widget>[
                Text('${etudiant.nom} ${etudiant.prenom} ', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white)),
                Text(etudiant.cne, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    height: 0.5,
                    width: size.width * 0.31,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text('Absences non justifié', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: new BoxDecoration(
                            color: Color(0xFF650c8e),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text('$nbAbsNonJustifie' , style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(),
        ],
      ),
    );
  }
  Widget listAbsences(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: size.height*0.267, left:3, right:3),
        child: ListView.builder(
            itemCount: count,
            itemBuilder: (context, index){
              return Container(
                child: Card(
                  child: Container(
                    height: size.height*0.11,
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
                      child: Center(
                        child: ListTile(
                          dense: true,
                          leading:  Container(
                            width: size.width*0.21,
                            height: size.height * 0.038,
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(9)),
                              color: Color(0xFF650c8e),
                              shape: BoxShape.rectangle,
                            ),
                            child: Center(child: Text(listAbsence[index].date, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),)),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child:
                            (listAbsence[index].justify == 'true')
                                ?
                            Text(listAbsence[index].observation,style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 16),)
                                :
                            Text('Non justifié',style: TextStyle(color: Color(0xffED3C63),fontStyle: FontStyle.italic, fontWeight: FontWeight.w500, fontSize: 16),)

                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Color(0xffED3C63),),
                            tooltip: 'Supprimer',
                            onPressed: () {
                              showAlertDialogForDelete(listAbsence[index]);
                              print('Suprimmmmmmer');
                              //Navigator.of(context).pop();
                            },
                          ),
                          onLongPress: () {
                            showDetailAbsence(listAbsence[index]);
                          },
                        ),
                      ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          backgroundColor: Color(0xffED3C63),
          title: Text('Résumé d\'absence', style: TextStyle(color: Colors.white),),
        ),
        body: Stack(
          children: <Widget>[
            if(listAbsence == null )
            Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xffED3C63)),),),
            listAbsences(context),
            header(context),
            if (listAbsence?.length == 0)  noDataDisplay(context)
          ],
        )
      ),
    );
  }
}
