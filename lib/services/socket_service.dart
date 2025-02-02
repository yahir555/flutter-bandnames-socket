import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket; // Usar `late` para inicializar más tarde

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;
  
  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Configuración del cliente Socket.IO
    this._socket = IO.io('http://192.168.0.19:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Escucha el evento 'connect'
    this._socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    // Escucha el evento 'disconnect'
    this._socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // Manejo de errores de conexión
    this._socket.on('connect_error', (error) {
      print('Error de conexión: $error');
    });

  }
}
