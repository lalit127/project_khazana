import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/api_services/api_service.dart';
import 'package:practical_khazana/models/mutual_fund_model.dart';
import 'package:practical_khazana/utils/app_preferences.dart';
import 'package:practical_khazana/utils/app_toast.dart';

class WatchListController extends GetxController {
  final ApiService _apiService = ApiService();

  var watchList = [].obs;

  var selectedIndex = 0.obs;
  var currentPage = 1.obs;

  var searchWatchListController = TextEditingController();
  var watchListName = TextEditingController();
  var updateWatchListName = TextEditingController();
  RxBool enableWatchList = false.obs;
  RxBool isNewWatchList = false.obs;
  RxBool isEditWatchListName = false.obs;
  RxBool isAddNewWatchList = false.obs;
  RxBool isPaginated = false.obs;
  RxBool isAddToMoreWatchlist = false.obs;

  // Timer? _debounce;
  void onSearchChanged(String value) {
    fetchMutualFundList(1, query: value);
  }

  void changeTab(int index) {
    selectedIndex.value = index;
    currentPage.value = 1;
    isAddNewWatchList.value = false;
    isAddToMoreWatchlist.value = false;
    mutualFundList.clear();
    mutualWatchFundList.clear();
    isLoading.value = false;
    isPaginated.value = false;
    // filterMutualFundList.clear();
    getMutualFundWatchList(watchList[index]);
  }

  void addToWatchList() {
    bool isWatchListExists = watchList.contains(watchListName.text);
    if (!isWatchListExists) {
      watchList.add(watchListName.text);
      saveWatchListName();
      watchList.refresh();
      AppToast.showSuccess(
        title: 'Added',
        description: '${watchListName.text} has been added to watchlist',
      );
      Get.back();
      resetWatchData();
    } else {
      AppToast.showError(
        title: 'Already exists',
        description: '${watchListName.text} is already exist in watchlist',
      );
    }
  }

  void updateWatchList() {
    final tempWatchIndex = watchList.indexOf(updateWatchListName.text);
    watchList[tempWatchIndex] = watchListName.text;
    watchList.refresh();
    saveWatchListName();
    AppToast.showSuccess(
      title: 'Update',
      description:
          '${updateWatchListName.text} updated to ${watchListName.text}',
    );
    Get.back();
    resetWatchData();
  }

  void removeFromWatchList(item) {
    watchList.remove(item);
  }

  void clearWatchList() {
    watchList.clear();
  }

  resetWatchData() {
    enableWatchList.value = false;
    isNewWatchList.value = false;
    isEditWatchListName.value = false;
    watchListName.clear();
    updateWatchListName.clear();
  }

  // void filterWatchList(String query) {
  //   if (query.isEmpty) {
  //     filterMutualFundList.assignAll(mutualFundList);
  //   } else {
  //     filterMutualFundList.assignAll(
  //       mutualFundList.where(
  //         (item) => (item.schemeName ?? '').toLowerCase().contains(
  //           query.toLowerCase(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  RxBool isLoading = false.obs;

  RxList<MutualFundData> mutualFundList = <MutualFundData>[].obs;
  RxList<MutualFundData> mutualWatchFundList = <MutualFundData>[].obs;
  // RxList<MutualFundData> filterMutualFundList = <MutualFundData>[].obs;

  fetchMutualFundList(int pageSize, {String? query, bool? isPaginated}) async {
    isLoading.value = true;
    // isAddToMoreWatchlist.value = true;
    if (query?.isNotEmpty == true) {
      mutualFundList.clear();
    }
    try {
      final response = await _apiService.getMutualFunds(
        page: pageSize,
        query: query ?? '',
      );
      if (response.statusCode == 200) {
        final tempData = MutualFundData().fromDecodedJsonList(
          response.data['schemes'],
        );
        if (isPaginated == true) {
          mutualFundList.addAll(tempData);
        } else {
          mutualFundList.assignAll(tempData);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMutualFundToWatchList(MutualFundData item) async {
    final mKey = watchList[selectedIndex.value];
    final existingList = await AppPreference.getMutualFundWatchList(mKey);

    final alreadyExists = existingList.any(
      (fund) => fund.schemeName == item.schemeName,
    );

    if (alreadyExists) {
      await AppPreference.removeMutualFundFromWatchList(item, mKey);
      AppToast.showError(
        title: 'Already exists',
        description: '${item.schemeName} is already in your watchlist',
      );
    } else {
      existingList.add(item);

      await AppPreference.saveMutualFundToWatchList(existingList, mKey);

      AppToast.showSuccess(
        title: 'Added',
        description: '${item.schemeName} has been added to your watchlist',
      );
      // watchList.add(item.schemeName);
      // filteredWatchList.assignAll(watchList);
      // watchList.refresh();
    }
  }

  Future<void> removeMutualFundFromWatchList(MutualFundData item) async {
    final mKey = watchList[selectedIndex.value];
    mutualWatchFundList.removeWhere(
      (fund) => fund.schemeName == item.schemeName,
    );
    await AppPreference.saveMutualFundToWatchList(mutualWatchFundList, mKey);
  }

  Future<void> getMutualFundWatchList(String item) async {
    final mKey = item;
    final tempMutualWatchList = await AppPreference.getMutualFundWatchList(
      mKey,
    );
    if (tempMutualWatchList.isNotEmpty) {
      mutualWatchFundList.assignAll(tempMutualWatchList);
      mutualWatchFundList.refresh();
      // filterWatchList('');
    }
  }

  saveWatchListName() async {
    await AppPreference.addStringListToSF(
      'watch_list_tab',
      watchList.map((e) => e.toString()).toList(),
    );
  }

  getWatchList() async {
    final tempWatchList = await AppPreference.getStringListValuesSF(
      'watch_list_tab',
    );
    print("temp==>${tempWatchList.length}");
    if (tempWatchList.isNotEmpty) {
      watchList.assignAll(tempWatchList);
      getMutualFundWatchList(tempWatchList.first);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    resetWatchData();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getWatchList();
    watchListName.addListener(() {
      if (watchListName.text.length > 3) {
        enableWatchList.value = true;
      } else {
        enableWatchList.value = false;
      }
    });
  }
}
