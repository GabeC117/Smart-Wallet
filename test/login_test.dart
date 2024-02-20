import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_wallet/main.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('LoginPage UI Test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(),
      ));

      expect(find.byKey(const Key('login-btt')), findsOneWidget);
      expect(find.byKey(const Key('email-field')), findsOneWidget);
      expect(find.byKey(const Key('password-field')), findsOneWidget);
      expect(find.byKey(const Key('signup-btt')), findsOneWidget);
      expect(find.byKey(const Key('forgot-pass')), findsOneWidget);
    });
  });
}