import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attendanceApp/database/dbAppHelper.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DbAppHelper dbHelper = DbAppHelper();

  int nbClasses = 0;
  int nbEtudiant = 0;
  int nbCours = 0;

  String coverPath = 'assets/images/ensa.jpg';
  String profilePath = 'assets/images/prof.png';

  final String fullName = "Ezzahir Redouane";
  final String profession = "Enseignant supérieur";
  final String state = "Professeur d'informatique à l\'Ecole Nationale Des Sciences Appliquées Agadir";


  @override
  void initState() {
    super.initState();
    getNbs();
  }

  getNbs() {
    dbHelper.getCountPromo().then((value) {
      setState(() {
        this.nbClasses = value;
      });
    });

    dbHelper.getCountEtudiant().then((value) {
      setState(() {
        this.nbEtudiant = value;
      });
    });

    dbHelper.getCountCour().then((value) {
      setState(() {
        this.nbCours = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold (
        appBar: AppBar(
          title: Text('Mon Compte', style: TextStyle(color: Colors.white),),
          elevation: 0,
          backgroundColor: Color(0xFF650c8e),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          ),
        body: Stack(
          children: <Widget>[
            coverImage(context),
            Center(
              child: Padding(
                padding:  EdgeInsets.only(top: heightScreen*0.224),
                child: Column(
                  children: <Widget>[
                    profilePic(context),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(fullName, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold,),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(profession, style: TextStyle(color: Colors.black87, fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),),
                    ),
                    statusContainer(context),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(state, textAlign: TextAlign.center,style: TextStyle(color: Colors.black38, fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  // ------------------------------------------- //

  Widget coverImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.328,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
        ),
        image: DecorationImage(
          image: AssetImage(coverPath),
          fit: BoxFit.cover,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xffED3C63),
            offset: Offset(1.0, 1.0),
            blurRadius: 3.0,
          ),
        ],
      ),
    );
  }

  Widget profilePic(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.375,
      height: MediaQuery.of(context).size.width * 0.375,
      decoration: BoxDecoration(
          color: Color(0xffe9bffc),
          image: DecorationImage(
              image: AssetImage(profilePath),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(80),
          border: Border.all(
              color: Colors.white,
              width: 6
          )
      ),
    );
  }

  Widget status(String number, String chaine) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(number, style: TextStyle(color: Color(0xffED3C63), fontSize: 24, fontWeight: FontWeight.bold),),
        Text(chaine, style: TextStyle(color: Color(0xffED3C63), fontSize: 16, fontWeight: FontWeight.w300),)
        //color: Colors.black54
      ],
    );
  }

  Widget statusContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.14,
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(233, 191, 252, 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          status('$nbClasses','Classes'),
          status('$nbCours','Cours'),
          status('$nbEtudiant','Etudiants'),
        ],
      ),
    );
  }
}
