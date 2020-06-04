import 'package:flutter/foundation.dart';
import 'package:flutter_app_scaffold/components/api_client/api_client.dart';
import 'package:flutter_app_scaffold/components/api_client/api_repository.dart';
import 'package:flutter_app_scaffold/controller/session/session_state.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:state_notifier/state_notifier.dart';

class ApiRepositoryNotifier<T extends IApiRepository> extends StateNotifier<T> with LocatorMixin {
  T Function(IApiClient apiClient) create;
  ApiRepositoryNotifier(this.create) : super(null);

  @override
  void update(Locator watch) {
    super.update(watch);

    final apiClient = watch<SessionState>().apiClient;

    if (state == null || state.apiClient != apiClient) {
      state = create(apiClient);
    }
  }

  @override
  void dispose() {
    state?.close();
    super.dispose();
  }
}

StateNotifierProvider apiRepositoryProvider<T extends IApiRepository>({
  @required T Function(IApiClient apiClient) create,
}) {
  return StateNotifierProvider<ApiRepositoryNotifier<T>, T>(
    create: (context) => ApiRepositoryNotifier(create),
  );
}
