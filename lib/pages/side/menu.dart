import 'dart:io';
import 'package:attendanceApp/pages/classes/classes.dart';
import 'package:attendanceApp/pages/cours/cours.dart';
import 'package:attendanceApp/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'menuItem.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xffED3C63), Color(0xFF650c8e), Color(0xFF650c8e)],
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight,
            )),
            child: Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Color(0xffe9bffc),
                          image: DecorationImage(
                              image: AssetImage('assets/images/prof.png'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.white, width: 3)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Ezzahir Redouane',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'r.ezzahir@uiz.ac.ma',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ),
          ),
          ListTile(
            title: MenuItem(Icons.person, 'Mon Compte'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
          Divider(
            height: 25,
            thickness: 0.5,
            color: Color(0xFF650c8e).withOpacity(0.5),
            indent: 30,
            endIndent: 30,
          ),
          ListTile(
            title: MenuItem(Icons.school, 'Classes'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClassesPage()));
            },
          ),
          ListTile(
            title: MenuItem(Icons.insert_drive_file, 'Cours'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CoursPage()));
            },
          ),
          Divider(
            height: 25,
            thickness: 0.5,
            color: Color(0xFF650c8e).withOpacity(0.5),
            indent: 30,
            endIndent: 30,
          ),
          ListTile(
            title: MenuItem(Icons.exit_to_app, 'Quitter'),
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }
}
