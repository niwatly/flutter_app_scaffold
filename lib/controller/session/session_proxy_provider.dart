import 'package:flutter/foundation.dart';
import 'package:flutter_app_scaffold/controller/session/session_controller.dart';
import 'package:flutter_app_scaffold/controller/session/session_state.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class SessionProxyNotifier<T> extends StateNotifier<T> with LocatorMixin {
  SessionState _lastSessionState;

  final T Function(SessionController controller, SessionState state) _update;
  final Function(T value) _dispose;

  SessionProxyNotifier({
    T initialState,
    T Function(SessionController controller, SessionState state) update,
    Function(T value) dispose,
  })  : _update = update,
        _dispose = dispose,
        super(initialState);

  @override
  void initState() {
    super.initState();

    _setState(read);
  }

  @override
  void update(T Function<T>() watch) {
    super.update(watch);

    _setState(watch);
  }

  @override
  void dispose() {
    _dispose?.call(state);
    super.dispose();
  }

  void _setState(Locator locator) {
    final newState = locator<SessionState>();

    if (_lastSessionState == newState) {
      return;
    }

    final oldState = state;

    if (oldState != null) {
      _dispose?.call(oldState);
    }

    state = _update(locator<SessionController>(), newState);

    _lastSessionState = newState;
  }
}

/// 型を毎回記述するのが面倒だった
StateNotifierProvider proxyStateNotifierProvider<T>({
  @required T Function(SessionController controller, SessionState state) update,
  Function(T value) dispose,
}) {
  return StateNotifierProvider<SessionProxyNotifier<T>, T>(
    create: (context) => SessionProxyNotifier<T>(
      update: update,
      dispose: dispose,
    ),
  );
}
