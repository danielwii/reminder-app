import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum AsunaButtonType { elevated, outlined, block, close, icon }

class AsunaButton extends HookWidget {
  final AsunaButtonType type;
  final Widget child;
  final FutureOr Function()? onPressed;
  final bool? disabled;

  const AsunaButton({
    Key? key,
    this.type = AsunaButtonType.elevated,
    this.disabled,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  AsunaButton.close({Key? key, required this.onPressed})
      : type = AsunaButtonType.close,
        child = Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.7), shape: BoxShape.circle),
          alignment: Alignment.center,
          height: 22,
          width: 22,
          child: const Icon(Icons.close, size: 18, color: Colors.white),
        ),
        disabled = false,
        super(key: key);

  const AsunaButton.icon(
      {Key? key, required this.onPressed, required this.child})
      : type = AsunaButtonType.icon,
        disabled = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final calling = useState(false);
    final hasError = useState(false);
    fnOnPress() async {
      logger.info('onPress... ${calling.value}');
      if (calling.value) return;
      calling.value = true;
      hasError.value = false;
      await Future.microtask(() async {
        logger.info('call onPressed...');
        await onPressed!();
        hasError.value = false;
      }).catchError((e, s) {
        logger.warning('on press error $e $s');
        hasError.value = true;
      }).whenComplete(() {
        calling.value = false;
      });
    }

    final disable = calling.value || onPressed == null || disabled == true;

    if (type == AsunaButtonType.close) {
      return GestureDetector(onTap: onPressed, child: child);
    }
    if (type == AsunaButtonType.icon) {
      return GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: child,
        ),
      );
    }
    if (type == AsunaButtonType.block) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: disable ? null : fnOnPress,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (calling.value)
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const SpinKitFadingCircle(
                      color: Colors.pinkAccent, size: 20),
                ),
              child,
            ],
          ),
        ),
      );
    }
    if (type == AsunaButtonType.outlined) {
      return OutlinedButton(
        onPressed: disable ? null : fnOnPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (calling.value)
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: const SpinKitFadingCircle(
                  color: Colors.pinkAccent,
                  size: 20,
                ),
              ),
            child,
          ],
        ),
      );
    }
    return ElevatedButton(
      onPressed: disable ? null : fnOnPress,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (calling.value)
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const SpinKitFadingCircle(color: Colors.white, size: 20),
            ),
          child,
        ],
      ),
    );
  }
}
