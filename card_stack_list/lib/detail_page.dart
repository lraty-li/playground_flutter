import 'package:card_stack_view_test/heroParam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DeTailPage extends StatelessWidget {
  const DeTailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  var heroParam = ModalRoute.of(context)!.settings.arguments;
  heroParam as HeroParam;
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 39, 29, 29),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Hero(tag: heroParam.tag, child: Card(
            child: Expanded(
              child: Container(
                color: heroParam.color,
              ),
            ),)),
        ),
      ),
    );
  }
}
