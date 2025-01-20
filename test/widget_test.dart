import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pruebas/main.dart';

void main() {
  testWidgets('Login screen has email and password fields', (WidgetTester tester) async {
    // Build the login screen.
    await tester.pumpWidget(MyApp());

    // Check if email and password fields exist.
    expect(find.byType(TextField), findsNWidgets(2));

    // Check if the "Iniciar sesión" button exists.
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
