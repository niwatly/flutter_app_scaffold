import 'package:flutter_app_scaffold/components/api_client/api_client.dart';
import 'package:flutter_app_scaffold/repository/api/api_session.dart';
import 'package:flutter_app_scaffold/repository/session_repository.dart';

class SessionState {
  final ApiSession session;
  final SessionGetError error;
  final IApiClient apiClient;

  SessionState({
    this.session,
    this.error,
    this.apiClient,
  });

  bool get hasError => error != null;

  bool get hasSession => session != null;
}
