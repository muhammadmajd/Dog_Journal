// test/core/utils/size_config_test.dart
import 'package:dog/core/utils/size_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';


void main() {
  testWidgets('SizeConfig initializes correctly', (WidgetTester tester) async {
    final testWidget = MediaQuery(
      data: const MediaQueryData(size: Size(400, 800)),
      child: Builder(
        builder: (context) {
          SizeConfig.init(context);
          expect(SizeConfig.screenWidth, 400);
          expect(SizeConfig.screenHeight, 800);
          expect(SizeConfig.blockSizeHorizontal, 4.0); // 400/100
          expect(SizeConfig.blockSizeVertical, 8.0);   // 800/100
          return Container();
        },
      ),
    );

    await tester.pumpWidget(testWidget);
  });

  testWidgets('SizeConfig calculates safe areas correctly', (tester) async {
    final testWidget = MediaQuery(
      data: const MediaQueryData(
        size: Size(400, 800),
        padding: EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      ),
      child: Builder(
        builder: (context) {
          SizeConfig.init(context);

          expect(SizeConfig.safeBlockHorizontal, (400-40)/100); // 3.6
          expect(SizeConfig.safeBlockVertical, (800-80)/100);   // 7.2
          return Container();
        },
      ),
    );

    await tester.pumpWidget(testWidget);
  });
}