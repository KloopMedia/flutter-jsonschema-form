import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:flutter_test/flutter_test.dart';

class ImageRobot {
  final WidgetTester tester;

  ImageRobot(this.tester);

  Future<void> clickImage() async {
    final image = find.byType(DecoratedImage).first;

    await tester.tap(image);

    await tester.pumpAndSettle();
  }

  Future<void> exitDetailPage() async {
    final backButton = find.byType(BackButton);

    await tester.tap(backButton);

    await tester.pumpAndSettle();
  }

  Future<void> tapOnChip(Finder chip) async {
    await tester.tap(chip);

    await tester.pumpAndSettle();
  }
}
