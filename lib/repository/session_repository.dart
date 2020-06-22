import 'dart:async';
import 'dart:convert';

import 'package:flutter_app_components/api_client/api_client.dart';
import 'package:flutter_app_components/api_client/api_client_error.dart';
import 'package:flutter_app_scaffold/controller/session/session.dart';
import 'package:flutter_app_scaffold/view/app.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_scaffold/common.dart';

abstract class ISessionRepository {
  Future<Session> get();

  Future delete();

  Future<EmailAuthSuccess> postEmailAuth(String email, String password);
}

class SessionRepository implements ISessionRepository {
  static const String _preferenceKeySession = "session";
  static Session _cachedSession;

  final IApiClient apiClient;

  const SessionRepository(this.apiClient);

  @override
  Future<Session> get() async {
    if (_cachedSession != null) {
      return _cachedSession;
    }

    final instance = await SharedPreferences.getInstance();

    final str = instance.getString(_preferenceKeySession);

    if (str.isNullOrEmpty) {
      throw const SessionGetError.notFound();
    }

    final json = jsonDecode(str);
    final session = Session.fromJson(json);

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

  Future<Session> _createSessionFromResponseAndSave(Response response) {
    final json = jsonDecode(response.body);

    final session = Session.fromJson(json);

    return SharedPreferences.getInstance()
        .catchError((error) => throw const SessionGetError(SessionGetErrorReason.CanNotAccessStorage))
        .then((x) => x.setString(_preferenceKeySession, jsonEncode(session)))
        .catchError((error) => throw const SessionGetError(SessionGetErrorReason.SaveFailed))
        .then((x) => _cachedSession = session);
  }
}

class ConstantSessionRepository implements ISessionRepository {
  final Session _session;

  const ConstantSessionRepository(this._session);

  @override
  Future<Session> get() => Future.value(_session);

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
  final Session session;

  const EmailAuthSuccess(this.session);
}

class EmailAuthError with RepositoryErrorMixin {
  @override
  final IApiClientError error;

  EmailAuthError(this.error);
}
