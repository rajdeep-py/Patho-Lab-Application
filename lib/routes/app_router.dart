import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/test_management/test_management_screen.dart';
import '../screens/test_management/test_details_screen.dart';
import '../screens/test_management/pick_test_screen.dart';
import '../screens/booking/booking_management_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/earning/earning_screen.dart';
import '../screens/earning/earning_details_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../models/test.dart';
import '../models/earning.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String testManagement = '/test-management';
  static const String testDetails = '/test-details';
  static const String pickTest = '/pick-test';
  static const String bookings = '/bookings';
  static const String profile = '/profile';
  static const String earnings = '/payments';
  static const String earningDetails = '/earning-details';

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: testManagement,
        builder: (context, state) => const TestManagementScreen(),
      ),
      GoRoute(
        path: testDetails,
        builder: (context, state) {
          final test = state.extra as LabTest;
          return TestDetailsScreen(test: test);
        },
      ),
      GoRoute(
        path: pickTest,
        builder: (context, state) => const PickTestScreen(),
      ),
      GoRoute(
        path: bookings,
        builder: (context, state) => const BookingManagementScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: earnings,
        builder: (context, state) => const EarningScreen(),
      ),
      GoRoute(
        path: earningDetails,
        builder: (context, state) {
          final earning = state.extra as Earning;
          return EarningDetailsScreen(earning: earning);
        },
      ),
    ],
  );
}
