import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuItem(this.icon,this.title);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Color(0xFF650c8e), size: 30,),
        SizedBox(width: 20,),
        Text(title, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black87),)
      ],
    );
  }
}

/*
Expanded(
                child: Container(
                  color: Color(0xFF650c8e),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          //backgroundImage: AssetImage(profilePath),
                          child: Icon(Icons.perm_identity, color: Colors.white,),
                          radius: 40,
                        ),
                        title: Text('Yassine', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800),),
                        subtitle: Text('yassinebouhm@gmail.com', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),),
                      ),
                      Divider(
                        height: 50,
                        thickness: 0.5,
                        color: Colors.white70,
                        indent: 30,
                        endIndent: 30,
                      ),
                      MenuItem(Icons.home,'Accueil'),
                      MenuItem(Icons.person,'Mon Compte'),
                      Divider(
                        height: 50,
                        thickness: 0.5,
                        color: Colors.white70,
                        indent: 30,
                        endIndent: 30,
                      ),
                      MenuItem(Icons.school,'Classes'),
                      MenuItem(Icons.insert_drive_file,'Cours'),
                      Divider(
                        height: 50,
                        thickness: 0.5,
                        color: Colors.white70,
                        indent: 30,
                        endIndent: 30,
                      ),
                      MenuItem(Icons.settings,'Parametres'),
                      MenuItem(Icons.exit_to_app,'Quitter'),
                    ],
                  ),
                ),
              ),
 */