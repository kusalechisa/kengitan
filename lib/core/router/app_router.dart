import 'package:go_router/go_router.dart';
import 'package:kengitan/features/onboarding/presentation/pages/home_page.dart';
import 'package:kengitan/features/onboarding/presentation/pages/profile_setup_page.dart';
import 'package:kengitan/features/onboarding/presentation/pages/welcome_page.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
