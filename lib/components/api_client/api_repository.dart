import 'package:flutter_app_scaffold/components/api_client/api_client.dart';

abstract class IApiRepository {
  IApiClient get apiClient;
  void close();
}
