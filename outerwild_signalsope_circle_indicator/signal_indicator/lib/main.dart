import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: BezierCurvePage()));
}

class BezierCurvePage extends StatefulWidget {
  const BezierCurvePage({Key? key}) : super(key: key);

  @override
  State<BezierCurvePage> createState() => _BezierCurvePageState();
}

class _BezierCurvePageState extends State<BezierCurvePage> {
  double arcCtlFactor = .3;
  var myValue = .1;
  Key myKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _animate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('test')),
        body: Stack(
          children: [
            Container(
              color: Colors.amber,
            ),
            CustomPaint(
              painter: SigalCircleIndicator(myKey, arcCtlFactor),
              child: Container(),
            ),
            CustomPaint(
              painter: SigalCircleIndicator(myKey, 1 - arcCtlFactor),
              child: Container(),
            ),
            CustomPaint(
              painter:
                  SigalCircleIndicator(myKey, (1 + sin(pi * arcCtlFactor)) / 2),
              child: Container(),
            ),
            CustomPaint(
              painter:
                  SigalCircleIndicator(myKey, 1 / (1 + exp(-arcCtlFactor))),
              child: Container(),
            ),
            CustomPaint(
              painter: SigalCircleIndicator(myKey, arcCtlFactor / 2),
              child: Container(),
            ),
          ],
        ),
        floatingActionButton:
            ElevatedButton(child: Text("add"), onPressed: _animate));
  }

  void _animate() {
    Future.delayed(Duration(milliseconds: 50)).then((value) {
      if (arcCtlFactor >= 1) {
        arcCtlFactor = 1;
        myValue = -.01;
      }
      if (arcCtlFactor <= 0) {
        arcCtlFactor = 0;
        myValue = .01;
      }
      arcCtlFactor += myValue;
      setState(() {});
      _animate();
    });
  }
}

/// 二次曲线
class SigalCircleIndicator extends CustomPainter {
  SigalCircleIndicator(this.key, this.arcCtlFactor);
  Key key;
  //弧与画布中心的距离 与 画布宽度一半的比例，范围0~1;
  double arcCtlFactor;

//TODO 弧长度的一半占画布高度的比例，TODO反映代表星球与玩家的距离，但有最小值，由外部传入？
//最大值跟画布大小有关
  var arkLengthFactor = 0.1;

  @override
  void paint(Canvas canvas, Size size) {
    var arkLegth = size.height * arkLengthFactor; // TODO 横竖屏问题
    // 将整个画布的颜色涂成白色
    Paint paint = Paint()..color = Colors.transparent;
    canvas.drawPaint(paint);
    // left part
    final halfarcCtlFactor = arcCtlFactor / 2;
    Path leftPath = Path()
      ..moveTo(size.width * halfarcCtlFactor,
          size.height / 2 - arkLegth) //移动起点到(0, size.height)
      ..arcToPoint(
          Offset(size.width * halfarcCtlFactor, size.height / 2 + arkLegth),
          radius: Radius.elliptical(arcCtlFactor, 1),
          clockwise: false);

    //right part
    Path rightPart = Path()
      ..moveTo(size.width * (1 - halfarcCtlFactor),
          size.height / 2 - arkLegth) //移动起点到(0, size.height)
      ..arcToPoint(
          Offset(
              size.width * (1 - halfarcCtlFactor), size.height / 2 + arkLegth),
          radius: Radius.elliptical(arcCtlFactor, 1),
          clockwise: true);

    final bezierPaint = Paint()
      // 添加渐变色
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawPath(leftPath, bezierPaint);
    canvas.drawPath(rightPart, bezierPaint);
  }

//TODO 太多setState？用riverpod控制，屏幕外的不更新
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
