import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/socket_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/status.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': ( _ ) => HomePage(),
          'status': ( _ ) => StatusPage()
        },
      ),
    );
  }
}