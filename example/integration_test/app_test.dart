import 'dart:convert';

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('render image widget', (tester) async {
    final schema = jsonDecode("""
    {
  "title": "A registration form",
  "description": "A simple form example.",
  "type": "object",
  "required": [],
  "properties": {
    "image_widget_test": {
      "type": "string",
      "title": "Test"
    }
  }
}
    """);

    final uiSchema = jsonDecode("""
    {"image_widget_test": {
    "ui:widget": "image"
  }}
    """);

    // Load app widget.
    await tester.pumpWidget(MyApp(schema: schema));

    await tester.pumpAndSettle();

    // Verify that all options were rendered.
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);

    final Finder chipOne = find.byKey(const ValueKey('image_chip_0'));
    final Finder chipTwo = find.byKey(const ValueKey('image_chip_1'));
    final Finder chipThree = find.byKey(const ValueKey('image_chip_2'));

    expect(chipOne, findsOneWidget);

    await tester.tap(chipOne);

    await tester.pumpAndSettle();

    final widgetOne = tester.widget<ChoiceChip>(chipOne);
    final widgetTwo = tester.widget<ChoiceChip>(chipTwo);
    final widgetThree = tester.widget<ChoiceChip>(chipThree);

    expect(widgetOne.selected, true);
    expect(widgetTwo.selected, false);
    expect(widgetThree.selected, false);

    await tester.tap(chipTwo);
    await tester.pumpAndSettle();

    expect(widgetOne.selected, false);
    expect(widgetTwo.selected, true);
    expect(widgetThree.selected, false);
  });
}
