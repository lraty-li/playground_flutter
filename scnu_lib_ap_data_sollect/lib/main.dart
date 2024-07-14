import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:wifi_scan/wifi_scan.dart';

late final Directory? appExternStorage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

Future<void> init() async {
  await handleFolder();
  await requestPermissions();
}

Future<void> handleFolder() async {
  await getDownloadsDirectory().then((value) {
    final Directory? externalStorageDirectory = value;
    if (externalStorageDirectory?.path != null) {
      Directory appExterSto = Directory(
          '${externalStorageDirectory!.path}${Platform.pathSeparator}SCNU_Libray_AP_Data');
      if (!appExterSto.existsSync()) {
        appExterSto.create();
      }
      appExternStorage = appExterSto;
    }
  });
}

Future<void> requestPermissions() async {
  //TODO check if wifi and location service opened with "network info plus"
  var status = await Permission.storage.status;
  if (status.isDenied) {
    // kai bai
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<WiFiAccessPoint> accessPoints = [];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

  List<Map<String, Map>> allAPdata = [];

  final TextEditingController _coodinateXTxtCtl =
      TextEditingController(text: '1');
  final TextEditingController _coodinateYTxtCtl =
      TextEditingController(text: '1');
  final TextEditingController _roundsTxtCtl = TextEditingController(text: '20');
  final TextEditingController _intervalTxtCtl =
      TextEditingController(text: '3');
  int rounds = 0;

  Future<void> huntWiFis() async {
    showToast('scan started');
    rounds = int.parse(_roundsTxtCtl.text);
    final int interval = int.parse(_intervalTxtCtl.text);
    for (; rounds > 0; rounds--) {
      setState(() {});
      bool startScanSuccess = await _startScan();
      if (startScanSuccess) {
        await Future.delayed(
            Duration(seconds: interval)); //intervals later to scan next time
        accessPoints = await _getScannedResults();
        allAPdata = _fillInData(accessPoints, allAPdata);

        if (rounds == 1) {
          String coodinateXTxt = _coodinateXTxtCtl.text; 
          String coodinateYTxt = _coodinateYTxtCtl.text; 
          Map<String, dynamic> output = {
            "coordinateX": coodinateXTxt,
            "coordinateY": coodinateYTxt,
            "data": allAPdata
          };
          String outputJson = jsonEncode(output);
          File outputJsonFile = File(
              '${appExternStorage!.path}${Platform.pathSeparator}${coodinateXTxt}_$coodinateYTxt.json');
          outputJsonFile.createSync();
          outputJsonFile.writeAsString(outputJson);
          allAPdata.clear();
        }
        //but getting result not delayed?
      }
    }

    showToast('scan finish');
    if (await Vibration.hasVibrator() != null) {
      Vibration.vibrate(); 
    }

    setState(() {});
    if (!mounted) return;
  }

  Future<bool> _startScan() async {
    final can = await WiFiScan.instance.canStartScan(askPermissions: true);
    switch (can) {
      case CanStartScan.yes:
        final isScanning = await WiFiScan.instance.startScan();
        return isScanning;
      default:
        return false;
    }
  }

  List<Map<String, Map>> _fillInData(List<WiFiAccessPoint> accessPoints,
      List<Map<String, Map<dynamic, dynamic>>> allAPdata) {
    Map<String, Map<String, dynamic>> apData = {};
    for (WiFiAccessPoint result in accessPoints) {
      // DEBUG
      // if (result.bssid.contains('60:0b:03:ef:3d:f1')) {
      // apData[result.bssid] = {"ssid:": result.ssid, "level": result.level};
      // }
      apData[result.bssid] = {"ssid": result.ssid, "level": result.level};
    }
    allAPdata.add(apData);
    return allAPdata;
  }

  Future<List<WiFiAccessPoint>> _getScannedResults() async {
    List<WiFiAccessPoint> accessPoints = [];
    final can =
        await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    switch (can) {
      case CanGetScannedResults.yes:
        accessPoints = await WiFiScan.instance.getScannedResults();
      default:
        {
          print("can't get result");
        }
    }
    return accessPoints;
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: const Text('WiFiHunter examplea app'),
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              TextField(
                  controller: _coodinateXTxtCtl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "coordinateX")),
              TextField(
                  controller: _coodinateYTxtCtl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "coordinateY")),
              TextField(
                  controller: _roundsTxtCtl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "rounds")),
              TextField(
                  controller: _intervalTxtCtl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "_interval")),
              Text('scanning on round:${rounds}')
            ])),
        // 虽然是采集数据用的，但是不是太马虎了一点
        //TODO why padding not workking
        floatingActionButton: Padding(
          padding: EdgeInsets.all(50),
          child: ElevatedButton(
              onPressed: () => huntWiFis(),
              child: const Text(
                'Hunt Networks',
              )),
        ),
      )),
    );
  }

  @override
  dispose() {
    super.dispose();
    subscription?.cancel();
  }
}
