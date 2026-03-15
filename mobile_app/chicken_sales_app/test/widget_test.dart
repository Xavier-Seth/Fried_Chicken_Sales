import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chicken_sales_app/controllers/locale_controller.dart';
import 'package:chicken_sales_app/main.dart';

void main() {
  testWidgets('Sales app loads correctly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final localeController = await LocaleController.create();

    await tester.pumpWidget(SalesApp(localeController: localeController));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
