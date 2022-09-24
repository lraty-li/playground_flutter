// ignore_for_file: unnecessary_new

import 'package:card_stack_view_test/detail_page.dart';
import 'package:card_stack_view_test/heroParam.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'clipped_container.dart';

//TODO
/*
* 两大难题
listview item 堆叠顺序
transform后， hittest
*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stacked list example',
      home: Scaffold(
          appBar: AppBar(
            title: Text("Stacked list example"),
            backgroundColor: Colors.black,
          ),
          body: StackedList()),
    );
  }
}

class StackedList extends StatelessWidget {
  final List<Color> _colors = Colors.primaries;
  //TODO  if allItemCount*_minHeight>= device height , will not able to scroll
  static const _minHeight = 20.0;
  static const _maxHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   itemCount: 10,
    //   itemBuilder: ((context, index) => Clipped(
    //     child: Container(
    //       transform: Matrix4.translationValues(0, -10.0 * index , 0),
    //       color: Colors.primaries[index],
    //       height: 100,
    //     ),
    //   )),
    // );
    return CustomScrollView(
      // reverse: true,
      slivers: _colors.map(
        (color) {
          return StackedListChild(
              key: Key('${math.Random().nextInt(10000)}'),
              minHeight: _minHeight,
              maxHeight: _colors.indexOf(color) == _colors.length - 1
                  ? _maxHeight
                  : _maxHeight,
              pinned: true,
              child: _buildChild(context, _colors.indexOf(color), _colors));
        },
      ).toList(),
    );
  }
}

class StackedListChild extends StatelessWidget {
  final double minHeight;
  final double maxHeight;
  final bool pinned;
  final bool floating;
  final Widget child;

  SliverPersistentHeaderDelegate get _delegate => _StackedListDelegate(
      minHeight: minHeight, maxHeight: maxHeight, child: child);

  const StackedListChild({
    required Key key,
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    this.pinned = false,
    this.floating = false,
  })  : assert(child != null),
        assert(minHeight != null),
        assert(maxHeight != null),
        assert(pinned != null),
        assert(floating != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
      key: key, pinned: pinned, floating: floating, delegate: _delegate);
}

class _StackedListDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StackedListDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // final String info = 'shrinkOffset:${shrinkOffset.toStringAsFixed(1)}'
    //     '\noverlapsContent:$overlapsContent';
    // return Container(
    //   alignment: Alignment.center,
    //   color: Colors.orangeAccent,
    //   child: Text(
    //     info,
    //     style: TextStyle(fontSize: 20, color: Colors.white),
    //   ),
    // );
    return Container(
      color: Colors.transparent,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StackedListDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Widget _buildChild(BuildContext context, int index, List<Color> colors) {
  var offsetTransform = Matrix4.translationValues(0, -30.0 * index, 0);
  return Container(
    //1 注意：父容器的宽高是200 减去pading后是180
    // padding: EdgeInsets.all(10),
    // height: 200,
    child: Clipped(
      child: OverflowBox(
        maxHeight: 600, //2 不能小于父容器的高度180
        child: GestureDetector(
          onTap: () {
            var heroParam = HeroParam(tag: index, color: colors[index]);
            Navigator.of(context).push(
              PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return DeTailPage();
                  },
                  fullscreenDialog: true,
                  settings: RouteSettings(arguments: heroParam)),
            );
            print('onTap');
          },
          child: Container(
            transform: offsetTransform,
            color: colors[index],
            // height: 600,
          ),
        ),
      ),
    ),
  );

  return Stack(
    children: [
      // Container(
      //   //TODO when offset bigger than device height, bad
      //   transform: offsetTransform,
      //   child: Hero(
      //     tag: _colors.indexOf(color),
      //     child: Clipped(
      //       child: Container(
      //         color: color,
      //       ),
      //     ),
      //   ),
      // ),
      Transform(
        transform: offsetTransform,
        child: GestureDetector(
            onTap: () {
              var heroParam = HeroParam(tag: index, color: colors[index]);
              Navigator.of(context).push(
                PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return DeTailPage();
                    },
                    fullscreenDialog: true,
                    settings: RouteSettings(arguments: heroParam)),
              );
              print('onTap');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
                color: colors[index],
              ),
            )),
      )
    ],
  );
}
