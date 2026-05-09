import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/test_management/test_management_screen.dart';
import '../screens/test_management/test_details_screen.dart';
import '../screens/test_management/create_edit_test_screen.dart';
import '../screens/booking/booking_management_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/earning/earning_screen.dart';
import '../screens/earning/earning_details_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/package_management/package_management_screen.dart';
import '../screens/package_management/package_details_screen.dart';
import '../screens/package_management/create_package_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../models/test.dart';
import '../models/package.dart';
import '../models/earning.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String testManagement = '/test-management';
  static const String testDetails = '/test-details';
  static const String bookings = '/bookings';
  static const String profile = '/profile';
  static const String earnings = '/payments';
  static const String earningDetails = '/earning-details';
  static const String createEditTest = '/create-edit-test';
  static const String packageManagement = '/package-management';
  static const String packageDetails = '/package-details';
  static const String createPackage = '/create-package';
  static const String settings = '/settings';
  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
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
        path: createEditTest,
        builder: (context, state) {
          final test = state.extra as LabTest?;
          return CreateEditTestScreen(test: test);
        },
      ),
      GoRoute(
        path: packageManagement,
        builder: (context, state) => const PackageManagementScreen(),
      ),
      GoRoute(
        path: packageDetails,
        builder: (context, state) {
          final package = state.extra as LabPackage;
          return PackageDetailsScreen(package: package);
        },
      ),
      GoRoute(
        path: createPackage,
        builder: (context, state) {
          final package = state.extra as LabPackage?;
          return CreatePackageScreen(package: package);
        },
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
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
