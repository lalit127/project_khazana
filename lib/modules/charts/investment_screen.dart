import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/controllers/chart_controller.dart';

class InvestmentScreen extends StatelessWidget {
  InvestmentScreen({super.key});

  final controller = Get.find<ChartController>();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff262626),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Text
            Row(
              children: [
                Obx(
                  () => Text(
                    controller.selectedSIPIndex.value == 1
                        ? "If you invested p.m."
                        : "If you invested ",
                    style: AppTextStyles(
                      context,
                    ).display14W400.copyWith(color: Colors.white),
                  ),
                ),
                Obx(
                  () => SizedBox(
                    width: 50,
                    child: TextField(
                      controller: TextEditingController(
                        text: controller.investedAmount.value.toString(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        controller.investedAmount.value =
                            double.tryParse(value) ?? 0;
                      },
                      style: AppTextStyles(context).display14W400.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        prefixText: '₹ ',
                        suffixText:
                            controller.selectedSIPIndex.value == 1 ? 'K' : 'L',
                        // suffixIcon: SvgPicture.asset(
                        //   Assets.icons.icSmallPencil,
                        // ),
                        prefixStyle: AppTextStyles(
                          context,
                        ).display14W400.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        suffixStyle: AppTextStyles(
                          context,
                        ).display14W400.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.grayDark),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.grayDark),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(vertical: 3.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.59),
                      border: Border.all(
                        color: AppColors.grayDark,
                        width: 0.45,
                      ),
                    ),
                    child: Row(
                      children: List.generate(controller.options.length, (
                        index,
                      ) {
                        final isSelected =
                            controller.selectedSIPIndex.value == index;
                        return GestureDetector(
                          onTap: () {
                            controller.investedAmount.value = 1;
                            controller.selectedSIPIndex.value = index;
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              controller.options[index],
                              style: AppTextStyles(
                                context,
                              ).display9W400.copyWith(
                                color:
                                    isSelected
                                        ? AppColors.appWhiteColor
                                        : AppColors.grayDark,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Slider
            Obx(
              () => Slider(
                value: controller.investedAmount.value,
                onChanged: (val) {
                  controller.investedAmount.value = double.parse(
                    val.toStringAsFixed(2),
                  );
                },
                min: 1,
                max: controller.selectedSIPIndex.value == 1 ? 50 : 10,
                activeColor: AppColors.primaryColor,
                inactiveColor: AppColors.primaryColor.withOpacity(0.2),
                padding: EdgeInsets.zero,
              ),
            ),

            // Labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    controller.selectedSIPIndex.value == 1 ? "₹ 1 K" : "₹ 1 L",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                Obx(
                  () => Text(
                    controller.selectedSIPIndex.value == 1
                        ? "₹ 50 K"
                        : "₹ 10 L",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Past Returns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "This Fund's past returns",
                  style: AppTextStyles(
                    context,
                  ).display13W400.copyWith(color: Colors.white),
                ),
                Text(
                  "₹ 3.6 L",
                  style: AppTextStyles(
                    context,
                  ).display13W400.copyWith(color: const Color(0xff4CAF50)),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profit % (Absolute Return)",
                  style: AppTextStyles(
                    context,
                  ).display9W400.copyWith(color: const Color(0xff5D5D5D)),
                ),
                Text(
                  "355.3%",
                  style: AppTextStyles(
                    context,
                  ).display9W400.copyWith(color: const Color(0xffD1D1D1)),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bar Chart
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          switch (value.toInt()) {
                            case 0:
                              return Text(
                                "Saving A/C",
                                style: AppTextStyles(
                                  context,
                                ).display9W400.copyWith(color: Colors.white),
                              ).paddingSymmetric(vertical: 6);
                            case 1:
                              return Text(
                                "Category Avg.",
                                style: AppTextStyles(
                                  context,
                                ).display9W400.copyWith(color: Colors.white),
                              ).paddingSymmetric(vertical: 6);
                            case 2:
                              return Text(
                                "Direct Plan",
                                style: AppTextStyles(
                                  context,
                                ).display9W400.copyWith(color: Colors.white),
                              ).paddingSymmetric(vertical: 6);
                            default:
                              return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor: Colors.transparent,
                      tooltipPadding: EdgeInsets.zero,
                      tooltipMargin: 0,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String valueLabel;
                        switch (group.x.toInt()) {
                          case 0:
                            valueLabel = "₹1.59L";
                            break;
                          case 1:
                            valueLabel = "₹4.03L";
                            break;
                          case 2:
                            valueLabel = "₹4.95L";
                            break;
                          default:
                            valueLabel = "";
                        }
                        return BarTooltipItem(
                          valueLabel,
                          AppTextStyles(
                            context,
                          ).display9W400.copyWith(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  barGroups: [
                    makeStackedBar(0, 0.25, 0.5),
                    makeStackedBar(1, 0.5, 1),
                    makeStackedBar(2, 0.4, 1.5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeStackedBar(int x, double base, double profit) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: base + profit,
          width: 41,
          borderRadius: BorderRadius.circular(0),
          rodStackItems: [
            BarChartRodStackItem(0, base, const Color(0xff3D3D3D)),
            BarChartRodStackItem(base, base + profit, const Color(0xff358438)),
          ],
        ),
      ],
      showingTooltipIndicators: [],
      barsSpace: 16,
    );
  }
}
