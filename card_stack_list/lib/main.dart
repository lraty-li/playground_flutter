import 'package:card_stack_view_test/detail_page.dart';
import 'package:card_stack_view_test/heroParam.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'clipped_container.dart';

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
  static const _minHeight = 0.0;
  static const _maxHeight = 150.0;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: _colors
            .map(
              (color) => StackedListChild(
                  key: Key('${math.Random().nextInt(10000)}'),
                  minHeight: _minHeight,
                  maxHeight: _colors.indexOf(color) == _colors.length - 1
                      ? MediaQuery.of(context).size.height
                      : _maxHeight,
                  pinned: true,
                  child: GestureDetector(
                      onTap: () {
                        var heroParam = HeroParam(tag: _colors.indexOf(color), color: color);
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
                      child: Hero(
                        tag: _colors.indexOf(color),
                        child: Container(
                          color: _colors.indexOf(color) == 0
                              ? Colors.black
                              : _colors[_colors.indexOf(color) - 1],
                          child: Clipped(
                            child: Container(
                              decoration: BoxDecoration(
                                
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100)),
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      ))),
            )
            .toList(),
      );
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
    return Container(child: child);
  }

  @override
  bool shouldRebuild(_StackedListDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
