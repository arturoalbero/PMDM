import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthys_app/ui/screens/login_form.dart';

void main() {
  testWidgets('Login form shows the expected actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoginForm())),
    );

    expect(find.text('Accedeix'), findsOneWidget);
    expect(find.text('Registra\'t'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
