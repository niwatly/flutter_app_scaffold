import 'package:flutter_app_scaffold/common.dart';
import 'package:flutter_app_components/utility/extension.dart';
import 'package:flutter_app_scaffold/controller/app/app_controller.dart';
import 'package:flutter_app_scaffold/controller/session/session_state.dart';
import 'package:flutter_app_scaffold/controller/splash/splash_screen_state.dart';
import 'package:flutter_app_scaffold/screen/screen_arguments.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../environment.dart';

class SplashScreenController extends StateNotifier<SplashScreenState> with LocatorMixin {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  SplashScreenController() : super(const SplashScreenState());

  @override
  void initState() {
    super.initState();

    final stream = asStream();

    // ログインの要求状態が変化した時、変化後の状態がtrueなら、ログイン画面を開く（開いている間は後続のリクエストを無視する）
    // また、ログイン画面を開いている間は[state.isLaunchingLoginScreen]をtrueにする
    stream.distinct((rhs, lhs) => rhs.needAuthorization == lhs.needAuthorization).where((x) => x.needAuthorization).exhaustMap((x) async* {
      if (x.needAuthorization) {
        yield true;
        await read<AppController>().showScreen(const LoginScreenArguments());

        yield false;
      }
    }).listen((x) {
      state = SplashScreenState(
        needAuthorization: state.needAuthorization,
        needNavigate: state.needNavigate,
        isLaunchingLoginScreen: x,
      );
    })
      ..addTo(_compositeSubscription);

    // ログイン画面を開いていないかつ画面遷移が要求されていたら、一度だけ、次の画面に遷移する
    //
    // Note: clean: trueを指定することでSplashScreenを合わせて閉じるようにしている
    stream.where((x) => !x.isLaunchingLoginScreen && x.needNavigate).take(1).listen((x) async {
      final env = read<Environment>();

      final home = env.debugCondition.homeScreenArguments ?? const HomeScreenArguments();

      read<AppController>().showScreen(
        home,
        clean: true,
      );
    })
      ..addTo(_compositeSubscription);
  }

  @override
  void update(T Function<T>() watch) {
    final sessionState = watch<SessionState>();

    state = SplashScreenState(
      needAuthorization: sessionState.hasError,
      needNavigate: sessionState.hasSession,
      isLaunchingLoginScreen: state.isLaunchingLoginScreen,
    );
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();

    super.dispose();
  }
}
