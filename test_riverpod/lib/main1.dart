import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StreamProvider that emits integers
final counterStreamProvider = StreamProvider<int>((ref) {
  // Simulated stream that emits integers every second
  return Stream<int>.periodic(Duration(seconds: 1), (count) => count);
});

// Provider that watches the counterStreamProvider
final counterProvider = Provider<int>((ref) {
  // Using watch to access the value emitted by counterStreamProvider
  final asyncValue = ref.watch(counterStreamProvider);

  // Using asyncValue.when to handle different states
  return asyncValue.when(
    data: (data) {
      // Return the data from the stream
      return data;
    },
    loading: () {
      // Return a default value or handle loading state
      return 0;
    },
    error: (error, stackTrace) {
      // Handle error state
      throw error;
    },
  );
});

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riverpod StreamProvider Example'),
        ),
        body: Center(
          child: Consumer(builder: (context, watch, child) {
            // Access the counterProvider to get the value from the stream
            final counter = ref.watch(counterProvider);
            return Text(
              'Counter: $counter',
              style: TextStyle(fontSize: 24),
            );
          }),
        ),
      ),
    );
  }
}
