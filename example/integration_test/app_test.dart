import 'package:example/main.dart';
import 'package:example/schema/schema.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/flutter_json_schema_form.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'robots/image_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('testing image widget', () {
    // Load app widget.
    final app = MyApp(
      schema: ImageSchema(),
    );

    getFormData(WidgetTester tester) {
      return tester.state<MyAppState>(find.byType(MyApp)).formData;
    }

    testWidgets('render image widget', (tester) async {
      await tester.pumpWidget(app);

      // Verify that all options were rendered.
      expect(find.text('One'), findsOneWidget);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);
      expect(find.byKey(const Key('image_text')), findsOneWidget);
    });

    testWidgets('tap chip', (tester) async {
      final ImageRobot imageRobot = ImageRobot(tester);

      await tester.pumpWidget(app);

      final Finder chipOne = find.widgetWithText(DecoratedChip, 'One');

      expect(chipOne, findsOneWidget);

      await imageRobot.tapOnChip(chipOne);
      final widgetOne = tester.widget<DecoratedChip>(chipOne);
      expect(widgetOne.selected, true);
      expect(getFormData(tester)['image_widget_test'], 1);

      final Finder chipTwo = find.widgetWithText(DecoratedChip, 'Two');
      await imageRobot.tapOnChip(chipTwo);
      final widgetTwo = tester.widget<DecoratedChip>(chipTwo);

      expect(widgetTwo.selected, true);
      expect(getFormData(tester)['image_widget_test'], 2);
    });

    testWidgets('tap image', (tester) async {
      final ImageRobot imageRobot = ImageRobot(tester);

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      await imageRobot.clickImage();

      expect(find.byType(ImageDetailScreen), findsOneWidget);

      await imageRobot.exitDetailPage();

      expect(find.byType(MyApp), findsOneWidget);
    });
  });
}
