import 'package:flutter/material.dart';
import 'package:flutter_app_scaffold/components/refresh_provider/refresh_provider.dart';
import 'package:flutter_app_scaffold/controller/app/app_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () => context.read<AppController>().showLoadingDialog(
                Future.delayed(const Duration(seconds: 2)),
                message: "この操作には時間がかかることがあります...",
              ),
          child: const Text("Welcome to home screen!"),
        ),
      ),
    );
  }
}
