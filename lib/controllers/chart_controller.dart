import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practical_khazana/api_services/api_service.dart';
import 'package:practical_khazana/models/mutual_fund_model.dart';
import 'package:practical_khazana/models/nav_chart_model.dart';

class ChartController extends GetxController {
  final ApiService _apiService = ApiService();
  var chartData = [].obs;
  var isLoading = false.obs;
  final RxDouble investedAmount = 1.0.obs;
  final RxInt selectedSIPIndex = 0.obs;

  Rx<MutualFundData> selectedFund = MutualFundData().obs;

  final List<String> options = ['1-Time', 'Monthly SIP'];

  final List<String> timeframes = ['1M', '3M', '6M', '1Y', '3Y', 'MAX'];
  RxInt selectedIndex = 0.obs;
  void addChartData(item) {
    chartData.add(item);
  }

  void removeChartData(item) {
    chartData.remove(item);
  }

  void clearChartData() {
    chartData.clear();
  }

  Rx<NavChartModel> navChartModel = NavChartModel().obs;

  fetchHistoryFundList() async {
    isLoading.value = true;
    try {
      // Get the selected timeframe from the controller
      final selectedTimeframe = timeframes[selectedIndex.value];

      // Define the end date as today (May 22, 2025)
      final now = DateTime(2025, 5, 22);
      final endDate = DateFormat('dd-MM-yyyy').format(now);

      // Calculate the start date based on the selected timeframe
      DateTime startDate;
      switch (selectedTimeframe) {
        case '1D':
          startDate = now.subtract(const Duration(days: 1));
          break;
        case '5D':
          startDate = now.subtract(const Duration(days: 5));
          break;
        case '1M':
          startDate = now.subtract(const Duration(days: 30));
          break;
        case '3M':
          startDate = now.subtract(const Duration(days: 90));
          break;
        case '6M':
          startDate = now.subtract(const Duration(days: 180));
          break;
        case '1Y':
          startDate = now.subtract(const Duration(days: 365));
          break;
        case 'YTD':
          startDate = DateTime(now.year, 1, 1); // Start of the year
          break;
        case 'MAX':
          startDate = now.subtract(
            const Duration(days: 365 * 5),
          ); // 5 years ago
          break;
        default:
          startDate = now.subtract(const Duration(days: 30)); // Default to 1M
      }

      final startDateStr = DateFormat('dd-MM-yyyy').format(startDate);
      final timeframe = {"start_date": startDateStr, "end_date": endDate};

      final response = await _apiService.getHistoricalNav(
        schemeCode: selectedFund.value.schemeCode ?? '',
        timeframe: timeframe,
      );
      if (response.statusCode == 200) {
        navChartModel.value = NavChartModel.fromJson(response.data);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
