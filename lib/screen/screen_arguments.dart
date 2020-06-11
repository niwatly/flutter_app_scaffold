import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_components/inapp_navigation/screen_arguments.dart';
import 'package:flutter_app_scaffold/screen/home/home_screen.dart';
import 'package:flutter_app_scaffold/screen/login/login_screen.dart';

class HomeScreenArguments implements IScreenArguments {
  const HomeScreenArguments();

  @override
  bool get isSingleTask => true;

  @override
  bool get isSingleTop => false;

  @override
  String get screenName => "/home";

  @override
  Route<dynamic> generateRoute() => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: RouteSettings(name: screenName),
      );
}

class LoginScreenArguments implements IScreenArguments {
  const LoginScreenArguments();

  @override
  bool get isSingleTask => false;

  @override
  bool get isSingleTop => true;

  @override
  String get screenName => "/login";

  @override
  Route<dynamic> generateRoute() => MaterialPageRoute(
        builder: (_) => const LoginScreen(),
        settings: RouteSettings(name: screenName),
      );
}
