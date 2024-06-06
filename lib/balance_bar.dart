import 'package:flutter/material.dart';

class BalanceBar extends StatelessWidget {
  const BalanceBar({
    super.key,
    this.decoration,
    this.contentAlignment,
    this.contentPadding
  });

  final Decoration? decoration;
  final AlignmentGeometry? contentAlignment;
  final EdgeInsetsGeometry? contentPadding;


  static const double height = 35;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: contentAlignment,
      padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 8),
      decoration: decoration,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.remove_red_eye_outlined, size: 16),
          SizedBox(width: 8),
          Text(
            '9.999VND',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          Spacer(),
          Text(
            'Funds',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 8),
          Icon(Icons.account_balance_rounded, size: 14),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios_rounded, size: 12),
        ],
      ),
    );
  }
}
