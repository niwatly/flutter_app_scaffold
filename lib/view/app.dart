import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_scaffold/common.dart';
import 'package:flutter_app_scaffold/components/api_client/api_client_error.dart';
import 'package:flutter_app_scaffold/components/inapp_navigation/dialog_helper.dart';
import 'package:flutter_app_scaffold/components/inapp_navigation/inapp_launcher.dart';
import 'package:flutter_app_scaffold/components/inapp_navigation/inapp_router.dart';
import 'package:flutter_app_scaffold/components/logger/logger.dart';
import 'package:flutter_app_scaffold/components/refresh_provider/controller/refresh_controller.dart';
import 'package:flutter_app_scaffold/controller/app/app_controller.dart';
import 'package:flutter_app_scaffold/controller/app/app_state.dart';
import 'package:flutter_app_scaffold/controller/session/session_controller.dart';
import 'package:flutter_app_scaffold/controller/session/session_state.dart';
import 'package:flutter_app_scaffold/resource/intl_resource.dart';
import 'package:flutter_app_scaffold/resource/theme_resource.dart';
import 'package:flutter_app_scaffold/screen/splash/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import '../environment.dart';

ILogger logger;

class App extends StatelessWidget {
  // ここをconstにするとクラッシュしてしまうのでとりあえずignoreする
  // ignore: prefer_const_constructors_in_immutables
  final Environment env;

  const App._(this.env);

  factory App(Environment env) {
    final app = App._(env);
    logger = env.isDebug ? PrintLogger() : SilentLogger();

    return app;
  }

  void run() {
    logger.info("run app");

    //アプリ内で発生した Flutter Framework のエラーをハンドルしてFirebaseCrashlyticsに送信する
    //
    //Note: Zoneの外で発生するエラーをここでハンドルする
    FlutterError.onError = (detail) {
      //Crashlytics.instance.recordFlutterError(detail);

      FlutterError.dumpErrorToConsole(detail);
    };

    RefreshController.errorCallback = (e, st) => recordError(e, st);
    InAppRouter.errorCallback = (e, st) => recordError(e, st);
    InAppLauncher.errorCallback = (e, st) => recordError(e, st);

    //アプリ内で発生した Flutter Framework のエラーをハンドルしてFirebaseCrashlyticsに送信する
    //
    //Note: Zoneの中で発生するエラーをここでハンドルする
    runZonedGuarded(
      () => runApp(this),
      (e, st) => recordError(e, st),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// 環境変数
        Provider<Environment>.value(
          value: env,
        ),

        /// アプリ全体に関するController
        StateNotifierProvider<AppController, AppState>(create: (context) {
          final dialogBuilder = DialogBuilder(
            okLabel: I18n().labelOk,
            cancelLabel: I18n().labelCancel,
            confirmLabel: I18n().labelConfirm,
            errorLabel: I18n().labelError,
            cancelStyle: context.texts.bodyText2.apply(
              color: context.colors.dark26,
            ),
            okStyle: context.texts.subtitle2.apply(
              color: context.colors.main50,
            ),
            loadingWidget: FractionallySizedBox(
              widthFactor: 0.2,
              child: FittedBox(
                child: SpinKitCircle(
                  color: context.colors.main50,
                ),
              ),
            ),
            loadingMessageStyle: context.texts.subtitle1.apply(
              color: context.colors.main50,
            ),
          );

          return AppController(dialogBuilder);
        }),

        /// 認証情報に関するController
        StateNotifierProvider<SessionController, SessionState>(
          create: (context) => SessionController(),
        ),
      ],
      child: const _App(),
    );
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();

    return MaterialApp(
      title: I18n().appName,
      // AppControllerの中で画面遷移できるよう、navigatorのkeyを登録する
      navigatorKey: context.select<AppState, GlobalKey<NavigatorState>>((x) => x.navigatorKey),
      navigatorObservers: [
        // 「現在どの画面が開かれているか？」をNavigatorとは別に管理する用
        controller.navigatorObserver,
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ja", ""),
      ],
      theme: ThemeResource.getDefaultTheme(Brightness.light),
      darkTheme: ThemeResource.getDefaultTheme(Brightness.dark),
      home: const SplashScreen(),
    );
  }
}

void recordError(dynamic e, StackTrace st, {Map<String, dynamic> params = const {}}) {
  final ex = e;

  logger.warning(ex, st: st);

  if (ex is RepositoryErrorMixin) {
    final apiError = ex.error;
    if (apiError is UnsuccessfulStatusError) {
      if (apiError.response.statusCode == 401) {
        // 401エラーは無視する
        return;
      }
    }

    for (final entry in params.entries) {
      switch (entry.value.runtimeType) {
        case int:
          //Crashlytics.instance.setInt(entry.key, entry.value);
          break;
        case double:
          //Crashlytics.instance.setDouble(entry.key, entry.value);
          break;
        case String:
          //Crashlytics.instance.setString(entry.key, entry.value);
          break;
        case bool:
          //Crashlytics.instance.setBool(entry.key, entry.value);
          break;
        default:
          logger.warning("Unexpected parameter type received. ${entry.value} with ${entry.key} was ignored.");
      }
    }

    //Crashlytics.instance.recordError(ex, st);
  }
}
