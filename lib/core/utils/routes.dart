import 'package:go_router/go_router.dart';
import 'package:whats_app/widgets/chat_list_view.dart';
import 'package:whats_app/screen/login.dart';
import 'package:whats_app/screen/home.dart';
import 'package:whats_app/screen/profil.dart';
import 'package:whats_app/screen/splash_view.dart';

const String kSplashView = '/';
const String kLoginhView = '/login';
const String kHome = '/home';
const String kChat = '/chat';
const String kProfile = '/profile';

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
    GoRoute(
      path: kHome,
      builder: (context, state) =>  Chat(),),
    GoRoute(
      path: kProfile,
      builder: (context, state) => const Profil(),
    ),
  ]);
}
