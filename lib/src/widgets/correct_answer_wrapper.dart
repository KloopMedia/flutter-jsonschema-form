import 'package:flutter/material.dart';
import 'package:flutter_json_schema_form/l10n/loc.dart';

import '../helpers/helpers.dart';

class CorrectAnswerWrapper extends StatelessWidget {
  final bool? isCorrect;
  final Widget child;

  const CorrectAnswerWrapper({super.key, required this.isCorrect, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showCorrectContainerDecoration(isCorrect),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          ContainerExtension(isCorrect: isCorrect),
        ],
      ),
    );
  }
}

class ContainerExtension extends StatelessWidget {
  final bool? isCorrect;

  const ContainerExtension({super.key, this.isCorrect});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0);

    if (isCorrect == null) {
      return const SizedBox.shrink();
    } else if (isCorrect!) {
      return Padding(
        padding: padding,
        child: Row(
          children: [
            const Icon(Icons.check),
            const SizedBox(width: 10),
            Text(context.loc.answer_correct),
          ],
        ),
      );
    } else {
      return Padding(
        padding: padding,
        child: Row(
          children: [
            const Icon(Icons.close_rounded),
            const SizedBox(width: 10),
            Text(context.loc.answer_wrong)
          ],
        ),
      );
    }
  }
}
