import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_riverpod/hello.dart';
import 'package:test_riverpod/mini3d.dart';
import 'package:test_riverpod/stream.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print("build");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: StreamExample(),
        ),
        floatingActionButton: ElevatedButton(
          child: const Text(
            "update",
            style: TextStyle(fontSize: 12),
          ),
          onPressed: () {
            //ref.read(helloWordProvider.notifier).update();
            // ref.read(exampleProvider.notifier).updateLastName();
            // ref.read(sensorDataProvider.notifier).getValue();
            // ref.read(pageIndexProvider.notifier).plus1();
            // ref.read(isinitProvider.notifier).beTrue();
          },
        ),
      ),
    );
  }
}

// class ConsumerExample extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     print("example build");
//     // Instead of writing:
//     // User aaa = ref.watch(exampleProvider);
//     // We can write:
//     String name = ref.watch(exampleProvider.select((it) => it.firstName));

//     // This will cause the widget to only listen to changes on "firstName".

//     return Text('Hello $name');
//   }
// }

class StreamExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("StreamExample build");
    ref.read(mini3dProvider.notifier).init(100);
    final sceneReady = ref.watch(mini3dProvider);
    return sceneReady
        ? SizedBox(
            width: ref.watch(mini3dProvider.notifier).width,
            height: ref.watch(mini3dProvider.notifier).width,
            child: Text('sceneReady '),
          )
        : const CircularProgressIndicator();

    return Container();
  }
}
