import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_app_components/api_client/api_client.dart';
import 'package:flutter_app_components/api_client/default_api_client.dart';
import 'package:flutter_app_components/utility/extension.dart';
import 'package:flutter_app_scaffold/controller/session/session.dart';
import 'package:flutter_app_scaffold/controller/session/session_state.dart';
import 'package:flutter_app_scaffold/repository/session_repository.dart';
import 'package:package_info/package_info.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../environment.dart';

class SessionController extends StateNotifier<SessionState> with LocatorMixin {
  ISessionRepository _sessionRepository;

  Stream<SessionState> onSessionChanged;

  SessionController() : super(SessionState());

  @override
  void initState() {
    super.initState();

    _setDefaultState();

    // SessionRepository用のApiClientを生成し、初回のロードを実行する
    final env = read<Environment>();

    _sessionRepository = env.debugCondition.sessionRepository ?? SessionRepository(createDefaultAPiClient());

    _loadSession();

    final stream = asStream();

    onSessionChanged = stream.distinct();
  }

  /// 認証情報を取得し、その結果に応じて状態を変化させます
  Future _loadSession() async {
    try {
      if (read<Environment>().debugCondition.alwaysRequestLogin) {
        throw const SessionGetError.notFound();
      }

      final session = await _sessionRepository.get();

      _setSuccessState(session);
    } on SessionGetError catch (e) {
      _setErrorState(error: e);
    } catch (e) {
      _setErrorState();
    }
  }

  void _setErrorState({SessionGetError error = const SessionGetError.notFound()}) {
    state = SessionState(
      session: null,
      error: error,
    );
  }

  void _setSuccessState(Session session) {
    state = SessionState(
      session: session,
      error: null,
    );
  }

  void _setDefaultState() {
    state = SessionState(
      session: null,
      error: null,
    );
  }

  IApiClient createDefaultAPiClient() {
    final env = read<Environment>();

    if (state.hasSession) {
      return DefaultApiClient(
        useHttp: env.useHttp,
        port: env.port,
        host: env.host,
        headersFuture: _buildHeader(state.session),
      );
    } else {
      return DefaultApiClient(
        useHttp: env.useHttp,
        host: env.host,
        port: env.port,
        headersFuture: {},
      );
    }
  }

  Future<Map<String, String>> _buildHeader(Session session) async {
    final authorization = {
      "Authorization": "Bearer ${session.token}",
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
}

class LoginFailedException implements Exception {
  final LoginFailedProviderKind provider;
  final LoginFailedReasonKind reason;
  final String message;

  const LoginFailedException(
    this.provider,
    this.reason,
    this.message,
  );
}

enum LoginFailedProviderKind {
  Email,
}

enum LoginFailedReasonKind {
  Cancel,
  Unidentified,
  UnAuthorized,
}
