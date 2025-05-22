import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/controllers/chart_controller.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/models/mutual_fund_model.dart';
import 'package:practical_khazana/modules/charts/investment_screen.dart';
import 'package:practical_khazana/utils/base_extensions.dart';

class ChartScreen extends StatefulWidget {
  ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final controller = Get.put<ChartController>(ChartController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MutualFundData fundData = Get.arguments['fund'];
      controller.selectedFund.value = fundData;
      controller.fetchHistoryFundList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(
        () => SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.black,
                pinned: false,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // final bottomNavController =
                        //     Get.find<BottomNavController>();
                        // bottomNavController.changeTabIndex(0);
                        Get.back();
                      },
                      child: SvgPicture.asset(Assets.icons.icArrowLeft),
                    ),
                  ],
                ),
                actions: [
                  SvgPicture.asset(
                    Assets.icons.icAddWatchList,
                    height: 15,
                  ).paddingSymmetric(horizontal: 24),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * 0.6,
                      child: Obx(
                        () => Text(
                          controller.selectedFund.value.schemeName ?? '',
                          style: AppTextStyles(context).display18W400.copyWith(
                            color: AppColors.appWhiteColor,
                          ),
                        ),
                      ),
                    ),
                    8.0.toVSB,
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Nav ',
                            children: [
                              TextSpan(
                                text:
                                    '₹ ${controller.navChartModel.value.latestNav ?? '12.2'}',
                                children: [
                                  WidgetSpan(child: 10.0.toHSB),
                                  WidgetSpan(
                                    child: Container(
                                      color: AppColors.grayDark,
                                      height: 17,
                                      width: 0.7,
                                    ),
                                  ),
                                  WidgetSpan(child: 10.0.toHSB),
                                  TextSpan(
                                    text: '1D ',
                                    children: [
                                      TextSpan(
                                        text:
                                            '₹ ${(controller.selectedFund.value.currentNav != null && controller.selectedFund.value.returns?.i1d != null) ? ((controller.selectedFund.value.currentNav! * controller.selectedFund.value.returns!.i1d!) / 100).toStringAsFixed(2) : '0.00'}',
                                        style: AppTextStyles(
                                          context,
                                        ).display14W400.copyWith(
                                          color: AppColors.appWhiteColor,
                                        ),
                                      ),
                                    ],
                                    style: AppTextStyles(context).display12W400
                                        .copyWith(color: AppColors.grayDark),
                                  ),
                                  WidgetSpan(child: 10.0.toHSB),
                                  WidgetSpan(
                                    child: Transform.rotate(
                                      alignment: Alignment.center,
                                      angle: true ? 3.14 : 0,
                                      child: SvgPicture.asset(
                                        Assets.icons.icCaratDown,
                                        color:
                                            true
                                                ? AppColors.success
                                                : AppColors.danger,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' 3.7',
                                    style: AppTextStyles(
                                      context,
                                    ).display14W400.copyWith(
                                      color:
                                          true
                                              ? AppColors.success
                                              : AppColors.danger,
                                    ),
                                  ),
                                ],
                                style: AppTextStyles(context).display14W400
                                    .copyWith(color: AppColors.appWhiteColor),
                              ),
                            ],
                            style: AppTextStyles(
                              context,
                            ).display12W400.copyWith(color: AppColors.grayDark),
                          ),
                        ),
                      ],
                    ),
                    24.0.toVSB,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff3D3D3D),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildValueColumn('Invested', '₹1.5k'),
                          _verticalDivider(),
                          _buildValueColumn(
                            'Current Value',
                            '₹${controller.navChartModel.value.latestNav ?? '0.00'}',
                          ),
                          _verticalDivider(),
                          _buildGainColumn(),
                        ],
                      ),
                    ),
                    10.0.toVSB,
                    Row(
                      children: [
                        Column(
                          children: [
                            // buildTitleWithGain(
                            //   title: 'Your Investments',
                            //   gain: '-19.75',
                            //   color: AppColors.primaryColor,
                            // ),
                            // 4.0.toVSB,
                            buildTitleWithGain(
                              title: 'NAV',
                              gain:
                                  '₹ ${controller.navChartModel.value.historicalData?.last.dayChange ?? '12.2'}',
                              color: AppColors.appWhiteColor,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff6D6D6D),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'NAV',
                              style: AppTextStyles(context).display10W400
                                  .copyWith(color: const Color(0xff6D6D6D)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    16.0.toVSB,
                    Obx(
                      () => Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child:
                                controller.isLoading.value
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : controller.navChartModel.value == null ||
                                        controller
                                                .navChartModel
                                                .value
                                                .historicalData ==
                                            null ||
                                        controller
                                            .navChartModel
                                            .value
                                            .historicalData!
                                            .isEmpty
                                    ? const Center(
                                      child: Text(
                                        'No data available',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                    : LineChart(
                                      LineChartData(
                                        gridData: const FlGridData(show: false),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 24,
                                              interval:
                                                  1, // Keep interval at 1 for precise control
                                              getTitlesWidget: (value, meta) {
                                                // Map the x-axis value (index) to a date
                                                final int index = value.toInt();
                                                if (index < 0 ||
                                                    index >=
                                                        controller
                                                            .navChartModel
                                                            .value
                                                            .historicalData!
                                                            .length) {
                                                  return const SizedBox.shrink();
                                                }

                                                // Calculate dynamic interval to show ~4-5 labels
                                                final dataLength =
                                                    controller
                                                        .navChartModel
                                                        .value
                                                        .historicalData!
                                                        .length;
                                                final labelInterval =
                                                    (dataLength / 4)
                                                        .ceil(); // Aim for ~4 labels

                                                // Show label if index is a multiple of labelInterval or the last index
                                                final isLastIndex =
                                                    index == dataLength - 1;
                                                if (index % labelInterval !=
                                                        0 &&
                                                    !isLastIndex) {
                                                  return const SizedBox.shrink();
                                                }

                                                final dateStr =
                                                    controller
                                                        .navChartModel
                                                        .value
                                                        .historicalData![index]
                                                        .date ??
                                                    '';
                                                // Parse the date (format: DD-MM-YYYY) and format it for display
                                                try {
                                                  final date = DateFormat(
                                                    'dd-MM-yyyy',
                                                  ).parse(dateStr);

                                                  // Determine the label format based on the selected timeframe
                                                  final selectedTimeframe =
                                                      controller
                                                          .timeframes[controller
                                                          .selectedIndex
                                                          .value];
                                                  String labelFormat;
                                                  switch (selectedTimeframe) {
                                                    case '1D':
                                                      labelFormat =
                                                          'dd MMM HH:mm'; // Date and time for 1D
                                                      break;
                                                    case '5D':
                                                      labelFormat =
                                                          'dd MMM'; // Day and month for 5D
                                                      break;
                                                    case '1M':
                                                    case '3M':
                                                    case '6M':
                                                      labelFormat =
                                                          'dd MMM'; // Day and month
                                                      break;
                                                    case '1Y':
                                                      labelFormat =
                                                          'MMM \'yy'; // Month and year (e.g., "May '23")
                                                      break;
                                                    case '3Y':
                                                    case '5Y':
                                                    case 'MAX':
                                                      labelFormat =
                                                          'yyyy'; // Only year (e.g., "2023")
                                                      break;
                                                    case 'YTD':
                                                      labelFormat =
                                                          'MMM'; // Only month for YTD
                                                      break;
                                                    default:
                                                      labelFormat = 'MMM';
                                                  }

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 4,
                                                        ),
                                                    child: Text(
                                                      DateFormat(
                                                        labelFormat,
                                                      ).format(date),
                                                      style: AppTextStyles(
                                                        context,
                                                      ).display10W400.copyWith(
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                } catch (e) {
                                                  return const SizedBox.shrink();
                                                }
                                              },
                                            ),
                                          ),
                                          leftTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(show: false),
                                        clipData: const FlClipData(
                                          bottom:
                                              false, // Prevent clipping of bottom labels
                                          top: false,
                                          left: false,
                                          right: false,
                                        ),
                                        extraLinesData: const ExtraLinesData(
                                          extraLinesOnTop: false,
                                          horizontalLines: [],
                                          verticalLines: [],
                                        ),
                                        lineTouchData: LineTouchData(
                                          enabled: true,
                                          handleBuiltInTouches: true,
                                          touchTooltipData: LineTouchTooltipData(
                                            tooltipPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                            tooltipMargin: 8,
                                            tooltipBorder: const BorderSide(
                                              color: AppColors.primaryColor,
                                              width: 0.5,
                                            ),
                                            tooltipBorderRadius:
                                                BorderRadius.circular(12),
                                            getTooltipColor: (touchedSpot) {
                                              return const Color(0xff262626);
                                            },
                                            fitInsideHorizontally: true,
                                            fitInsideVertically: true,
                                            getTooltipItems: (
                                              List<LineBarSpot> touchedSpots,
                                            ) {
                                              return touchedSpots.map((spot) {
                                                final index = spot.x.toInt();
                                                final nav =
                                                    controller
                                                        .navChartModel
                                                        .value
                                                        .historicalData![index]
                                                        .nav;
                                                final dayChange =
                                                    controller
                                                        .navChartModel
                                                        .value
                                                        .historicalData![index]
                                                        .dayChange;
                                                return LineTooltipItem(
                                                  '${controller.navChartModel.value.historicalData![index].date}\nNAV:${nav?.toStringAsFixed(2)}',
                                                  AppTextStyles(
                                                    context,
                                                  ).display9W400.copyWith(
                                                    color: Colors.white,
                                                    height:
                                                        1.5, // Adjust line height for better spacing
                                                  ),
                                                );
                                              }).toList();
                                            },
                                          ),
                                          getTouchedSpotIndicator: (
                                            LineChartBarData barData,
                                            List<int> spotIndexes,
                                          ) {
                                            return spotIndexes.map((index) {
                                              return const TouchedSpotIndicatorData(
                                                FlLine(
                                                  color: AppColors.primaryColor,
                                                  strokeWidth: 1,
                                                ),
                                                FlDotData(show: false),
                                              );
                                            }).toList();
                                          },
                                        ),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: List.generate(
                                              controller
                                                  .navChartModel
                                                  .value
                                                  .historicalData!
                                                  .length,
                                              (index) {
                                                final dayChange =
                                                    controller
                                                        .navChartModel
                                                        .value
                                                        .historicalData![index]
                                                        .dayChange;
                                                final scaledValue =
                                                    (dayChange ?? 0.0) * 1000;
                                                final navValues =
                                                    controller
                                                        .navChartModel
                                                        .value
                                                        .historicalData!
                                                        .map(
                                                          (data) =>
                                                              data.nav ?? 0.0,
                                                        )
                                                        .toList();
                                                final navMin = navValues.reduce(
                                                  (a, b) => a < b ? a : b,
                                                );
                                                final navMax = navValues.reduce(
                                                  (a, b) => a > b ? a : b,
                                                );
                                                final navMid =
                                                    (navMin + navMax) / 2;
                                                final offsetValue =
                                                    navMid + scaledValue;
                                                return FlSpot(
                                                  index.toDouble(),
                                                  offsetValue,
                                                );
                                              },
                                            ),
                                            isCurved: true,
                                            color: AppColors.appWhiteColor,
                                            barWidth: 1.5,
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                colors: [
                                                  AppColors.appWhiteColor
                                                      .withOpacity(0.5),
                                                  Colors.transparent,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            dotData: const FlDotData(
                                              show: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    12.0.toVSB,
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF2A2A2A),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(
                        () => Row(
                          children: List.generate(
                            controller.timeframes.length,
                            (index) {
                              final isSelected =
                                  controller.selectedIndex.value == index;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectedIndex.value = index;
                                    controller.fetchHistoryFundList();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? AppColors.primaryColor
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      controller.timeframes[index],
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : const Color(0xFF6D6D6D),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    12.0.toVSB,
                    // Past Returns Bar Chart
                    InvestmentScreen(),
                    12.0.toVSB,
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Sell ↓',
                              style: AppTextStyles(context).display14W400
                                  .copyWith(color: AppColors.appWhiteColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Invest More ↑',
                              style: AppTextStyles(context).display14W400
                                  .copyWith(color: AppColors.appWhiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 24),
              ),
              const SliverToBoxAdapter(child: Column(children: [])),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper for text columns
  Widget _buildValueColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles(
            context,
          ).display12W400.copyWith(color: const Color(0xff6D6D6D)),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles(
            context,
          ).display14W400.copyWith(color: AppColors.appWhiteColor),
        ),
      ],
    );
  }

  /// Divider between items
  Widget _verticalDivider() {
    return Container(
      height: 32,
      width: 1,
      color: const Color(0xff888888).withOpacity(0.3),
    );
  }

  /// Special for Total Gain column
  Widget _buildGainColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Total Gain',
          style: AppTextStyles(
            context,
          ).display12W400.copyWith(color: const Color(0xff6D6D6D)),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              '₹-220.16',
              style: AppTextStyles(
                context,
              ).display14W400.copyWith(color: AppColors.appWhiteColor),
            ),
            4.0.toHSB,
            SvgPicture.asset(Assets.icons.icCaratDown, height: 9),
            4.0.toHSB,
            Text(
              '-14.7',
              style: AppTextStyles(
                context,
              ).display14W400.copyWith(color: const Color(0xffDE504B)),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTitleWithGain({String? title, String? gain, Color? color}) {
    return Row(
      children: [
        Container(width: 16, height: 1, color: color),
        9.0.toHSB,
        Text(
          title ?? '',
          style: AppTextStyles(context).display10W400.copyWith(color: color),
        ),
        9.0.toHSB,
        Text(
          '$gain%',
          style: AppTextStyles(context).display12W400.copyWith(color: color),
        ),
      ],
    );
  }
}
