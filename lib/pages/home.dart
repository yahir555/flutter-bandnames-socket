import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:flutter_application_1/models/band.dart';
import 'package:flutter_application_1/services/socket_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {

    final socketService = Provider.of<SocketService>(context, listen: false); 

    socketService.socket.on('active-bands',  _handleActiveBands );
    super.initState();
  }

  _handleActiveBands( dynamic payload){
    
    this.bands = (payload as List)
      .map( (band) => Band.fromMap(band) )
      .toList();

    setState(() {});
  }

  @override
  void dispose() {
    
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context); 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
            ? Icon(Icons.check_circle, color: Colors.blue[300] )
            : Icon(Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: Column(
        children: <Widget> [
          
          _showGraph(),

          Expanded(
            child: ListView.builder(
                    itemCount: bands.length,
                    itemBuilder: (context, i) => _bandTile(bands[i]),
                    ),
          )
      ],
    ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.emit('delete-band', {'id': band.id }),
        background: Container(
        padding: EdgeInsets.only( left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle( color: Colors.white)),
        )
      ),
      child: ListTile(
      leading: CircleAvatar(
        child: Text(band.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      title: Text(band.name),
      trailing: Text(
        '${band.votes}',
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () => socketService.socket.emit('vote-band', { 'id' : band.id}),
    ), //ListTile
    );  //Dismissible
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      // Diálogo para Android
      showDialog(
        context: context,
        builder: ( _ ) => AlertDialog(
            title: const Text('New band name:'),
            content: TextField(
              controller: textController,
              autofocus: true,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  final name = textController.text.trim();
                  if (name.isNotEmpty) {
                    addBandToList(name);
                  }
                },
              ),
            ],
          )
      );
    } else {
      // Diálogo para iOS
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
            title: const Text('New band name:'),
            content: CupertinoTextField(
              controller: textController,
              autofocus: true,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add'),
                onPressed: () {
                  final name = textController.text.trim();
                  if (name.isNotEmpty) {
                    addBandToList(name);
                  }
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          )
      );
    }
  }

  void addBandToList(String name) {

    if( name.length >1 ){
       final socketService = Provider.of<SocketService>(context, listen: false);
       socketService.emit('add-band', { 'name': name});
    }
    
    Navigator.pop(context); 
  }



Widget _showGraph() {
  Map<String, double> dataMap = new Map();
  //'Flutter': 5
  bands.forEach((band){
    dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
  });

  final List<Color> colorList = [
    Colors.blue.shade50,
    Colors.blue.shade200,
    Colors.pink.shade50,
    Colors.pink.shade200,
    Colors.yellow.shade50,
    Colors.yellow.shade200,
  ];

  return SizedBox(
    width: double.infinity, 
    height: 200,
    child: PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      centerText: "HYBRID",
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle, // Se corrigió aquí
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
      // gradientList: ---To add gradient colors---
      // emptyColorGradient: ---Empty Color gradient---
    )
  );
  }

}
