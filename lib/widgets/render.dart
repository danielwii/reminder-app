import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsunaListRender extends HookWidget {
  final bool isLoading;
  final bool hasError;
  final bool isEmpty;
  final FutureOr Function() onRefresh;
  final Widget Function() render;

  const AsunaListRender(
      {Key? key,
      required this.isLoading,
      required this.hasError,
      required this.isEmpty,
      required this.render,
      required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    useLogger('<[AsunaListRender]>', props: {
      'isLoading': isLoading,
      'hasError': hasError,
      'isEmpty': isEmpty,
    });

    return isLoading
        ? const Center(
            child: SpinKitFadingCircle(color: Colors.pinkAccent, size: 50.0),
          )
        : hasError
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('error occurred'),
                    // Text(myRemindersProviderRef.error.toString()),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: onRefresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No data yet'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: onRefresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : render();
  }
}

// class AsunaProviderHelper {
//   static Widget Function(Object error, StackTrace? stackTrace) error(
//       Future Function()? onRefresh) =>
//           (Object error, StackTrace? stackTrace) => Scaffold(
//         appBar: renderAppBar(avatar: false),
//         body: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   FxText.titleMedium('读取数据失败'),
//                   FxSpacing.height(4),
//                   if (onRefresh != null)
//                     Container(
//                       margin: FxSpacing.horizontal(24),
//                       child: AsunaButton(
//                         onPressed: onRefresh,
//                         child: const Text('刷新'),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//
//   static Widget loader() =>
//       const Center(child: SpinKitDancingSquare(color: Colors.red, size: 50.0));
//
//   static Widget render<T>(AsyncValue<T> providerRef,
//       {required Widget Function(T data) render, Future Function()? onRefresh}) {
//     return providerRef.when(
//       data: render,
//       error: AsunaProviderHelper.error(onRefresh),
//       loading: AsunaProviderHelper.loader,
//     );
//   }
// }
