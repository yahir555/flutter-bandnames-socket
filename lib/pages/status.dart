import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Getting the instance of the SocketService from Provider
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the server status (Online, Offline, or Connecting)
            Text('ServerStatus: ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          // Emit the message event to the server when button is pressed
        socketService.emit('emitir-mensaje', {
          'nombre': 'Flutter',
          'mensaje': 'Hola desde Flutter'
        });
        },
      ),
    );
  }
}

