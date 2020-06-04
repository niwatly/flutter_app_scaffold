class SplashScreenState {
  final bool needAuthorization;
  final bool needNavigate;
  final bool isLaunchingLoginScreen;

  const SplashScreenState({
    this.needAuthorization = false,
    this.needNavigate = false,
    this.isLaunchingLoginScreen = false,
  });
}
