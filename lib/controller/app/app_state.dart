import 'package:flutter/widgets.dart';

class AppState {
  /// BuildContextの不要なNavigatorへのアクセスを提供する
  GlobalKey<NavigatorState> navigatorKey;
  NavigatorState get navigator => navigatorKey.currentState;

  AppState._({
    this.navigatorKey,
  });

  factory AppState() {
    return AppState._(
      navigatorKey: GlobalKey<NavigatorState>(),
    );
  }
}
