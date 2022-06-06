import 'dart:convert';

class HistoryModel{
  HistoryModel({required this.name,required this.dateTime, required this.type, required this.path});
  String name;
  DateTime dateTime;
  String type;
  String path;

  void setType(String type){
    this.type = type;
  }
  void setName(String name){
    this.name = name;
  }
  void setPath(String path){
    this.path = path;
  }
  void setDateTime(DateTime dateTime){
    this.dateTime = dateTime;
  }

  get getName => name;
  get getDateTime => "${dateTime.day}/${dateTime.month}/${dateTime.year} - ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  get getType => type;
  get getPath => path;

}

List<HistoryModel> historyModels  = [
  HistoryModel(name: "file name", dateTime: DateTime.now(), type: "type", path: "/storage/emulated/0/Android/data/com.example.sharekaroapp/files"),

];