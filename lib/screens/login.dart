import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:asuna_flutter/asuna_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reminder/router.dart';
import 'package:reminder/widgets/button.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // true - signup, false - login
    final mode = useToggle(true);
    final isMounted = useIsMounted();

    useLogger('<[LoginScreen]>', props: {'isSignUp': mode.value});

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orangeAccent, Colors.pinkAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(children: [
            const SizedBox(height: 120),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 52),
              child: const Center(
                child: Text(
                  'Reminder Park',
                  style: TextStyle(
                    fontSize: 36,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 36),
              child: CustomAnimatedToggleSwitch(
                current: mode.value,
                values: const [true, false],
                indicatorSize:
                    Size.fromWidth(MediaQuery.of(context).size.width / 2 - 24),
                onChanged: mode.toggle,
                iconBuilder: (context, local, global) => Container(
                  child: Center(
                    child: Text(
                      local.value ? 'New' : 'Already have one',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                foregroundIndicatorBuilder: (context, global) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      mode.value ? 'Sign Up' : 'Login',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            /*
            const SizedBox(height: 24),
            AsunaButton(
              onPressed: () {},
              child: Row(children: [
                Icon(Icons.mail),
                const SizedBox(width: 6),
                Text(
                  'Sign In with Mail',
                  style: TextStyle(fontSize: 18),
                ),
              ]),
            ),*/
            const SizedBox(height: 24),
            SignInWithAppleButton(
              onPressed: () async {
                AuthorizationCredentialAppleID? credential;
                try {
                  credential = await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                  );
                  logger.info('SignInWithAppleButton credential:$credential');
                } on SignInWithAppleAuthorizationException catch (_) {
                } catch (e) {
                  logger.warning('cannot sign in with apple: $e');
                }
                if (credential == null) return;

                // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                try {
                  final vo = await AuthFunc.ins.signInWithApple(
                    SignInWithAppleDTO(
                      code: credential.authorizationCode,
                      givenName: credential.givenName,
                      familyName: credential.familyName,
                      email: credential.email,
                      // useBundleId: !kIsWeb && (Platform.isIOS || Platform.isMacOS),
                    ),
                  );
                  if (vo == null) {
                    AsunaDialog.error('登录失败');
                  } else {
                    AsunaDialog.message('登录成功，跳转中...');
                    await AsunaFunc.ins.auth.handleLoginToken(vo);
                    if (isMounted()) {
                      // ignore: use_build_context_synchronously
                      Routes.router.navigateTo(context, BaseRoutePath.root);
                    }
                  }
                } on OneError catch (e) {
                  logger.severe('signUp with apple id error $e');
                  AsunaDialog.error('通过苹果账号登录失败: ${e.message}');
                } catch (e) {
                  logger.severe('signUp with apple id error $e');
                  AsunaDialog.error('通过苹果账号登录失败: $e');
                }
              },
            ),
            Visibility(
              visible: false,
              child: Stack(children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 24),
                      child: Column(children: [
                        Container(child: const Text('注册')),
                        Container(child: const Text('注册')),
                        Container(child: const Text('注册')),
                      ]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 24,
                  right: 24,
                  child: SignInWithAppleButton(
                    onPressed: () async {
                      final credential =
                          await SignInWithApple.getAppleIDCredential(
                        scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName,
                        ],
                      );

                      logger
                          .info('SignInWithAppleButton credential:$credential');

                      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                      // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                      try {
                        final vo = await AuthFunc.ins.signInWithApple(
                          SignInWithAppleDTO(
                            code: credential.authorizationCode,
                            givenName: credential.givenName,
                            familyName: credential.familyName,
                            email: credential.email,
                            // useBundleId: !kIsWeb && (Platform.isIOS || Platform.isMacOS),
                          ),
                        );
                        if (vo == null) {
                          AsunaDialog.error('登录失败');
                        } else {
                          AsunaDialog.message('登录成功，跳转中...');
                          await AsunaFunc.ins.auth.handleLoginToken(vo);
                          if (isMounted()) {
                            // ignore: use_build_context_synchronously
                            Routes.router.navigateTo(context, '/home');
                          }
                        }
                      } catch (e, s) {
                        logger.severe('signUp with apple id error $e $s');
                        AsunaDialog.error('通过苹果账号登录失败: $e');
                      }
                    },
                  ),
                  /*AsunaButton(
                    type: AsunaButtonType.block,
                    onPressed: () {},
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),*/
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
