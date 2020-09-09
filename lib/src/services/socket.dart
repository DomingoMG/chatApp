import 'package:chatapp/src/global/enviroment.dart';
import 'package:chatapp/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  // La primera vez al hacer la conexión
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;
  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;
  
  Future<void> connect() async {
    
    final token = await AuthService.getToken();

    // Dart client
    this._socket = IO.io('${Environment.socketUrl}', {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token
      }
    });

    this._socket.on('connect', (_) {
     print('connect');
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      print('disconnect');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() => this._socket.disconnect();

  // Cierre de los escuchas
  void dispose(){

  }
}