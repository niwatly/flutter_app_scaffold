class I18n {
  static I18n _instance;
  I18n._();
  factory I18n() => _instance ??= I18n._();

  String get appName => "appname";
  ///#region エラーメッセージ

  String get errorInvalidUri => "通信に失敗しました。無効なパラメータです";
  String get errorInvalidRequest => "通信に失敗しました。無効なリクエストです";
  String get errorTimeout => "通信似失敗しました。ネットワーク環境を確認のうえ、もう一度お試しください";
  String get errorUnknown => "通信に失敗しました";
  String get errorEmailAuthFailed => "メールアドレス認証に失敗しました";
  String get errorRouteNotFound => "お探しのページは見つかりませんでした";

  ///#endregion

  ///#region ラベル
  String get labelUnknown => "不明";
  String get labelError => "エラー";
  String get labelConfirm => "確認";
  String get labelCancel => "キャンセル";
  String get labelOk => "OK";

  ///#endregion

  ///#region メッセージ

  ///#endregion

  /// #region タイトル
///
  /// #endregion
}
