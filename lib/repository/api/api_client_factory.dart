import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_app_scaffold/components/api_client/api_client.dart';
import 'package:flutter_app_scaffold/components/api_client/default_api_client.dart';
import 'package:flutter_app_scaffold/environment.dart';
import 'package:flutter_app_scaffold/repository/api/api_session.dart';
import 'package:package_info/package_info.dart';

IApiClient createAnonymousApiClient(Environment env) => DefaultApiClient(
      useHttp: env.useHttp,
      host: env.host,
      port: env.port,
      headersFuture: Future.value({}),
    );

IApiClient createAuthorizedApiClient(Environment env, ApiSession session) => DefaultApiClient(
      useHttp: env.useHttp,
      port: env.port,
      host: env.host,
      headersFuture: _buildHeader(session),
    );

Future<Map<String, String>> _buildHeader(ApiSession session) async {
  final authorization = {
    "Authorization": "Bearer $session.token",
  };

  final userAgent = await Future(() async {
    String userAgent;
    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      userAgent = "${packageInfo.packageName}/${packageInfo.version}.${packageInfo.buildNumber} (${Platform.operatingSystem}; ${info.version.release}; ${info.model};)";
    } else if (Platform.isIOS) {
      final info = await DeviceInfoPlugin().iosInfo;
      userAgent = "${packageInfo.packageName}/${packageInfo.version}.${packageInfo.buildNumber} (${Platform.operatingSystem}; ${info.systemVersion}; ${info.utsname.machine};)";
    } else {
      userAgent = "${packageInfo.packageName}/${packageInfo.version}.${packageInfo.buildNumber} (${Platform.operatingSystem};)";
    }

    return {
      "User-Agent": userAgent,
    };
  });

  return {
    ...authorization,
    ...userAgent,
  };
}
