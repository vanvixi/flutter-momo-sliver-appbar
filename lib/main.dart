import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD82D8B),
          primary: const Color(0xFFD82D8B),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(foregroundColor: Colors.white),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(MediaQuery.paddingOf(context).top),
          ),
          SliverList.list(
            children: List<Widget>.generate(
              20,
              (int index) => Card(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  child: Text(index.toString()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  const SliverAppBarDelegate(this.safeAreaTop);

  final double safeAreaTop;

  @override
  double get minExtent => kToolbarHeight + safeAreaTop;

  @override
  double get maxExtent => 200;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => OverScrollHeaderStretchConfiguration();

  double get deltaExtent => maxExtent - minExtent;

  static const imgBgr = Image(image: AssetImage('assets/images/header_bgr.webp'), fit: BoxFit.cover);

  double transform(double begin, double end, double t, [double x = 1]) {
    return Tween<double>(begin: begin, end: end).transform(x == 1 ? t : min(1.0, t * x));
  }

  Color transformColor(Color? begin, Color? end, double t, [double x = 1]) {
    return ColorTween(begin: begin, end: end).transform(x == 1 ? t : min(1.0, t * x)) ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final currentExtent = max(minExtent, maxExtent - shrinkOffset);
        // 0.0 -> Expanded
        // 1.0 -> Collapsed
        double t = clampDouble(1.0 - (currentExtent - minExtent) / deltaExtent, 0, 1);

        final List<Widget> children = <Widget>[];

        // background
        final double fadeStart = max(0, 1.0 - kToolbarHeight / deltaExtent);
        const double fadeEnd = 1;
        assert(fadeStart <= fadeEnd, 'fadeStart > fadeEnd is not true');

        double height = maxExtent;

        // Background image
        if (constraints.maxHeight > height) height = constraints.maxHeight;
        children.add(Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: height - deltaExtent / 2,
          child: imgBgr,
        ));

        // Box
        const boxPaddingBottom = 16.0;
        const actionFloatTextStyle = TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          height: 1.1,
          fontSize: 14,
        );
        children
          ..add(Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: deltaExtent,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(horizontal: transform(16, 0, t, 2)),
              padding: const EdgeInsets.only(bottom: boxPaddingBottom),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(transform(8, 0, t, 2)),
              ),
              child: const DefaultTextStyle(
                style: actionFloatTextStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Nap/Rut',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Nhan tien',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'QR Thanh toan',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Vi tien ich',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))

          // Background image Clipped
          ..add(Positioned(
            top: 0,
            height: height - deltaExtent / 2,
            width: constraints.maxWidth,
            child: ClipRect(
              clipper: RectClipper(minExtent),
              child: imgBgr,
            ),
          ))

          // Splash transform color
          ..add(Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Container(
              height: currentExtent,
              width: constraints.maxWidth,
              color: transformColor(null, Colors.white, t, 3),
            ),
          ));

        // App bar
        const appBarPadding = SizedBox(width: 4);
        final appBarContentWidth = constraints.maxWidth - (appBarPadding.width! * 2);
        const totalIconImgButtonSize = IconImgButton.tapTargetSize * 7;
        final appBarSpace = SizedBox(width: (appBarContentWidth - totalIconImgButtonSize) / 6);

        //App bar fixed position
        Color iconBgrColor = transformColor(Colors.black26, null, t);
        children.add(Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: Container(
            height: minExtent,
            color: transformColor(null, const Color(0xff395241), t, 2),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  appBarPadding,
                  IconImgButton(
                    'search.webp',
                    backgroundColor: iconBgrColor,
                  ),
                  appBarSpace,
                  const Spacer(),
                  appBarSpace,
                  IconImgButton(
                    'notifications_bell.webp',
                    backgroundColor: iconBgrColor,
                  ),
                  appBarSpace,
                  IconImgButton(
                    'chat_comment.webp',
                    backgroundColor: iconBgrColor,
                  ),
                  appBarPadding,
                ],
              ),
            ),
          ),
        ));

        // App bar transform position
        iconBgrColor = transformColor(const Color(0xff395241), null, t);
        final iconSize = transform(48, 32, t);
        final iconPadding = transform(8, 4, t);

        children.add(Positioned(
          height: minExtent,
          left: transform(16, appBarPadding.width! + IconImgButton.tapTargetSize + appBarSpace.width!, t),
          right: transform(16, appBarPadding.width! + IconImgButton.tapTargetSize * 2 + appBarSpace.width! * 2, t),
          bottom: transform(boxPaddingBottom + actionFloatTextStyle.fontSize! * actionFloatTextStyle.height! * 2, 0, t),
          child: SafeArea(
            bottom: false,
            minimum: EdgeInsets.symmetric(horizontal: transform(16, 0, t)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconImgButton(
                  'momomain_money_in.webp',
                  size: iconSize,
                  padding: iconPadding,
                  backgroundRadius: 16,
                  backgroundColor: iconBgrColor,
                ),
                IconImgButton(
                  'momomain_withdraw.webp',
                  size: iconSize,
                  padding: iconPadding,
                  backgroundRadius: 16,
                  backgroundColor: iconBgrColor,
                ),
                IconImgButton(
                  'navigation_qrcode.webp',
                  size: iconSize,
                  padding: iconPadding,
                  backgroundRadius: 16,
                  backgroundColor: iconBgrColor,
                ),
                IconImgButton(
                  'home_wallet_inactive.webp',
                  size: iconSize,
                  padding: iconPadding,
                  backgroundRadius: 16,
                  backgroundColor: iconBgrColor,
                ),
              ],
            ),
          ),
        ));

        return Stack(children: children);
      },
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  final double maxHeight;

  RectClipper(this.maxHeight);

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, maxHeight);
    return rect;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}

class IconImgButton extends StatelessWidget {
  const IconImgButton(
    this.name, {
    super.key,
    this.size = 32,
    this.padding = 4,
    this.backgroundColor = Colors.black26,
    this.backgroundRadius,
  });

  final String name;
  final double size;
  final double padding;
  final Color? backgroundColor;
  final double? backgroundRadius;

  static const double tapTargetSize = kMinInteractiveDimension;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/$name'),
      padding: EdgeInsets.all(padding),
      constraints: BoxConstraints(maxWidth: size, maxHeight: size),
      style: IconButton.styleFrom(
        // Expands the minimum tap target size to 48px by 48px.
        tapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: backgroundColor,
        shape: backgroundRadius == null
            ? null
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(backgroundRadius!),
              ),
      ),
      onPressed: () {},
    );
  }
}
