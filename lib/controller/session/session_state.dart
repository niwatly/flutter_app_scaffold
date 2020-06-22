import 'package:flutter_app_scaffold/controller/session/session.dart';
import 'package:flutter_app_scaffold/repository/session_repository.dart';

class SessionState {
  final Session session;
  final SessionGetError error;

  SessionState({
    this.session,
    this.error,
  });

  bool get hasError => error != null;

  bool get hasSession => session != null;
}
