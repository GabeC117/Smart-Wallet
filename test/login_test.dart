import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_wallet/main.dart';

void main() {
  testWidgets('Successful login navigates to home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Tap on the login button with correct credentials
    await tester.enterText(find.byType(TextField).first, 'user');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that we have navigated to the home page
    expect(find.text('Welcome to the App!'), findsOneWidget);
  });

  testWidgets('Unsuccessful login shows error message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Tap on the login button with incorrect credentials
    await tester.enterText(find.byType(TextField).first, 'invalidUser');
    await tester.enterText(find.byType(TextField).last, 'invalidPassword');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that an error message is displayed
    expect(find.text('Login Failed'), findsOneWidget);
    expect(find.text('Invalid username or password.'), findsOneWidget);
  });
}
