import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'stream.g.dart';

final sensorStreamProvider = StreamProvider<List<double>>((ref) async* {
  ref.onDispose(() {
    print("sensorStreamProvider dispose");
  });
  double counter = 0;
  while (true) {
    counter++;
    yield [counter, counter + 1, counter + 2, counter + 3];
    // yield List.generate(4, (index) => counter + index);
    print("sensorStreamProvider yield");
    await Future.delayed(const Duration(seconds: 1));
  }
});
