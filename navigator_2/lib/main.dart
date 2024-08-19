import 'package:flutter/material.dart';
import 'package:navigator_2/route.dart';

void main(List<String> args) {
  runApp(Nvi2());
}

class Nvi2 extends StatefulWidget {
  const Nvi2({super.key});

  @override
  State<Nvi2> createState() => _Nvi2State();
}

class _Nvi2State extends State<Nvi2> {
  MyRouteParser _routeParser = MyRouteParser();
  MyRouterDelegate _routerDelegate = MyRouterDelegate();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeParser,
    );
  }
}
