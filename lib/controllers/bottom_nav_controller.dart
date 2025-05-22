import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/modules/charts/chart_screen.dart';
import 'package:practical_khazana/modules/home/home_screen.dart';
import 'package:practical_khazana/modules/watchlist/watch_list_screen.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  final List<BottomNavModel> pages = [
    BottomNavModel(
      icon: Assets.icons.icHome,
      label: 'Home',
      page: HomeScreen(),
    ),
    BottomNavModel(
      icon: Assets.icons.icCharts,
      label: 'Charts',
      page: ChartScreen(),
    ),
    BottomNavModel(
      icon: Assets.icons.icWatchlist,
      label: 'Watchlist',
      page: WatchListScreen(),
    ),
  ];

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}

class BottomNavModel {
  final String icon;
  final String label;
  final Widget page;

  BottomNavModel({required this.icon, required this.label, required this.page});
}
