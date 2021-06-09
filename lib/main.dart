import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('gauge_custom_paint')),
      body: SafeArea(
        minimum: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('0'),
                ),
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    child: CustomPaint(
                      painter: CustomGaugePainter(
                        percentageApproval: 70,
                        percentageReached: 75,
                      ),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          softWrap: true,
                          text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 24,
                              ),
                              text: '7,0 \n',
                              children: <TextSpan>[
                                TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  text: 'Period Note',
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text('10'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomGaugePainter extends CustomPainter {
  final double percentageApproval;
  final double percentageReached;

  CustomGaugePainter({
    @required this.percentageApproval,
    @required this.percentageReached,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double starAngle = pi * -1.2;
    double sweepAngle = pi * 1.4;

    final Offset center = new Offset(size.width / 2, size.height / 2);

    Color colorGreen = Color(0xFF51A231);

    // Approval
    final double radiusApproval = min(size.width / 1.7, size.height / 1.7);

    var paintApproval = new Paint()
      ..color = colorGreen
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double approvalAngle = sweepAngle * (percentageApproval / 100);

    canvas.drawArc(
      new Rect.fromCircle(center: center, radius: radiusApproval),
      starAngle,
      approvalAngle,
      false,
      paintApproval,
    );

    // Point
    var dx = center.dx + radiusApproval * cos(-pi / 2 + approvalAngle + 4.15);
    var dy = center.dy + radiusApproval * sin(pi / 2 + approvalAngle + 1.0);

    final offset = Offset(dx, dy);

    canvas.drawCircle(
      offset,
      2.5,
      Paint()
        ..strokeWidth = 5
        ..color = colorGreen
        ..style = PaintingStyle.fill,
    );

    // Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Approval',
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    textPainter.paint(canvas, Offset(dx + 10, dy - 10));

    // Full semicircle
    double radius = min(size.width / 2, size.height / 2);

    Paint paint = new Paint()
      ..color = Color(0xFFE9E9E9)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
        starAngle, sweepAngle, false, paint);

    // Inner semicircle
    paint.color = colorGreen;

    double noteAngle = sweepAngle * (percentageReached / 100);

    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
        starAngle, noteAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
