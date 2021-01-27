class Etudiant {
  int id;
  String cne;
  String nom;
  String prenom;
  String filiere;

  Etudiant(this.cne, this.nom, this.prenom, this.filiere);
  Etudiant.withId(this.id, this.cne, this.nom, this.prenom, this.filiere);

  Map<String, dynamic> toMap() {
    var map = Map<String,dynamic>();
    map["id"] = this.id;
    map["cne"] = this.cne;
    map["nom"] = this.nom;
    map["prenom"] = this.prenom;
    map["filiere"] = this.filiere;
    return map;
  }

  Etudiant.getMap(Map<String,dynamic> map) {
    this.id = map["id"];
    this.cne = map["cne"];
    this.nom = map["nom"];
    this.prenom = map["prenom"];
    this.filiere = map["filiere"];
  }

}