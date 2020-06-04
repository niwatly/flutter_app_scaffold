import 'package:flutter_app_scaffold/repository/api/api_session.dart';
import 'package:flutter_app_scaffold/repository/session_repository.dart';

import 'common.dart';

const _dev = ApiSession(
  userId: 1,
  token: "sample token",
);

void main() {
  const environment = Environment.development(
    debugCondition: DebugCondition(
      //alwaysRequestLogin: true,
      sessionRepository: ConstantSessionRepository(_dev),
    ),
  );

  App(environment).run();
}
