import 'package:flutter_app_scaffold/components/api_client/json_helper.dart';

class ApiSession {
  final int userId;
  final String token;

  const ApiSession({
    this.userId,
    this.token,
  });

  factory ApiSession.fromJson(Map<String, dynamic> json) {
    return ApiSession(
      userId: json.integer("user_id"),
      token: json.string("token"),
    );
  }
}
