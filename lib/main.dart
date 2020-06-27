import 'package:flutter_app_scaffold/repository/session_repository.dart';

import 'common.dart';
import 'controller/session/session.dart';

const _dev = Session(
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
