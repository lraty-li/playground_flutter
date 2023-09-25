import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scnu_lib_ap_data_sollect/error_page.dart';
import 'dart:async';

import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();

  Future<void> huntWiFis() async {
    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ErrorPage(erorMsg: exception.toString(),)),
      );
      // print(exception.toString());
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
      body: ListView.builder(
          itemCount: wiFiHunterResult.results.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                // leading: const Icon(Icons.list),
                trailing: Text(
                  wiFiHunterResult.results[index].level.toString(),
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                title: Text(wiFiHunterResult.results[index].ssid));
          }),
      floatingActionButton: ElevatedButton(
          onPressed: () => huntWiFis(), child: const Text('Hunt Networks')),
    ));
  }
}
