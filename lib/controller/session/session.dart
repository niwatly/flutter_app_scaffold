import 'package:flutter_app_components/api_client/json_helper.dart';

class Session {
  final int userId;
  final String token;

  const Session({
    this.userId,
    this.token,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      userId: json.integer("user_id"),
      token: json.string("token"),
    );
  }
}
