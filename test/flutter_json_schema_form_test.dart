// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:flutter_json_schema_form/src/helpers/input_decoration.dart';
// import 'package:flutter_json_schema_form/src/widgets/image_viewer_widget/image_field.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
//
// class MyApp extends StatelessWidget {
//   final Widget child;
//
//   const MyApp({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     const title = 'Long List';
//
//     return MaterialApp(
//       title: title,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text(title),
//         ),
//         body: child,
//       ),
//     );
//   }
// }
//
// void main() {
//   testWidgets('render image widget', (tester) async {
//     const widget = ImageField(
//       name: 'test',
//       decoration: decoration,
//       initialValue: null,
//       images: [],
//       onChanged: () {},
//       options: [
//         FormBuilderFieldOption(value: 1, child: Text('One')),
//         FormBuilderFieldOption(value: 2, child: Text('Two')),
//         FormBuilderFieldOption(value: 3, child: Text('Three')),
//       ],
//     );
//
//     // Load app widget.
//     await tester.pumpWidget(const MyApp(child: widget));
//
//     await tester.pumpAndSettle();
//
//     // Verify that all options were rendered.
//     expect(find.text('One'), findsOneWidget);
//     expect(find.text('Two'), findsOneWidget);
//     expect(find.text('Three'), findsOneWidget);
//
//     final Finder chipOne = find.byKey(const ValueKey('image_chip_0'));
//     final Finder chipTwo = find.byKey(const ValueKey('image_chip_1'));
//     final Finder chipThree = find.byKey(const ValueKey('image_chip_2'));
//
//
//     expect(chipOne, findsOneWidget);
//
//
//     await tester.tap(chipOne);
//
//     await tester.pumpAndSettle();
//
//     final widgetOne = tester.widget<ChoiceChip>(chipOne);
//     final widgetTwo = tester.widget<ChoiceChip>(chipTwo);
//     final widgetThree = tester.widget<ChoiceChip>(chipThree);
//
//     expect(widgetOne.selected,  true);
//     expect(widgetTwo.selected, false);
//     expect(widgetThree.selected, false);
//
//     await tester.tap(chipTwo);
//     await tester.pumpAndSettle();
//
//     expect(widgetOne.selected,  false);
//     expect(widgetTwo.selected, true);
//     expect(widgetThree.selected, false);
//   });
// }
