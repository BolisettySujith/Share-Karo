import 'tcpServer.dart';

class TCPImplementation{
  TCPServer? tcp;
  final int port;
  TCPImplementation({required this.port}){
    tcp = TCPServer(port: port);
  }
  void startServer(bloc, rescS) async {
    tcp?.startServer(bloc, rescS);
  }
}