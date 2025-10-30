// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:grocery_manager/main.dart';

void main() {
  testWidgets('Grocery Manager App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GroceryManagerApp());

    // Verify that the app loads with the inventory tab
    expect(find.text('Mi Inventario'), findsOneWidget);
    expect(find.text('Tu inventario está vacío'), findsOneWidget);

    // Tap the floating action button specifically
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the dialog appears
    expect(find.text('Firebase Configurado'), findsOneWidget);
  });
}
