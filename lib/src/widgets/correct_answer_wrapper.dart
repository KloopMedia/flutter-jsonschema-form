import 'package:flutter/material.dart';

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
      return const Padding(
        padding: padding,
        child: Row(
          children: [Icon(Icons.check), SizedBox(width: 10), Text('Correct')],
        ),
      );
    } else {
      return const Padding(
        padding: padding,
        child: Row(
          children: [Icon(Icons.close_rounded), SizedBox(width: 10), Text('Wrong')],
        ),
      );
    }
  }
}
