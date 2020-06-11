import 'package:flutter/material.dart';
import 'package:flutter_app_scaffold/common.dart';
import 'package:flutter_app_scaffold/components/inapp_navigation/dialog_helper.dart';
import 'package:flutter_app_scaffold/components/inapp_navigation/inapp_launcher.dart';
import 'package:flutter_app_scaffold/components/inapp_navigation/inapp_router.dart';
import 'package:flutter_app_scaffold/components/inapp_navigation/screen_arguments.dart';
import 'package:flutter_app_scaffold/resource/intl_resource.dart';
import 'package:flutter_app_scaffold/view/app.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_navigator_observer.dart';
import 'app_state.dart';

class AppController extends StateNotifier<AppState> with LocatorMixin {
  final AppNavigatorObserver navigatorObserver = AppNavigatorObserver();

  /// URLによるアプリない遷移を行うためのLauncher
  InAppLauncher launcher;

  /// URLをScreenArgumentsに変換するためのRouter
  InAppRouter get router => launcher.router;

  final DialogBuilder dialogBuilder;

  AppController(this.dialogBuilder) : super(AppState());

  @override
  void initState() {
    super.initState();

    final router = InAppRouter(routeDefines: {});
    launcher = InAppLauncher(router);
  }

  Future<T> showScreen<T>(
    IScreenArguments<T> arguments, {
    clean = false,
  }) async {
    final navigator = state.navigator;

    if (clean || arguments.isSingleTask) {
      // スタックの削除がリクエストされたので、スタック中のScreenを全て閉じる
      final anchor = arguments.isSingleTop ? arguments.screenName : navigatorObserver.firstOrNull;

      if (anchor != null && navigator.canPop()) {
        navigator.popUntil((x) => x.settings?.name == anchor);
      }
    }

    // 今表示されている画面の名前
    final currentScreenName = navigatorObserver.lastOrNull?.name;
    logger.info("show screen (current = $currentScreenName, new = ${arguments.screenName})");

    // updateが必要かどうか
    //
    // Note: Screenの部分アップデートの仕組みがないので、いまはneedUpdateな場合もreplaceしている
    final needReplace = clean || //
        (arguments.isSingleTop || arguments.isSingleTask) && currentScreenName == arguments.screenName;

    if (needReplace) {
      //FIXME: ホームの探す画面を開いているときにcampaigns/search による遷移がリクエストされたら、Routeを切り替えるのではなく、Screen内の状態を変化させてUIを更新したい
      //現状、replaceしないと古いセッション情報を保持しているRepositoryが残ってしまうので、Updateできるようになるまではreplaceする
      return navigator.pushReplacement(arguments.generateRoute());
    } else {
      //通常通りpushする
      return navigator.push(arguments.generateRoute());
    }
  }

  Future<T> showDialog<T>(Route<T> route) => state.navigator.push<T>(route);

  Future showErrorDialog(String message) => showDialog(dialogBuilder.error(message));

  Future showConfirmDialog(String message) => showDialog(dialogBuilder.confirm(message));

  Future showAskDialog({String title, String message}) => showDialog(dialogBuilder.ask(title: title, message: message));

  Future<T> showLoadingDialog<T>(Future future, {String message}) => showDialog(dialogBuilder.loading(future: future, message: message));

  Future<int> showPickerDialog(List<String> candidates, {String title}) => showDialog(dialogBuilder.pick(candidates, title: title));

  Future openUrl(
    String uriString, {
    String errorMessage,
  }) async {
    final _errorMessage = errorMessage ?? I18n().errorRouteNotFound;
    final showError = () => showDialog(read<DialogBuilder>().error(_errorMessage));

    try {
      final res = await canLaunch(uriString);

      if (res != true) {
        await showError();
        return;
      }

      await launch(
        uriString,
        forceSafariVC: false, //for iOS
        enableJavaScript: true,
      );
    } catch (e, st) {
      recordError(e, st);
      await showError();
    }
  }

  Future openMiscellaneousUrl({
    String uriString,
    Uri uri,
    bool disableInAppNavigation = false,
    String errorMessage,
  }) async {
    assert(uri != null || uriString != null);

    final _errorMessage = errorMessage ?? I18n().errorRouteNotFound;
    final showError = () => showDialog(read<DialogBuilder>().error(_errorMessage));

    Uri toOpenUri;

    try {
      toOpenUri = uri ?? Uri.parse(uriString);
    } catch (e, st) {
      recordError(e, st);
      await showError();
      return;
    }

    logger.info("try open uri $toOpenUri");

    try {
      final launchResult = await launcher.handleUri(
        uri: toOpenUri,
        disableInAppNavigation: disableInAppNavigation,
      );

      switch (launchResult.kind) {
        case InAppLaunchResultKind.ShowScreen:
          // アプリ内遷移する
          return showScreen(launchResult.screenArguments);
        case InAppLaunchResultKind.OpenBrowser:
          // ブラウザで開く
          return openUrl(launchResult.browserUri.toString(), errorMessage: errorMessage);
        case InAppLaunchResultKind.Error:
          // エラー表示する
          await showError();
          break;
        case InAppLaunchResultKind.Silent:
          // 何もしない
          break;
      }
    } catch (e, st) {
      // Launcherの想定外のエラー
      recordError(e, st);
      await showError();
    }
  }
}
