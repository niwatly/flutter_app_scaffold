import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_components/inapp_navigation/dialog_builder.dart';

class AppState {
  /// BuildContextの不要なNavigatorへのアクセスを提供する
  GlobalKey<NavigatorState> navigatorKey;
  NavigatorState get navigator => navigatorKey.currentState;

  GlobalKey<DialogBuilderState> dialogBuilderKey;
  DialogBuilderState get dialogBuilder => dialogBuilderKey.currentState;

  AppState._({
    this.navigatorKey,
    this.dialogBuilderKey,
  });

  factory AppState() {
    return AppState._(
      navigatorKey: GlobalKey<NavigatorState>(),
      dialogBuilderKey: GlobalKey<DialogBuilderState>(),
    );
  }
}
