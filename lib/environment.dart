import 'package:flutter/foundation.dart';

class Environment {
  static const String _hostProd = "hoge";
  static const String _hostStg = "stg.hoge";
  static const String _hostDev = "dev.hoge";

  /// デバッグモードかどうか
  bool get isDebug => kind != EnvironmentKind.Production;

  bool get isStaging => kind == EnvironmentKind.Adhoc;

  /// 環境種別
  final EnvironmentKind kind;

  /// 通信先のHost
  final String host;

  /// 通信先のポート番号
  final int port;

  /// 通信先のScheme
  final bool useHttp;

  /// デバッグ専用の設定
  final DebugCondition debugCondition;

  const Environment({
    @required this.kind,
    @required this.host,
    @required this.port,
    @required this.useHttp,
    @required this.debugCondition,
  });

  /// 本番環境用
  const Environment.production()
      : this(
          kind: EnvironmentKind.Production,
          host: _hostProd,
          useHttp: false,
          port: null,
          debugCondition: const DebugCondition.asDisable(),
        );

  /// ステージング環境用
  const Environment.adhoc({
    DebugCondition debugCondition = const DebugCondition.asDisable(),
  }) : this(
          kind: EnvironmentKind.Adhoc,
          host: _hostStg,
          useHttp: false,
          port: null,
          debugCondition: debugCondition,
        );

  /// 開発環境用
  ///
  /// Note: authorityやportを変更することで、任意の接続先に変更できる
  const Environment.development({
    String authority = _hostDev,
    bool useHttp = false,
    int port,
    DebugCondition debugCondition = const DebugCondition.asDisable(),
  }) : this(
          kind: EnvironmentKind.Development,
          host: authority,
          useHttp: useHttp,
          port: port,
          debugCondition: debugCondition,
        );
}

class DebugCondition {
  const DebugCondition();

  const DebugCondition.asDisable() : this();
}

enum EnvironmentKind {
  Development,
  Adhoc,
  Production,
}
