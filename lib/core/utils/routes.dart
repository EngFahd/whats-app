import 'package:go_router/go_router.dart';
import 'package:whats_app/features/auth/view/login.dart';
import 'package:whats_app/features/home/view/home.dart';
import 'package:whats_app/features/splash/splash_view.dart';

const String kSplashView = '/';
const String kLoginhView = '/login';
const String kHome = '/home';

class AppRouters {
  static final routes = GoRouter(routes: [
    GoRoute(
      path: kSplashView,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: kLoginhView,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: kHome,
      builder: (context, state) => const Home(),
    ),
  ]);
}
