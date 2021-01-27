import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'myMainApp.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyMainApp() ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF650c8e),Color(0xffED3C63)],
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
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
                          backgroundColor: Colors.white,
                          radius: 45,
                          child: Icon(
                            Icons.school,
                            color: Color(0xffED3C63),
                            size: 50,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text('Gestion d\'Absence', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text('ENSA Agadir',style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 15)),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
