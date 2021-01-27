class Absence {
  int id;
  String date;
  String observation;
  String justify;
  String promo;
  String cne;

  Absence(this.date, this.observation, this.justify, this.promo, this.cne);
  Absence.withId(this.id, this.date, this.observation, this.justify, this.promo, this.cne);

  Map<String, dynamic> toMap() {
    var map = Map<String,dynamic>();
    map["id"] = this.id;
    map["date"] = this.date;
    map["observation"] = this.observation;
    map["justify"] = this.justify;
    map["promo"] = this.promo;
    map["cne"] = this.cne;

    return map;
  }

  Absence.getMap(Map<String,dynamic> map) {
    this.id = map["id"];
    this.date = map["date"];
    this.observation = map["observation"];
    this.justify = map["justify"];
    this.promo = map["promo"];
    this.cne = map["cne"];
  }

}