class Cour{
  int id;
  String courName;
  String courPath;

  Cour(this.courName, this.courPath);
  Cour.withId(this.id, this.courName, this.courPath);

  Map<String, dynamic> toMap() {
    var map = Map<String,dynamic>();
    map["id"] = this.id;
    map["courName"] = this.courName;
    map["courPath"] = this.courPath;
    return map;
  }

  Cour.getMap(Map<String,dynamic> map) {
    this.id = map["id"];
    this.courName = map["courName"] ;
    this.courPath = map["courPath"] ;
  }

}