import 'package:flutter/foundation.dart';
import 'package:flutter_app_components/api_client/api_client.dart';
import 'package:flutter_app_components/api_client/api_repository.dart';
import 'package:flutter_app_scaffold/controller/session/session_state.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class ApiRepositoryController<T> extends StateNotifier<T> with LocatorMixin {
  T Function(IApiClient apiClient) create;
  ApiRepositoryController(this.create) : super(null);

  @override
  void update(Locator watch) {
    super.update(watch);

    final currentState = state;

    if (currentState is IApiRepository) {
      final apiClient = watch<SessionState>().apiClient;

      if (state == null || currentState.apiClient != apiClient) {
        state = create(apiClient);
      }
    }
  }

  @override
  void dispose() {
    final currentState = state;

    if (currentState is IApiRepository) {
      currentState.close();
    }

    super.dispose();
  }
}

StateNotifierProvider apiRepositoryProvider<T>({
  @required T Function(IApiClient apiClient) create,
}) {
  return StateNotifierProvider<ApiRepositoryController<T>, T>(
    create: (context) => ApiRepositoryController(create),
  );
}
