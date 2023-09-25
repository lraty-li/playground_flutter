import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage({Key? key, required this.erorMsg}) : super(key: key);
  String erorMsg;

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();

  Future<void> huntWiFis() async {
    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      print(exception.toString());
    }

    // for (var i = 0; i < wiFiHunterResult.results.length;) {
    //   print(wiFiHunterResult.results[i].ssid);
    //   print(wiFiHunterResult.results[i].bssid);
    //   print(wiFiHunterResult.results[i].level);
    // }
    print(wiFiHunterResult.results.length);

    setState(() {});
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('WiFiHunter examplea app'),
      ),
      body: Text(widget.erorMsg),
    ));
  }
}
