import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chicken_sales_app/main.dart';

void main() {
  testWidgets('Sales app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SalesApp());

    expect(find.text('Chicken Sales Calculator'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
  });
}
