import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/earning/customer_earning_details_screen.dart' show EarningDetailsScreen;
import '../screens/test_management/test_management_screen.dart';
import '../screens/test_management/test_details_screen.dart';
import '../screens/test_management/create_edit_test_screen.dart';
import '../screens/booking/booking_management_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/earning/earning_screen.dart';
import '../screens/earning/company_earning_history_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/package_management/package_management_screen.dart';
import '../screens/package_management/package_details_screen.dart';
import '../screens/package_management/create_package_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/settings/about_us_screen.dart';
import '../screens/settings/terms_conditions_screen.dart';
import '../screens/settings/privacy_policy_screen.dart';
import '../screens/medicine_mangement/medicine_mangement_screen.dart';
import '../screens/medicine_mangement/medicine_details_screen.dart';
import '../screens/medicine_mangement/add_medicine_inventory_screen.dart';
import '../screens/medicine_mangement/add_new_medicine_screen.dart';
import '../models/test.dart';
import '../models/package.dart';
import '../models/earning.dart';
import '../models/medicine.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String testManagement = '/test-management';
  static const String testDetails = '/test-details';
  static const String bookings = '/bookings';
  static const String profile = '/profile';
  static const String earnings = '/payments';
  static const String companyEarnings = '/company-earnings';
  static const String earningDetails = '/earning-details';
  static const String medicineManagement = '/medicine-management';
  static const String medicineDetails = '/medicine-details';
  static const String addMedicineInventory = '/add-medicine-inventory';
  static const String addNewMedicine = '/add-new-medicine';
  static const String createEditTest = '/create-edit-test';
  static const String packageManagement = '/package-management';
  static const String packageDetails = '/package-details';
  static const String createPackage = '/create-package';
  static const String settings = '/settings';
  static const String aboutUs = '/about-us';
  static const String termsConditions = '/terms-conditions';
  static const String privacyPolicy = '/privacy-policy';
  
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
        path: companyEarnings,
        builder: (context, state) => const CompanyEarningHistoryScreen(),
      ),
      GoRoute(
        path: earningDetails,
        builder: (context, state) {
          final earning = state.extra as Earning;
          return EarningDetailsScreen(earning: earning);
        },
      ),
      GoRoute(
        path: medicineManagement,
        builder: (context, state) => const MedicineManagementScreen(),
      ),
      GoRoute(
        path: medicineDetails,
        builder: (context, state) {
          final medicine = state.extra as Medicine;
          return MedicineDetailsScreen(medicine: medicine);
        },
      ),
      GoRoute(
        path: addMedicineInventory,
        builder: (context, state) => const AddMedicineInventoryScreen(),
      ),
      GoRoute(
        path: addNewMedicine,
        builder: (context, state) => const AddNewMedicineScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: aboutUs,
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: termsConditions,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );
}
