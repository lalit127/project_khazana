import 'package:practical_khazana/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/controllers/bottom_nav_controller.dart';
import 'package:practical_khazana/controllers/chart_controller.dart';
import 'package:practical_khazana/controllers/home_controller.dart';
import 'package:practical_khazana/controllers/watch_list_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController());
    Get.lazyPut(() => HomeController());
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class ChartBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChartController());
  }
}

class WatchListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WatchListController());
  }
}
