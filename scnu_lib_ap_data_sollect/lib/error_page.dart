import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';


class ErrorPage extends StatefulWidget {
  ErrorPage({Key? key, required this.erorMsg}) : super(key: key);
  String erorMsg;

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {

  Future<void> huntWiFis() async {

    setState(() {});
    // if (!mounted) return;
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
