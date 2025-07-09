import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/emergency_request_screen/emergency_request_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/blood_search_screen/blood_search_screen.dart';
import '../presentation/notifications_screen/notifications_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/donation_history_screen/donation_history_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String emergencyRequestScreen = '/emergency-request-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String registrationScreen = '/registration-screen';
  static const String bloodSearchScreen = '/blood-search-screen';
  static const String notificationsScreen = '/notifications-screen';
  static const String userProfileScreen = '/user-profile-screen';
  static const String donationHistoryScreen = '/donation-history-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => SplashScreen(),
    splashScreen: (context) => SplashScreen(),
    loginScreen: (context) => LoginScreen(),
    emergencyRequestScreen: (context) => EmergencyRequestScreen(),
    homeDashboard: (context) => HomeDashboard(),
    registrationScreen: (context) => RegistrationScreen(),
    bloodSearchScreen: (context) => BloodSearchScreen(),
    notificationsScreen: (context) => const NotificationsScreen(),
    userProfileScreen: (context) => const UserProfileScreen(),
    donationHistoryScreen: (context) => const DonationHistoryScreen(),
    // TODO: Add your other routes here
  };
}
