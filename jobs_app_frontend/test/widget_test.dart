import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobs_app_frontend/main.dart';

void main() {
  testWidgets('Shows onboarding/auth on launch', (WidgetTester tester) async {
    await tester.pumpWidget(const BlueCollarConnectApp());

    expect(find.text('Welcome to Blue Collar Connect!'), findsOneWidget);
    expect(find.byIcon(Icons.login), findsOneWidget);
    expect(find.text('Sign In / Register'), findsOneWidget);
  });

  testWidgets('App bar shows "Welcome" on onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const BlueCollarConnectApp());

    expect(find.text('Welcome'), findsOneWidget);
  });
}
