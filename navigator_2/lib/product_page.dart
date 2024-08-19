import 'package:flutter/material.dart';
import 'package:navigator_2/route.dart';
import 'dart:math' show Random;

class ProductPage extends StatelessWidget {
  final String path;
  const ProductPage({required this.path, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(path),
      ),
      body: Container(
        color: Colors.amber,
        child: ElevatedButton(
          child: Text(path),
          onPressed: () {
            MyRouterDelegate.of(context).push('${Random().nextInt(100)}');
          },
        ),
      ),
    );
  }
}
