import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/history.dart';

Future<bool> saveFile({fileType,fileName, bytes}) async{
  Directory directory;
  String finalPath = "";

  if(fileName == null || fileType == null) {
    return false;
  }
  try{
    if(Platform.isAndroid){
      if (await _requestPermission(Permission.storage)) {
        directory = (await getExternalStorageDirectory())!;

        finalPath = directory.path;
      }
      // print("came");
      // print(finalPath);
      switch (fileType) {
        case "image":
          finalPath = "$finalPath/ShareKaro/Images";
          break;
        case "video":
          finalPath = "$finalPath/ShareKaro/Video";
          break;
        case "doc":
          finalPath = "$finalPath/ShareKaro/Documents";
          break;
      }
      directory = Directory(finalPath);
      // print(directory);
      // print("came");
      if(!await directory.exists()){
        // print("Creating........");
        await directory.create(recursive: true);
      }
      File file = File("${directory.path}/$fileName");
      // print("File path");
      // print(file.path);
      final res = await file.writeAsBytes(bytes, mode:FileMode.writeOnlyAppend);
      print("# Completed #");

      historyModels.add(HistoryModel(name: fileName, dateTime: DateTime.now(), type: fileType, path: finalPath));

      return true;
    }
  }catch(err){print(err.toString());
  }
  return false;
}
Future<bool> _requestPermission(Permission permission) async{
    if (await permission.isGranted) {
      print("Permission granted");
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
}