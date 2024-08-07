import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    required this.document,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Title goes here'),
        ),
        body: Column(
          children: [
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: _abb(),
            )),
            Expanded(
                child: ListView(
              shrinkWrap: true,
              children: _abb(),
            ))
          ],
        ));
  }
}

_abb() {
  List<Widget> chils = [];
  for (var i = 0; i < 1000; i++) {
    chils.add(Center(
      child: Text("$i"),
    ));
  }
  return chils;
}
