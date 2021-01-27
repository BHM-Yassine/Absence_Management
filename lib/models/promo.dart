class Promo{
  int id;
  String fileName;
  String filePath;

  Promo(this.fileName, this.filePath);
  Promo.withId(this.id,this.fileName, this.filePath);

 /* int get _id => id;
  String get _fileName => fileName;
  String get _filePath => filePath;

  set _id(int value) { id = value; }
  set _fileName(String value) { fileName = value; }
  set _filePath(String value) { filePath = value; }*/


  Map<String, dynamic> toMap() {
    var map = Map<String,dynamic>();

    map["id"] = this.id;
    map["fileName"] = this.fileName;
    map["filePath"] = this.filePath;
    return map;
  }

  Promo.getMap(Map<String,dynamic> map) {
    this.id = map["id"];
    this.fileName = map["fileName"] ;
    this.filePath = map["filePath"] ;
  }

}