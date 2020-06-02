import 'refresh_provider.dart';

StateNotifierProvider refreshControllerProvider<V, E>({
  @required RefreshController<V, E> Function(BuildContext context) create,
}) {
  return StateNotifierProvider<RefreshController<V, E>, RefreshState<V, E>>(
    create: (context) => create(context),
  );
}
