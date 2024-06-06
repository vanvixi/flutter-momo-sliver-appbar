import 'package:flutter/material.dart';

import 'balance_bar.dart';

const double _kRadius = 12;

class ActionAndOverviewInfoCard extends StatelessWidget {
  const ActionAndOverviewInfoCard({
    super.key,
    required this.contentPadding,
    required this.borderRadius,
  });

  final EdgeInsetsGeometry contentPadding;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CardPainter(),
      child: Padding(
        padding: contentPadding,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Top Up/Withdraw',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Collection QR',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Payment QR',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'My Pocket',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            BalanceBar(contentAlignment: Alignment.bottomCenter),
          ],
        ),
      ),
    );
  }
}

class _CardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    paintBalanceArea(canvas, size);
    paintBalanceShadow(canvas, size);
    paintFundsArea(canvas, size);
    paintDotLine(canvas, size);
    paintActionArea(canvas, size);
  }

  void paintBalanceArea(Canvas canvas, Size size) {
    final stopY = size.height;
    final halfX = size.width / 2;
    final startY = stopY - BalanceBar.height;

    final rect = Rect.fromLTWH(0, startY, halfX, BalanceBar.height);
    final Shader shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFAFAFA),
        Color(0xFFF4F4F4),
      ], // Colors of the gradient
    ).createShader(rect);

    final path = Path()
      ..moveTo(1, startY - _kRadius)
      ..quadraticBezierTo(0, startY, _kRadius, startY)
      ..lineTo(halfX - _kRadius, startY)
      ..quadraticBezierTo(halfX, startY, halfX + 5, startY + BalanceBar.height / 2)
      ..quadraticBezierTo(halfX + 10, stopY, halfX + BalanceBar.height / 2, stopY)
      ..lineTo(_kRadius, stopY)
      ..quadraticBezierTo(0, stopY, 0, stopY - _kRadius)
      ..close();

    final paint = Paint()..shader = shader;

    canvas.drawPath(path, paint);
  }

  void paintBalanceShadow(Canvas canvas, Size size) {
    final stopY = size.height;
    final halfX = (size.width / 2);
    final startY = stopY - BalanceBar.height;

    final path = Path()
      ..moveTo(2, startY - _kRadius)
      ..quadraticBezierTo(0, startY, _kRadius, startY)
      ..lineTo(halfX - _kRadius, startY)
      ..quadraticBezierTo(halfX, startY, halfX + 2, startY + BalanceBar.height / 2)
      ..quadraticBezierTo(halfX + 10, stopY, halfX + BalanceBar.height / 2, stopY)
      ..lineTo(halfX + BalanceBar.height / 2, startY - _kRadius)
      ..lineTo(0, startY - _kRadius)
      ..close();

    final shadowPaint = Paint()
      ..color = const Color(0xFFF0F0F0)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);

    const shadowOffset = Offset(1, 2);
    canvas.drawPath(path.shift(shadowOffset), shadowPaint);
  }

  void paintActionArea(Canvas canvas, Size size) {
    final stopX = size.width;
    final stopY = size.height - BalanceBar.height;

    final rrect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, stopX, stopY),
      topLeft: const Radius.circular(_kRadius),
      topRight: const Radius.circular(_kRadius),
      bottomLeft: const Radius.circular(_kRadius),
      bottomRight: Radius.zero,
    );
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, paint);
  }

  void paintFundsArea(Canvas canvas, Size size) {
    final stopX = size.width;
    final stopY = size.height;
    final startY = size.height - BalanceBar.height;
    final halfX = size.width / 2;

    final rect = Rect.fromLTWH(halfX, startY, halfX, BalanceBar.height);
    final Shader shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Color(0xFFFAFAFA),
      ], // Colors of the gradient
    ).createShader(rect);

    final paint = Paint()..shader = shader;

    final path = Path()
      ..moveTo(halfX - _kRadius, startY)
      ..quadraticBezierTo(halfX, startY, halfX + 5, startY + BalanceBar.height / 2)
      ..quadraticBezierTo(halfX + 10, stopY, halfX + 10 + _kRadius, stopY)
      ..lineTo(stopX - _kRadius, stopY)
      ..quadraticBezierTo(stopX, stopY, stopX, stopY - _kRadius)
      ..lineTo(stopX, startY)
      ..close();

    canvas.drawPath(path, paint);
  }

  void paintDotLine(Canvas canvas, Size size) {
    final stopX = size.width;
    final startY = size.height - BalanceBar.height;
    final halfX = size.width / 2;
    const double dashWidth = 5, dashSpace = 3, dashPadding = 12;

    final paint = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    double startX = halfX + dashPadding;

    while (startX < stopX - dashPadding) {
      path.moveTo(startX, startY);
      path.lineTo(startX + dashWidth, startY);
      startX += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
