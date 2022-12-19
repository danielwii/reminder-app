import 'dart:async';

import 'package:asuna_flutter/asuna_flutter.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reminder/models/user.dart';

import '../router.dart';
import '../widgets/button.dart';

final appReleaseProvider = FutureProvider<dynamic>(
    (_) async => await AsunaFunc.ins.detectNewRelease('reminder'));

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appReleaseProviderRef = ref.watch(appReleaseProvider);

    /*
    useEffectOnce(() {
      return null;
    });*/

    useEffect(() {
      logger.info(
          'value -- appReleaseProviderRef is ${appReleaseProviderRef.valueOrNull}');
      return null;
    }, [appReleaseProviderRef.valueOrNull]);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pinkAccent,
                Colors.lightBlueAccent,
                Color.fromRGBO(228, 217, 236, 1),
                // Color.fromRGBO(228, 217, 236, 1),
                // Color.fromRGBO(255, 255, 255, 1),
              ]),
        ),
        child: Center(
          child: Column(children: [
            const SizedBox(height: 200),
            CachedImage(
                'https://ouch-cdn2.icons8.com/GBRkIn3UQN3logwggZhBsBYqbsPoQyKOvYGC2C2wvkg/rs:fit:256:256/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNzAv/NTc5NDc4ZWMtNzJi/YS00MTVjLTgxYzUt/MmM3ODM1MDY4ZGEw/LnN2Zw.png'),
            appReleaseProviderRef.when(
              data: (release) {
                if (release != null) {
                  logger.info('go to upgrade...');
                  // Func.ins.showReleaseDialog(context, release: release);
                } else {
                  logger.info('go to app...');
                  Future.microtask(() async {
                    // if (Token.isAuthenticated) {
                    await AppContext.initAfterSplash();
                    // ref.invalidate(currentUserProvider);
                    // ref.invalidate(homeDataProvider(IDArgs(id: null)));
                    // }
                  });
                  Future.delayed(const Duration(seconds: 1), () async {
                    UserModel().authUserAccount(
                      toHomeScreen: () => Routes.router.navigateTo(
                          context, BaseRoutePath.root,
                          clearStack: true, transition: TransitionType.fadeIn),
                      toSignInScreen: () => Routes.router.navigateTo(
                          context, BaseRoutePath.login,
                          clearStack: true,
                          transition: TransitionType.cupertino),
                      toSignUpScreen: () => Routes.router
                          .navigateTo(context, '${BaseRoutePath.login}?reg',
                              clearStack: true,
                              // routeSettings: RouteSettings(arguments: {}),
                              transition: TransitionType.fadeIn),
                    );
                  });
                }
                return Column(children: const [
                  Text('Thinking of you...'),
                ]);
              },
              error: (e, s) => Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      const Text('服务器访问异常或正在升级中，请稍后再试或联系客服。'),
                      const SizedBox(height: 4),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: AsunaButton(
                          onPressed: () async {
                            ref.invalidate(appReleaseProvider);
                            return ref.read(appReleaseProvider.future);
                          },
                          child: const Text('刷新'),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              loading: () => Column(children: [
                const Text('initial...'),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const SpinKitSpinningLines(
                      color: Colors.white, size: 50.0),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
