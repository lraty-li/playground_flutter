import 'package:flutter/material.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class Clipped extends StatelessWidget {
  Widget child;
  Clipped({required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArcClipper(),
      child: child,
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var radius = 100.0;
    Path path = Path();

    path
      ..moveTo(0, size.height)
      ..arcToPoint(Offset( 100, 0),
          radius: Radius.circular(200), clockwise: true)
      ..lineTo(size.width / 2 - radius, 0,)
      ..arcToPoint(Offset(size.width / 2 + radius, 0),
          radius: Radius.circular(radius),
          //TODO wiki
          clockwise: false)
      ..lineTo(size.width, 0)

      ..lineTo(size.width, size.height)
      //DEBUG BEGIN
      ..lineTo(size.width /2, size.height + 100)
      //DEBUG END
      ..lineTo(0, size.height)
      ..close();

    // path
    // ..lineTo(size.width/2 - radius, 0)
    // ..arcToPoint(
    //   Offset(size.width/2 + radius, 0),
    //   radius: Radius.circular(radius) ,)
    // ..lineTo(size.width, 0)
    // ..lineTo(size.width, size.height)
    // ..lineTo(0, size.height);

    // path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}
