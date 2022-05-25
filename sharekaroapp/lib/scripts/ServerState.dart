import 'dart:async';

// abstract class will act as event listener
abstract class ServerStatusEvent{}

// given given classes act as events
class ConnectedStatus extends ServerStatusEvent{}
class DisconnectedSatus extends ServerStatusEvent{}

class ServerStatusBloc{
  bool status = false;
  final _serverStatus_StreamController = StreamController<bool>.broadcast();
  Sink<bool> get _serverstatusIn => _serverStatus_StreamController.sink;
  Stream<bool> get serverstatus => _serverStatus_StreamController.stream;

  final _serverStatus_Join = StreamController<String>.broadcast();
  Sink<String> get serverStatusJoinIn => _serverStatus_Join.sink;
  Stream<String> get serverStatusJoin => _serverStatus_Join.stream;

  final _serverStatus_eventListener = StreamController<ServerStatusEvent>();
  Sink<ServerStatusEvent> get serverStatusEvent => _serverStatus_eventListener.sink;

  ServerStatusBloc(){
    _serverStatus_eventListener.stream.listen((event){
      if (event.runtimeType == ConnectedStatus){
        status = true;
      }else{
        status = false;
      }
      _serverstatusIn.add(status);
    });
  }

  void dispose(){
    _serverStatus_Join.close();
  }
}