import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/utils/base_extensions.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final bottomNavController = Get.put(HomeController());
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                20.0.toVSB,
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14.75),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.blackLight, width: 1),
                      bottom: BorderSide(
                        color: AppColors.blackLight,
                        width: 0.3,
                      ),
                    ),
                    color: AppColors.black,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(Assets.icons.icLogo),
                      SvgPicture.asset(Assets.icons.icMenu),
                    ],
                  ).paddingSymmetric(horizontal: 24),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome User,',
              style: AppTextStyles(
                context,
              ).display24W400.copyWith(color: AppColors.appWhiteColor),
            ),
            34.0.toVSB,
            Text(
              'Fund Performance',
              style: AppTextStyles(
                context,
              ).display14W400.copyWith(color: AppColors.appWhiteColor),
            ),
            10.0.toVSB,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.fundPerformanceList.length,
              itemBuilder: (context, index) {
                final fund = controller.fundPerformanceList[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grayDark.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grayDark, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fund['fundName'],
                        style: AppTextStyles(context).display14W400.copyWith(
                          color: AppColors.appWhiteColor,
                        ),
                      ),
                      8.0.toVSB,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Invested: ${fund['investedAmount']}',
                            style: AppTextStyles(context).display12W400
                                .copyWith(color: AppColors.appWhiteColor),
                          ),
                          Text(
                            'Current: ${fund['currentValue']}',
                            style: AppTextStyles(context).display12W400
                                .copyWith(color: AppColors.appWhiteColor),
                          ),
                        ],
                      ),
                      6.0.toVSB,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Returns: ${fund['returns']}',
                            style: AppTextStyles(context).display12W400
                                .copyWith(color: AppColors.appWhiteColor),
                          ),
                          Text(
                            'Profit: ${fund['profit']}',
                            style: AppTextStyles(context).display12W400
                                .copyWith(color: AppColors.appWhiteColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => 14.0.toVSB,
            ),
            34.0.toVSB,
            Text(
              'My Watchlist',
              style: AppTextStyles(
                context,
              ).display14W400.copyWith(color: AppColors.appWhiteColor),
            ),
            20.0.toVSB,
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.mutualWatchList.keys.length,
                itemBuilder: (context, index) {
                  final key = controller.mutualWatchList.keys.toList()[index];
                  final fundList = controller.mutualWatchList[key]!;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grayDark.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.grayDark, width: 0.5),
                    ),
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Watchlist Title
                        Text(
                          key,
                          style: AppTextStyles(context).display14W600.copyWith(
                            color: AppColors.appWhiteColor,
                          ),
                        ),
                        14.0.toVSB,

                        // Funds List
                        fundList.isNotEmpty
                            ? Column(
                              children:
                                  fundList.map((fund) {
                                    final returns =
                                        fund.returns?.d5y?.toString() ?? 'N/A';
                                    final returnColor =
                                        returns != 'N/A' &&
                                                double.tryParse(returns) != null
                                            ? double.parse(returns) >= 0
                                                ? AppColors.success
                                                : AppColors.danger
                                            : AppColors.appWhiteColor;

                                    return Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Fund Image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: CachedNetworkImage(
                                                height: 34,
                                                width: 34,
                                                fit: BoxFit.cover,
                                                imageUrl: fund.imageUrl ?? '',
                                                placeholder:
                                                    (context, url) => Container(
                                                      color:
                                                          AppColors.blackLight,
                                                      child: Icon(
                                                        Icons.image,
                                                        color: Colors.grey,
                                                        size: 18,
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                          color:
                                                              AppColors
                                                                  .blackLight,
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            color: Colors.grey,
                                                            size: 18,
                                                          ),
                                                        ),
                                              ),
                                            ),
                                            12.0.toHSB,

                                            // Fund Name
                                            Expanded(
                                              child: Text(
                                                fund.schemeName ?? '',
                                                style: AppTextStyles(
                                                  context,
                                                ).display13W400.copyWith(
                                                  color:
                                                      AppColors.appWhiteColor,
                                                ),
                                              ),
                                            ),

                                            // Returns
                                            Text(
                                              '$returns%',
                                              style: AppTextStyles(context)
                                                  .display13W500
                                                  .copyWith(color: returnColor),
                                            ),
                                          ],
                                        ),
                                        12.0.toVSB,
                                        if (fundList.last != fund)
                                          Divider(
                                            color: AppColors.grayDark,
                                            height: 1,
                                            thickness: 0.4,
                                          ),
                                        12.0.toVSB,
                                      ],
                                    );
                                  }).toList(),
                            )
                            : Text(
                              'No data available',
                              style: AppTextStyles(context).display12W400
                                  .copyWith(color: AppColors.appWhiteColor),
                            ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => 20.0.toVSB,
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 23, vertical: 24),
      ),
    );
  }
}
