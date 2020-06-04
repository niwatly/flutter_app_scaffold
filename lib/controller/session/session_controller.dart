import 'package:flutter_app_scaffold/components/extension/extension.dart';
import 'package:flutter_app_scaffold/controller/session/session_state.dart';
import 'package:flutter_app_scaffold/environment.dart';
import 'package:flutter_app_scaffold/repository/api/api_client_factory.dart';
import 'package:flutter_app_scaffold/repository/api/api_session.dart';
import 'package:flutter_app_scaffold/repository/session_repository.dart';
import 'package:flutter_app_scaffold/resource/intl_resource.dart';
import 'package:flutter_app_scaffold/view/app.dart';
import 'package:state_notifier/state_notifier.dart';

class SessionController extends StateNotifier<SessionState> with LocatorMixin {
  ISessionRepository _sessionRepository;

  Stream<SessionState> onSessionChanged;

  SessionController() : super(SessionState());

  @override
  void initState() {
    super.initState();

    logger.info("session controller created.");

    _setDefaultState();

    // SessionRepository用のApiClientを生成し、初回のロードを実行する
    final env = read<Environment>();

    _sessionRepository = env.debugCondition.sessionRepository ?? SessionRepository(createAnonymousApiClient(env));

    _loadSession();

    final stream = asStream();

    onSessionChanged = stream.distinct();
  }

  /// メールアドレスとパスワードをAPIサーバに送信し、認証情報を更新します
  ///
  /// また、認証情報の獲得に成功したときは、それをFirebaseにセットします
  Future<ApiSession> loginEmail(String email, String password) async {
    try {
      final result = await _sessionRepository.postEmailAuth(email, password);

      final session = result.session;

      _setSuccessState(session);

      return session;
    } on EmailAuthError catch (e, st) {
      recordError(e, st);
      // メールアドレスの認証に失敗した
      throw LoginFailedException(
        LoginFailedProviderKind.Email,
        LoginFailedReasonKind.UnAuthorized,
        I18n().errorEmailAuthFailed,
      );
    }
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
    } catch (e, st) {
      recordError(e, st);
      _setErrorState();
    }
  }

  void _setErrorState({SessionGetError error = const SessionGetError.notFound()}) {
    state = SessionState(
      session: null,
      apiClient: createAnonymousApiClient(read<Environment>()),
      error: error,
    );
  }

  void _setSuccessState(ApiSession session) {
    state = SessionState(
      session: session,
      apiClient: createAuthorizedApiClient(read<Environment>(), session),
      error: null,
    );
  }

  void _setDefaultState() {
    state = SessionState(
      session: null,
      apiClient: createAnonymousApiClient(read<Environment>()),
      error: null,
    );
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
