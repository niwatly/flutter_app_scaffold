import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_resource.dart';

class ThemeResource {
  static ThemeData getDefaultTheme(Brightness brightness) {
    final colors = ColorResource(brightness);

    //参考: https://master-api.flutter.dev/flutter/material/TextTheme-class.html
    const weight = 1.0;

    final customize = GoogleFonts.notoSansTextTheme(
      TextTheme(
        headline1: TextStyle(fontSize: 96 * weight, color: colors.dark87, fontWeight: FontWeight.w600, letterSpacing: -1.5),
        headline2: TextStyle(fontSize: 60 * weight, color: colors.dark87, fontWeight: FontWeight.w600, letterSpacing: -0.5),
        headline3: TextStyle(fontSize: 48 * weight, color: colors.dark87, fontWeight: FontWeight.w600, letterSpacing: 0.0),
        headline4: TextStyle(fontSize: 34 * weight, color: colors.dark87, fontWeight: FontWeight.w600, letterSpacing: 0.25),
        headline5: TextStyle(fontSize: 24 * weight, color: colors.dark87, fontWeight: FontWeight.w600, letterSpacing: 0.0),
        headline6: TextStyle(fontSize: 20 * weight, color: colors.dark87, fontWeight: FontWeight.w600, letterSpacing: 0.15),
        subtitle1: TextStyle(fontSize: 16 * weight, color: colors.dark54, fontWeight: FontWeight.w600, letterSpacing: 0.15),
        subtitle2: TextStyle(fontSize: 14 * weight, color: colors.dark54, fontWeight: FontWeight.w600, letterSpacing: 0.1),
        bodyText1: TextStyle(fontSize: 16 * weight, color: colors.dark54, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText2: TextStyle(fontSize: 14 * weight, color: colors.dark54, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        caption: TextStyle(fontSize: 12 * weight, color: colors.dark54, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: TextStyle(fontSize: 10 * weight, color: colors.dark54, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ),
    );

    final base = Typography.material2018();

    final original = Typography.material2018(
      black: base.black.merge(customize),
      white: base.white.merge(customize),
      englishLike: base.englishLike.merge(customize),
      dense: base.dense.merge(customize),
      tall: base.tall.merge(customize),
    );

    return ThemeData(
      inputDecorationTheme: InputDecorationTheme(
        alignLabelWithHint: true,
        fillColor: colors.main20.withOpacity(0.1),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        hintStyle: original.black.caption.apply(
          color: colors.dark26,
        ),
        errorStyle: original.black.caption.apply(
          color: colors.red50,
        ),
        labelStyle: original.black.headline6.apply(
          color: colors.dark87,
        ),
        helperMaxLines: 5,
        errorMaxLines: 5,
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.red50,
            width: 2,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.red50,
            width: 1,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.main50,
            width: 1,
          ),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.alto20,
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.main50,
            width: 3,
          ),
        ),
      ),
      brightness: brightness,
      typography: original,
      // チェックボックスの枠線
      unselectedWidgetColor: colors.dark54,
      // テキストの選択範囲
      textSelectionColor: brightness == Brightness.light ? colors.main20 : colors.main10,
      textSelectionHandleColor: colors.main50,
      // テキストのカーソル
      cursorColor: colors.main50,
      tooltipTheme: TooltipThemeData(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.main10,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.all(8),
        textStyle: customize.subtitle2.apply(
          color: colors.onMain10,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: colors.main10.withOpacity(0.98),
        actionTextColor: colors.main50,
        contentTextStyle: customize.subtitle2.apply(
          color: colors.onMain10,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: colors.dark54,
        size: 24,
      ),
      toggleableActiveColor: colors.main50,
      dividerColor: colors.dark26,
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: colors.main50,
            width: 4,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: colors.dark87,
        unselectedLabelColor: colors.dark26,
      ),
      appBarTheme: AppBarTheme(
        brightness: brightness,
        color: colors.light100,
        elevation: 0,
        iconTheme: IconThemeData(
          color: colors.dark87,
        ),
        actionsIconTheme: IconThemeData(
          color: colors.dark87,
        ),
      ),
      primaryColor: colors.main50,
      accentColor: colors.main50,
      scaffoldBackgroundColor: colors.light100,
      colorScheme: ColorScheme(
        primary: colors.main50,
        primaryVariant: colors.main50,
        secondary: colors.main10,
        secondaryVariant: colors.main10,
        surface: colors.light100,
        background: colors.light100,
        error: colors.main50,
        onPrimary: colors.onMain50,
        onSecondary: colors.onMain10,
        onSurface: colors.dark87,
        onBackground: colors.dark87,
        onError: colors.onMain50,
        brightness: brightness,
      ),
    );
  }
}
