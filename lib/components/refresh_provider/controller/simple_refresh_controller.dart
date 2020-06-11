part of 'refresh_controller.dart';

class SimpleRefreshController<V, E> extends RefreshController<V, E> {
  Future<V> Function() refresher;

  SimpleRefreshController({
    @required this.refresher,
    RefreshState<V, E> initialState,
    Duration lifetime,
  }) : super._(
          lifetime: lifetime,
          initialState: initialState,
        );

  @override
  Stream<RefreshState<V, E>> _doRefresh(RefreshConfig config, RefreshState<V, E> currentState) async* {
    if (!config.silent) {
      yield currentState = currentState.copyWith(isRefreshing: true);
    }

    try {
      final value = await refresher();

      yield currentState = currentState.copyWith(
        value: value,
        isRefreshing: false,
        initialRefreshCompleted: true,
      );
    } on E catch (e) {
      yield currentState = currentState.copyWith(
        error: e,
        isRefreshing: false,
      );
    } catch (e, st) {
      RefreshController.errorCallback?.call(e, st);
    }
  }
}
