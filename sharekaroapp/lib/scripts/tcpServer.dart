import 'dart:convert';
import 'dart:io';
import '../scripts/ServerState.dart';
import '../scripts/receiveingState.dart';
import '../scripts/writeFiles.dart';
import '../models/history.dart';

class TCPServer {
  ServerSocket? socket;
  final int port;
  ServerStatusBloc? serverState;
  ReceivingState? recState;
  final fileTypes = ["image", "doc", "video"];

  TCPServer({required this.port});

  Future<ServerSocket> bindto(int port) async {
    // bind the socket server to an address and port
    return ServerSocket.bind(InternetAddress.anyIPv4, port);
  }

  get getInstance => socket;

  void  startServer(serverS, receS) async {
    BytesBuilder builder = BytesBuilder(copy: false);
    serverState = serverS;
    recState = receS;
    double? size;
    String? _filetype;
    String? _fileName;

    try{
      await bindto(port).then((server) {
        print("server started at ${server.address}");
        //listen for client connections to the server
        server.listen((client) {
          print('Connection from'' ${client.remoteAddress.address}:${client.remotePort}');
          //listen for events from the client
          client.listen((event) async {
            try{
              final text = ascii.decode(event);
              // print(text);
              if(text.contains("size") || text.contains("type")){
                // print("in $text");
                final obj = json.decode(text);
                // print(obj);
                size = obj['size'];
                _fileName = obj['fileName'];
                _filetype = obj['type'];
                // print(size);
                // print(_fileName);
                // print(_filetype);
                // print("came in before model");
                HistoryModel model = HistoryModel(dateTime: DateTime.now(), name: _fileName!, type: _filetype!, path: "/storage/emulated/0/Android/data/com.example.render/files");

                // print("came in after model");
                recState!.getJsonObjIn.add(model);
                client.write("START SENDING");
                // print("Done last");
            }}catch(exp){
              builder.add(event);
              print(builder.length/1024/1024);
              double perc = ((builder.length/1024/1024)/size!);
              recState!.getFileSizeIn.add(perc);
            }
          }, onError: (err) {
            print("::client closed::");
          }, 
          onDone: () {
            // print("came to saving done");
            saveFile(fileName: _fileName, fileType: _filetype, bytes: builder.takeBytes());
            builder.clear();
            client.close();
          });
        });
      });
    }catch(err){
      print(err);
      print("::server not created::");
    }
  }

  closeConnection() {
    socket!.close();
  }
}
