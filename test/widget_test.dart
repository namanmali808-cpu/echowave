import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echowave/app.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EchoWaveApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
