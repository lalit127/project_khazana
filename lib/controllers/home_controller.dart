import 'package:get/get.dart';
import 'package:practical_khazana/models/mutual_fund_model.dart';
import 'package:practical_khazana/utils/app_preferences.dart';

class HomeController extends GetxController {
  RxMap<String, List<MutualFundData>> mutualWatchList =
      <String, List<MutualFundData>>{}.obs;

  final List<Map<String, dynamic>> fundPerformanceList = [
    {
      'fundName': 'Axis Bluechip Fund',
      'investedAmount': '₹50,000',
      'currentValue': '₹63,500',
      'returns': '27%',
      'profit': '₹13,500',
    },
    {
      'fundName': 'HDFC Small Cap Fund',
      'investedAmount': '₹30,000',
      'currentValue': '₹39,200',
      'returns': '30.6%',
      'profit': '₹9,200',
    },
    {
      'fundName': 'ICICI Value Discovery Fund',
      'investedAmount': '₹20,000',
      'currentValue': '₹23,400',
      'returns': '17%',
      'profit': '₹3,400',
    },
  ];

  RxBool isLoading = false.obs;

  Future<void> getWatchList() async {
    isLoading.value = true;
    try {
      final tempWatchList = await AppPreference.getStringListValuesSF(
        'watch_list_tab',
      );
      print("temp==>${tempWatchList.length}");
      if (tempWatchList.isNotEmpty) {
        mutualWatchList.addAll(
          tempWatchList.asMap().map((key, value) => MapEntry(value, [])),
        );
        for (var item in tempWatchList) {
          await getMutualFundWatchList(item);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMutualFundWatchList(String item) async {
    final mKey = item;
    final tempMutualWatchList = await AppPreference.getMutualFundWatchList(
      mKey,
    );
    if (tempMutualWatchList.isNotEmpty) {
      mutualWatchList[item] = tempMutualWatchList; // Directly assign the list
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getWatchList();
  }
}
