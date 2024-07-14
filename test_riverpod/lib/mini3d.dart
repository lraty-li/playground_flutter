import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_riverpod/stream.dart';
part 'mini3d.g.dart';

@riverpod
final thrid = Provider.autoDispose<bool>((ref) {
  final sensorData = ref.watch(sensorStreamProvider);
  sensorData.whenData((value) {
    print("thrid");
    ref.watch(mini3dProvider.notifier).cameraDierection = value;
  });
  return false;
});

@riverpod
class Mini3d extends _$Mini3d {
  List<double> cameraDierection = [];
  late double width;
  bool isInit = false;
  // late final AsyncValue<List<double>>? sensorData;
  @override
  bool build() {
    print("mini3d build");
    ref.keepAlive();
    // sensorData = ref.watch(sensorStreamProvider);
    ref.onDispose(() {
      print("mini3d dispose");
    });
    return false;
  }

  init(double size) async {
    width = size;
    if (isInit == true) {
      return;
    }
    await Future.delayed(const Duration(seconds: 3));
    initSensor();
    state = true;
  }

  initSensor() {
    ref.listen(sensorStreamProvider, (previous, next) {
      next.whenData((value) {
        cameraDierection = value;
        print(cameraDierection);
      });
    });
    // final sensorData = ref.watch(sensorStreamProvider);
  }
}

class threeD {
  List<double> cameraDierection = [];
  late double width;
}

@riverpod
class threeDState extends _$threeDState {
  @override
  bool build() {
    ref.onDispose(() {
      print("threeDState dispose");
    });
    return false;
  }
}
