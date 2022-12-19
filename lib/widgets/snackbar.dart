import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

Future<bool> showSnackBar(
  dynamic context, {
  required String message,
  int duration = 3,
  VoidCallback? onCompleted,
  FutureOr Function()? onUndo,
}) async {
  final completer = Completer<bool>();
  ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          onVisible: () {
            logger.info('snackbar is visible');
          },
          content: Row(mainAxisSize: MainAxisSize.min, children: [
            PlayAnimationBuilder<double>(
                tween: Tween(begin: 0, end: duration * 10),
                duration: Duration(seconds: duration),
                builder: (context, value, _) => CircularStepProgressIndicator(
                    totalSteps: duration * 10,
                    currentStep: value.toInt(),
                    width: 20,
                    height: 20,
                    stepSize: 2,
                    selectedStepSize: 2,
                    roundedCap: (_, isSelected) => isSelected,
                    selectedColor: Colors.amberAccent,
                    unselectedColor: Colors.grey,
                    child: Center(child: Text('${duration - value ~/ 10}'))),
                onCompleted: onCompleted),
            const SizedBox(width: 12),
            Text(message),
          ]),
          duration: const Duration(seconds: 3),
          action: onUndo != null
              ? SnackBarAction(
                  label: 'UNDO',
                  onPressed: () async {
                    await onUndo();
                    completer.complete(false);
                  })
              : null,
        ),
      )
      .closed
      .then((value) {
    logger.info('snackbar is closed $value');
    if (value != SnackBarClosedReason.action) {
      completer.complete(true);
      // onCompleted?.call();
    }
  });
  return completer.future;
}
