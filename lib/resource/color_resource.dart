import 'dart:ui';

import 'package:flutter/material.dart';

extension ColorSchemeEx on ColorScheme {
  Color get alto10 => ColorResource(brightness).alto10;
  Color get alto20 => ColorResource(brightness).alto20;
  Color get main50 => ColorResource(brightness).main50;
  Color get main20 => ColorResource(brightness).main20;
  Color get main10 => ColorResource(brightness).main10;
  Color get dark12 => ColorResource(brightness).dark12;
  Color get dark26 => ColorResource(brightness).dark26;
  Color get dark54 => ColorResource(brightness).dark54;
  Color get dark87 => ColorResource(brightness).dark87;
  Color get light12 => ColorResource(brightness).light12;
  Color get light30 => ColorResource(brightness).light30;
  Color get light70 => ColorResource(brightness).light70;
  Color get light100 => ColorResource(brightness).light100;
  Color get bgModal => ColorResource(brightness).bgModal;
  Color get onMain50 => ColorResource(brightness).onMain50;
  Color get onMain10 => ColorResource(brightness).onMain10;
  Color get red50 => ColorResource(brightness).red50;
}

class ColorResource {
  final Color alto10;
  final Color alto20;
  final Color main50;
  final Color main20;
  final Color main10;
  final Color red50;
  final Color dark12;
  final Color dark26;
  final Color dark54;
  final Color dark87;
  final Color light12;
  final Color light30;
  final Color light70;
  final Color light100;

  final Color bgModal;

  Color get onMain50 => _light100;
  Color get onMain10 => dark54;

  const ColorResource._({
    this.alto10,
    this.alto20,
    this.main50,
    this.main20,
    this.main10,
    this.red50,
    this.dark12,
    this.dark26,
    this.dark54,
    this.dark87,
    this.light12,
    this.light30,
    this.light70,
    this.light100,
    this.bgModal = const Color(0x40000000),
  });

  static ColorResource _dark;
  static ColorResource _light;

  factory ColorResource(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        return _dark ??= const ColorResource.dark();
      case Brightness.light:
      default:
        return _light ??= const ColorResource.light();
    }
  }

  const ColorResource.dark()
      : this._(
    alto10: _alto10Dark,
    alto20: _alto20Dark,
    main10: _main10Dark,
    main20: _main20,
    main50: _main50,
    red50: _red50,
    dark12: _light12,
    dark26: _light30,
    dark54: _light70,
    dark87: _light100,
    light12: _dark12,
    light30: _dark26,
    light70: _dark54,
    light100: _dark87,
  );

  const ColorResource.light()
      : this._(
    alto10: _alto10,
    alto20: _alto20,
    main10: _main10,
    main20: _main20,
    main50: _main50,
    red50: _red50,
    dark12: _dark12,
    dark26: _dark26,
    dark54: _dark54,
    dark87: _dark87,
    light12: _light12,
    light30: _light30,
    light70: _light70,
    light100: _light100,
  );

  static const Color _alto10 = Color(0xfffbfcfb);
  static const Color _alto20 = Color(0xfff2f2f2);
  static const Color _alto10Dark = Color(0xff2b2527);
  static const Color _alto20Dark = Color(0xff473d40);
  static const Color _main50 = Color(0xffe8699d);
  static const Color _main20 = Color(0xffffe5f0);
  static const Color _main10 = Color(0xfffef1f6);
  static const Color _main10Dark = Color(0xff7A5866);
  static const Color _red50 = Color(0xffff6150);
  static const Color _light100 = Color(0xffffffff);
  static const Color _light70 = Color(0xb3ffffff);
  static const Color _light30 = Color(0x3dffffff);
  static const Color _light12 = Color(0x1effffff);
  static const Color _dark12 = Color(0x1e000000);
  static const Color _dark26 = Color(0x42000000);
  static const Color _dark54 = Color(0x8a000000);
  static const Color _dark87 = Color(0xdf000000);
}
