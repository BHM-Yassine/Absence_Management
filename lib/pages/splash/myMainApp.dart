import 'package:attendanceApp/pages/side/menu.dart';
import 'package:attendanceApp/database/dbAppHelper.dart';
import 'package:flutter/material.dart';


class MyMainApp extends StatefulWidget {
  @override
  _MyMainAppState createState() => _MyMainAppState();
}

class _MyMainAppState extends State<MyMainApp> {
  DbAppHelper dbHelper = DbAppHelper();

  @override
  void initState() {
    super.initState();
    dbHelper.deletDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          drawer: Container(
            child: Menu(),
            width: MediaQuery.of(context).size.width - 50,
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xFF650c8e),
            iconTheme: IconThemeData(
                color: Colors.white
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF650c8e), Color(0xFF650c8e),Color(0xffED3C63)],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                    )
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 45,
                            child: Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 80,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text('- Gestion d\'Absence -', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 18),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right:20, top: 10.0),
                            child: Text('Une application mobile développée par des élèves ingénieurs de l\'ENSA d\'Agadir.', textAlign: TextAlign.center,style: TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 110.0),
                      child: Text('© 2020 ENSA Agadir',style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 11)),
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
