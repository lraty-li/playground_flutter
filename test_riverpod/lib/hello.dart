import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_riverpod/main.dart';
import 'package:test_riverpod/stream.dart';

part 'hello.g.dart';

@riverpod
class PageIndex extends _$PageIndex {
  @override
  int build() {
    return 0;
  }

  void goToPreviousPage() {
    state = state - 1;
  }

  void plus1() {
    state = state + 1;
  }
}

@riverpod
class Isinit extends _$Isinit {
  @override
  bool build() {
    return false;
  }

  void beTrue() {
    state = true;
  }

  void beFalse() {
    state = false;
  }
}

class User {
  late String firstName, lastName;
}

@riverpod
class example extends _$example {
  User build() {
    ref.onDispose(() {
      print("example dispose");
    });
    ref.keepAlive();

    return User()
      ..firstName = 'John'
      ..lastName = 'Doe';
  }

  updateLastName() {
    initStream();
    // state = User()
    //   ..firstName = ''
    //   ..lastName = 'Doedwaawds';
  }

  initStream() {
    final rotationVector = ref.watch(sensorStreamProvider);
    rotationVector.when(
      loading: () {
        print("loading");
      },
      error: (error, stack) {
        print("err");
      },
      data: (rotationVector) {
        state = User()
          ..firstName = "${rotationVector[0]}"
          ..lastName = "${rotationVector[1]}";
        print("rotation event");
      },
    );
  }
}
