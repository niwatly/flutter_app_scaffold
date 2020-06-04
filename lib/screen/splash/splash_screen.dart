import 'package:flutter/material.dart';
import 'package:flutter_app_scaffold/common.dart';
import 'package:flutter_app_scaffold/controller/splash/splash_screen_controller.dart';
import 'package:flutter_app_scaffold/controller/splash/splash_screen_state.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen();

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<SplashScreenController, SplashScreenState>(
      create: (context) => SplashScreenController(),
      lazy: false,
      child: Material(
        color: context.colors.light100,
      ),
    );
  }
}
