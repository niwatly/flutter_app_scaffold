import 'package:flutter/material.dart';
import 'package:flutter_app_scaffold/common.dart';
import 'package:flutter_app_scaffold/controller/app/app_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () => context.read<AppController>().showLoadingDialog(
                  Future.delayed(const Duration(seconds: 2)),
                  message: "この操作には時間がかかることがあります...",
                ),
            child: const Text("Welcome to home screen!"),
          ),
          RaisedButton(
            onPressed: () async {
              final res = await context.read<AppController>().showAskDialog(message: "Yes? No? ");

              logger.info("$res");
            },
            child: const Text("a...a,,,"),
          ),
          RaisedButton(
            onPressed: () async {
              const candidates = [
                "Hi,",
                "My",
                "Names is too long. Can you see? oh yeah!!!!!!! 幸せは歩いてこないだから歩いていくんだね",
              ];
              final res = await context.read<AppController>().showPickerDialog(candidates, title: "選択してください");

              logger.info("$res");
            },
            child: const Text("Wel...come..."),
          ),
        ],
      ),
    );
  }
}
