import 'package:flutter/widgets.dart';

class AppNavigatorObserver with NavigatorObserver {
  final List<RouteSettings> _settings = [];

  RouteSettings get lastOrNull => _settings.isNotEmpty ? _settings.last : null;

  RouteSettings get firstOrNull => _settings.isNotEmpty ? _settings.first : null;

  bool contains(String name) => _settings.any((x) => x.name == name);

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    _settings.add(route.settings);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    _settings.removeLast();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    _settings.removeWhere((x) => x.name == route.settings.name);
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    final index = _settings.indexWhere((x) => x.name == oldRoute.settings.name);
    if (index >= 0) {
      _settings[index] = newRoute.settings;
    }
  }
}
