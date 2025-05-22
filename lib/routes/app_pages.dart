import 'package:practical_khazana/bindings/bindings.dart';
import 'package:practical_khazana/modules/auth/auth_screen.dart';
import 'package:practical_khazana/modules/auth/otp_screen.dart';
import 'package:practical_khazana/modules/charts/chart_screen.dart';
import 'package:practical_khazana/modules/dashboard/dashboard_screen.dart';
import 'package:practical_khazana/modules/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/modules/onboard/onboard_screen.dart';
import 'package:practical_khazana/modules/splash/splash_screen.dart';
import 'package:practical_khazana/modules/watchlist/watch_list_screen.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;
  static const splash = Routes.splash;
  static const onboard = Routes.onboard;
  static const auth = Routes.auth;
  static const otp = Routes.otp;
  static const dashboard = Routes.dashboard;
  static const home = Routes.home;
  static const watchList = Routes.watchList;
  static const chart = Routes.chart;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.onboard,
      page: () => const OnboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.auth,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.otp,
      page: () => const OtpScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomeScreen(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.watchList,
      page: () => WatchListScreen(),
      binding: WatchListBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.chart,
      page: () => ChartScreen(),
      binding: ChartBinding(),
      transition: Transition.fadeIn,
    ),
    // GetPage(
    //   name: _Paths.interest,
    //   page: () => InterestScreen(),
    //   binding: InterestBinding(),
    //   transition: Transition.rightToLeft,
    // ),
  ];
}
