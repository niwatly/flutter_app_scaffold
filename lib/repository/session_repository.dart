import 'dart:async';
import 'dart:convert';

import 'package:flutter_app_components/api_client/api_client.dart';
import 'package:flutter_app_components/api_client/api_client_error.dart';
import 'package:flutter_app_components/api_client/api_repository.dart';
import 'package:flutter_app_scaffold/view/app.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_scaffold/common.dart';
import 'api/api_session.dart';

abstract class ISessionRepository {
  Future<ApiSession> get();

  Future delete();

  Future<EmailAuthSuccess> postEmailAuth(String email, String password);
}

class SessionRepository implements ISessionRepository, IApiRepository {
  static const String _preferenceKeySession = "session";
  static ApiSession _cachedSession;

  @override
  final IApiClient apiClient;

  const SessionRepository(this.apiClient);

  @override
  Future<ApiSession> get() async {
    if (_cachedSession != null) {
      return _cachedSession;
    }

    final instance = await SharedPreferences.getInstance();

    final str = instance.getString(_preferenceKeySession);

    if (str.isNullOrEmpty) {
      throw const SessionGetError.notFound();
    }

    final json = jsonDecode(str);
    final session = ApiSession.fromJson(json);

    return _cachedSession = session;
  }

  @override
  Future delete() async {
    final instance = await SharedPreferences.getInstance();
    await instance.remove(_preferenceKeySession);
    _cachedSession = null;
  }

  @override
  Future<EmailAuthSuccess> postEmailAuth(String email, String password) async {
    try {
      final session = await apiClient.post(
        "v1/auth/email",
        body: {
          "email": email,
          "password": password,
        },
      ).then((x) => _createSessionFromResponseAndSave(x));

      final result = EmailAuthSuccess(session);

      return result;
    } on IApiClientError catch (e) {
      return Future.error(EmailAuthError(e));
    } catch (e, st) {
      recordError(e, st);
      rethrow;
    }
  }

  Future<ApiSession> _createSessionFromResponseAndSave(Response response) {
    final json = jsonDecode(response.body);

    final session = ApiSession.fromJson(json);

    return SharedPreferences.getInstance()
        .catchError((error) => throw const SessionGetError(SessionGetErrorReason.CanNotAccessStorage))
        .then((x) => x.setString(_preferenceKeySession, jsonEncode(session)))
        .catchError((error) => throw const SessionGetError(SessionGetErrorReason.SaveFailed))
        .then((x) => _cachedSession = session);
  }

  @override
  void close() {}
}

class ConstantSessionRepository implements ISessionRepository {
  final ApiSession _session;

  const ConstantSessionRepository(this._session);

  @override
  Future<ApiSession> get() => Future.value(_session);

  @override
  Future delete() async {}

  @override
  Future<EmailAuthSuccess> postEmailAuth(String email, String password) => Future.value(EmailAuthSuccess(_session));
}

class SessionGetError implements Exception {
  final SessionGetErrorReason reason;

  const SessionGetError(this.reason);

  const SessionGetError.notFound() : this(SessionGetErrorReason.NotFound);

  @override
  String toString() => "$runtimeType（reason = $reason）";
}

enum SessionGetErrorReason { CanNotAccessStorage, NotFound, SaveFailed }

class EmailAuthSuccess {
  final ApiSession session;

  const EmailAuthSuccess(this.session);
}

class EmailAuthError with RepositoryErrorMixin {
  @override
  final IApiClientError error;

  EmailAuthError(this.error);
}
