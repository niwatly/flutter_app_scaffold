import 'refresh_provider.dart';

class RefreshSelector<V, E> extends StatelessWidget {
  static Widget Function(BuildContext context) defaultOnLoading = (context) => const CircularProgressIndicator();

  final Widget Function(BuildContext context, V value) onValue;
  final Widget Function(BuildContext context, E error) onError;
  final Widget Function(BuildContext context) onLoading;

  final bool enablePullRefresh;
  final bool disableLoading;
  final StackFit fit;
  final RefreshController<V, E> Function(BuildContext context) controller;

  const RefreshSelector({
    @required this.onValue,
    this.onError,
    this.onLoading,
    this.controller,
    this.enablePullRefresh = false,
    this.disableLoading = false,
    this.fit = StackFit.passthrough,
  });

  @override
  Widget build(BuildContext context) {
    Widget ret = Stack(
      fit: fit,
      children: [
        Selector<RefreshState<V, E>, E>(
          selector: (context, x) => x.value == null ? x.error : null,
          builder: (context, value, child) => value != null && onError != null
              ? onError(context, value)
              : const SizedBox(width: 0, height: 0),
        ),
        Selector<RefreshState<V, E>, V>(
          selector: (context, x) => x.value,
          builder: (context, value, child) => value != null
              ? onValue(context, value)
              : const SizedBox(width: 0, height: 0),
        ),
        Selector<RefreshState<V, E>, bool>(
          selector: (context, x) => x.isRefreshing && !disableLoading,
          builder: (context, value, child) => AnimatedOpacity(
            opacity: value ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: onLoading != null ? onLoading(context) : defaultOnLoading,
          ),
        ),
      ],
    );

    if (enablePullRefresh) {
      ret = _Refresh<V, E>(ret);
    }

    if (controller != null) {
      ret = StateNotifierProvider<RefreshController<V, E>,
          RefreshState<V, E>>.value(
        value: controller(context),
        child: ret,
      );
    }

    return ret;
  }
}

class _Refresh<V, E> extends SingleChildStatelessWidget {
  const _Refresh(Widget child) : super(child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return RefreshIndicator(
      onRefresh: () => context
          .read<RefreshController<V, E>>()
          .requestCleanRefresh(silent: true),
      child: child,
    );
  }
}
