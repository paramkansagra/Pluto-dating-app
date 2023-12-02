import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ToolTip extends StatefulWidget {
  const ToolTip({super.key});

  @override
  State<ToolTip> createState() => _ToolTipState();
}

class _ToolTipState extends State<ToolTip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Toll Tip"),
        centerTitle: true,
      ),
      body: const Center(
        child: Tooltip(
          decoration: ShapeDecoration(
            color: Colors.black,
            shape: TooltipShapeBorder(arrowArc: 0.5),
            shadows: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
            ],
          ),
          message: "CSK vs GT and GT wins",
          preferBelow: false,
          verticalOffset: 50,
          showDuration: Duration(days: 1),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: CachedNetworkImageProvider(
              'https://wallpapercave.com/wp/AYWg3iu.jpg',
            ),
          ),
        ),
      ),
    );
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  const TooltipShapeBorder({
    this.radius = 20.0,
    this.arrowWidth = 8.0,
    this.arrowHeight = 8.0,
    this.arrowArc = 1.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..addOval(Rect.fromCircle(
          center: Offset(rect.center.dx - 20, rect.bottom), radius: 8))
      ..addOval(Rect.fromCircle(
          center: Offset(rect.center.dx - 10, rect.bottom + 16), radius: 4));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
