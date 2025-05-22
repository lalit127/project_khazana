import 'package:get/get.dart';
import 'package:practical_khazana/common/app_text_field.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/controllers/bottom_nav_controller.dart';
import 'package:practical_khazana/controllers/watch_list_controller.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/modules/watchlist/widgets/show_watch_list_widget.dart';
import 'package:practical_khazana/modules/watchlist/widgets/sliver_persitant_header_widget.dart';
import 'package:practical_khazana/routes/app_pages.dart';
import 'package:practical_khazana/utils/base_extensions.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  final controller = Get.put<WatchListController>(WatchListController());
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.isAddNewWatchList.value = false;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!controller.isLoading.value && controller.isAddNewWatchList.value) {
          controller.fetchMutualFundList(
            controller.currentPage.value + 1,
            query:
                controller.searchWatchListController.text.isNotEmpty
                    ? controller.searchWatchListController.text
                    : '',
            isPaginated: true,
          );
          controller.isPaginated.value = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(
        () => SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.black,
                pinned: false,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final bottomNavController =
                            Get.find<BottomNavController>();
                        bottomNavController.changeTabIndex(0);
                      },
                      child: SvgPicture.asset(Assets.icons.icArrowLeft),
                    ),
                    8.0.toHSB,
                    Text(
                      'WatchList',
                      style: AppTextStyles(
                        context,
                      ).display20W500.copyWith(color: AppColors.appWhiteColor),
                    ),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  height: 25,
                  child: Obx(
                    () => Container(
                      color: AppColors.black,
                      height: 25,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.watchList.length,
                        separatorBuilder: (context, index) => 16.0.toHSB,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.changeTab(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 21,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        controller.selectedIndex.value == index
                                            ? AppColors.primaryColor
                                            : AppColors.grayDark.withOpacity(
                                              0.4,
                                            ),
                                  ),
                                  color:
                                      controller.selectedIndex.value == index
                                          ? AppColors.primaryColor
                                          : AppColors.blackLight,
                                ),
                                child: Center(
                                  child: Text(
                                    controller.watchList[index],
                                    style: AppTextStyles(
                                      context,
                                    ).display10W400.copyWith(
                                      color:
                                          controller.selectedIndex.value ==
                                                  index
                                              ? AppColors.appWhiteColor
                                              : AppColors.appWhiteColor
                                                  .withOpacity(0.6),
                                    ),
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
              ),
              SliverToBoxAdapter(
                child: Obx(
                  () =>
                      !controller.isAddToMoreWatchlist.value &&
                              !controller.isLoading.value
                          ? InkWell(
                            onTap: () {
                              controller.isAddToMoreWatchlist.value = true;
                              controller.fetchMutualFundList(1);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: AppColors.primaryColor,
                                  size: 18,
                                ),
                                7.5.toHSB,
                                Text(
                                  'Add ',
                                  style: AppTextStyles(context).display14W400
                                      .copyWith(color: AppColors.primaryColor),
                                ),
                              ],
                            ).paddingOnly(left: 24, top: 36),
                          )
                          : const SizedBox.shrink(),
                ),
              ),
              if (controller.isAddToMoreWatchlist.value)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverHeaderDelegate(
                    height: 45,
                    child: Container(
                      color: AppColors.black,
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 7,
                      ),
                      child: AppTextField(
                        controller: controller.searchWatchListController,
                        fillColor: const Color(0xff292934),
                        borderColor: Colors.transparent,
                        prefixWidget: const Icon(
                          Icons.search,
                          size: 16,
                          color: Color(0xffB0B0B0),
                        ),
                        onChanged: (value) {
                          if (value.length > 3) {
                            controller.onSearchChanged(value);
                          } else if (value.isEmpty) {
                            controller.getMutualFundWatchList(
                              controller.watchList[controller
                                  .selectedIndex
                                  .value],
                            );
                          }
                        },
                        hintText:
                            'Search for Mutual Funds, AMC, Fund Managers...',
                        hintStyle: AppTextStyles(context).display10W400
                            .copyWith(color: const Color(0xff6D6D6D)),
                      ),
                    ),
                  ),
                ),
              Obx(() {
                if (controller.mutualWatchFundList.value.isNotEmpty &&
                    (controller.isAddToMoreWatchlist.value == false)) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == controller.mutualWatchFundList.length) {
                          return controller.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : const SizedBox.shrink();
                        }
                        final fund = controller.mutualWatchFundList[index];
                        return Dismissible(
                          key: ValueKey(fund.schemeCode),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xffDE504B),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SvgPicture.asset(Assets.icons.icTrash),
                          ),
                          onDismissed: (direction) {
                            controller.removeMutualFundFromWatchList(fund);
                          },
                          child: InkWell(
                            onTap:
                                () => Get.toNamed(
                                  AppPages.chart,
                                  arguments: {'fund': fund},
                                ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.blackLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.grayDark.withOpacity(0.4),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // CachedNetworkImage(
                                        //   height: 28,
                                        //   fit: BoxFit.cover,
                                        //   imageUrl: fund.imageUrl ?? '',
                                        // ),
                                        // 10.0.toHSB,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 182,
                                              child: Text(
                                                fund.schemeName ?? '',
                                                style: AppTextStyles(
                                                  context,
                                                ).display14W400.copyWith(
                                                  color:
                                                      AppColors.appWhiteColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            8.0.toVSB,
                                            Text(
                                              'Others | Funds of Funds',
                                              style: AppTextStyles(
                                                context,
                                              ).display12W400.copyWith(
                                                color: const Color(0xffB0B0B0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'NAV ',
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '₹${fund.currentNav ?? 0.0}',
                                                    style: AppTextStyles(
                                                      context,
                                                    ).display14W400.copyWith(
                                                      color:
                                                          AppColors
                                                              .appWhiteColor,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                                style: AppTextStyles(
                                                  context,
                                                ).display12W400.copyWith(
                                                  color: const Color(
                                                    0xffB0B0B0,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            9.0.toVSB,
                                            RichText(
                                              text: TextSpan(
                                                text: '1D ',
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        ' ${fund.returns?.i1d}%',
                                                    style: AppTextStyles(
                                                      context,
                                                    ).display14W400.copyWith(
                                                      color:
                                                          fund.returns?.i1d !=
                                                                  null
                                                              ? (fund.returns?.i1d ??
                                                                          0.0) >=
                                                                      0.1
                                                                  ? const Color(
                                                                    0xff4CAF50,
                                                                  )
                                                                  : (fund.returns?.i1d ??
                                                                          0.0) <
                                                                      0.0
                                                                  ? AppColors
                                                                      .danger
                                                                  : AppColors
                                                                      .appWhiteColor
                                                              : AppColors
                                                                  .appWhiteColor,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                                style: AppTextStyles(
                                                  context,
                                                ).display12W400.copyWith(
                                                  color: const Color(
                                                    0xffB0B0B0,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    12.0.toVSB,
                                    Divider(
                                      color: AppColors.grayDark,
                                      height: 0.5,
                                    ),
                                    8.0.toVSB,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              text: '1Y ',
                                              children: [
                                                TextSpan(
                                                  text:
                                                      ' ${fund.returns?.d1y}%',
                                                  style: AppTextStyles(
                                                    context,
                                                  ).display12W400.copyWith(
                                                    color:
                                                        fund.returns?.d1y !=
                                                                null
                                                            ? (fund.returns?.d1y ??
                                                                        0.0) >=
                                                                    0.1
                                                                ? const Color(
                                                                  0xff4CAF50,
                                                                )
                                                                : (fund.returns?.d1y ??
                                                                        0.0) <
                                                                    0.0
                                                                ? AppColors
                                                                    .danger
                                                                : AppColors
                                                                    .appWhiteColor
                                                            : AppColors
                                                                .appWhiteColor,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                              style: AppTextStyles(
                                                context,
                                              ).display12W400.copyWith(
                                                color: const Color(0xffB0B0B0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              text: '3Y ',
                                              children: [
                                                TextSpan(
                                                  text:
                                                      ' ${fund.returns?.n3y ?? 50.1}%',
                                                  style: AppTextStyles(
                                                    context,
                                                  ).display12W400.copyWith(
                                                    color:
                                                        fund.returns?.n3y !=
                                                                null
                                                            ? (fund.returns?.n3y ??
                                                                        0.0) >=
                                                                    0.1
                                                                ? const Color(
                                                                  0xff4CAF50,
                                                                )
                                                                : (fund.returns?.n3y ??
                                                                        0.0) <=
                                                                    0.0
                                                                ? AppColors
                                                                    .danger
                                                                : AppColors
                                                                    .appWhiteColor
                                                            : AppColors
                                                                .appWhiteColor,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                              style: AppTextStyles(
                                                context,
                                              ).display12W400.copyWith(
                                                color: const Color(0xffB0B0B0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              text: '5Y ',
                                              children: [
                                                TextSpan(
                                                  text:
                                                      ' ${fund.returns?.d5y}%',
                                                  style: AppTextStyles(
                                                    context,
                                                  ).display12W400.copyWith(
                                                    color:
                                                        fund.returns?.d5y !=
                                                                null
                                                            ? (fund.returns?.d5y ??
                                                                        0.0) >=
                                                                    0.1
                                                                ? const Color(
                                                                  0xff4CAF50,
                                                                )
                                                                : (fund.returns?.d5y ??
                                                                        0.0) <=
                                                                    0.0
                                                                ? AppColors
                                                                    .danger
                                                                : AppColors
                                                                    .appWhiteColor
                                                            : AppColors
                                                                .appWhiteColor,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                              style: AppTextStyles(
                                                context,
                                              ).display12W400.copyWith(
                                                color: const Color(0xffB0B0B0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Exp. Ratio',
                                            children: [
                                              TextSpan(
                                                text: ' 25.50% ',
                                                style: AppTextStyles(
                                                  context,
                                                ).display12W400.copyWith(
                                                  color:
                                                      fund.returns?.d5y != null
                                                          ? (fund.returns?.d5y ??
                                                                      0.0) >=
                                                                  0.1
                                                              ? const Color(
                                                                0xff4CAF50,
                                                              )
                                                              : (fund
                                                                          .returns
                                                                          ?.d5y ??
                                                                      0.0) <=
                                                                  0.0
                                                              ? AppColors
                                                                  .appWhiteColor
                                                              : AppColors.danger
                                                          : AppColors
                                                              .appWhiteColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                            style: AppTextStyles(
                                              context,
                                            ).display12W400.copyWith(
                                              color: const Color(0xffB0B0B0),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 24, vertical: 10);
                      },
                      childCount:
                          controller.mutualWatchFundList.length +
                          1, // extra for loader
                    ),
                  );
                } else {
                  if (controller.isAddToMoreWatchlist.value) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == controller.mutualFundList.length) {
                            return controller.isLoading.value
                                ? Obx(
                                  () => Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          controller.isPaginated.value
                                              ? 5
                                              : Get.height * 0.3,
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink();
                          }
                          final fund = controller.mutualFundList[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 24,
                              right: 24,
                              top: index == 0 ? 30 : 0,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      height: 28,
                                      fit: BoxFit.cover,
                                      imageUrl: fund.imageUrl ?? '',
                                    ),
                                    10.0.toHSB,
                                    Expanded(
                                      child: Text(
                                        fund.schemeName ?? '',
                                        style: AppTextStyles(
                                          context,
                                        ).display12W400.copyWith(
                                          color: AppColors.appWhiteColor,
                                        ),
                                      ),
                                    ),
                                    10.0.toHSB,
                                    Obx(
                                      () => InkWell(
                                        onTap: () {
                                          final currentStatus =
                                              controller
                                                  .mutualFundList[index]
                                                  .isBookMarked ??
                                              false;
                                          controller
                                              .mutualFundList[index]
                                              .isBookMarked = !currentStatus;

                                          controller.mutualFundList.refresh();

                                          if (controller
                                                  .mutualFundList[index]
                                                  .isBookMarked ==
                                              true) {
                                            controller.addMutualFundToWatchList(
                                              controller.mutualFundList[index],
                                            );
                                          } else {
                                            controller
                                                .removeMutualFundFromWatchList(
                                                  controller
                                                      .mutualFundList[index],
                                                );
                                          }

                                          print(
                                            "bookmarked==>${controller.mutualFundList[index].isBookMarked}",
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          controller
                                                      .mutualFundList
                                                      .value[index]
                                                      .isBookMarked ==
                                                  true
                                              ? Assets.icons.icBookmark
                                              : Assets.icons.icWatchlist,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 0.5,
                                  color: AppColors.grayDark,
                                ).paddingSymmetric(vertical: 23),
                              ],
                            ),
                          );
                        },
                        childCount:
                            controller.mutualFundList.length +
                            1, // extra for loader
                      ),
                    );
                  } else {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child:
                            controller.isLoading.value
                                ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        controller.isPaginated.value
                                            ? 5
                                            : Get.height * 0.3,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Assets.icons.icWatchGraph,
                                      ),
                                      16.0.toVSB,
                                      Text(
                                        'Looks like your watchlist is empty.',
                                        style: AppTextStyles(
                                          context,
                                        ).display14W400.copyWith(
                                          color: const Color(0xff6D6D6D),
                                        ),
                                      ),
                                      38.0.toVSB,
                                      controller.watchList.isEmpty
                                          ? const SizedBox.shrink()
                                          : IntrinsicWidth(
                                            child: InkWell(
                                              onTap: () {
                                                if (controller
                                                    .watchList
                                                    .isNotEmpty) {
                                                  controller
                                                      .isAddToMoreWatchlist
                                                      .value = true;
                                                  controller
                                                      .fetchMutualFundList(1);
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 11,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                  color: Colors.black,
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xff292934,
                                                    ),
                                                    width: 1.8,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.add,
                                                      color:
                                                          AppColors
                                                              .appWhiteColor,
                                                    ),
                                                    8.0.toHSB,
                                                    Text(
                                                      'Add Mutual Funds',
                                                      style: AppTextStyles(
                                                        context,
                                                      ).display12W400.copyWith(
                                                        color:
                                                            AppColors
                                                                .appWhiteColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                      ),
                    );
                  }
                }
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            showWatchListSheet();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min, // wrap content horizontally
              children: [
                const Icon(Icons.add, color: AppColors.appWhiteColor),
                8.0.toHSB,
                Text(
                  'Watchlist',
                  style: AppTextStyles(
                    context,
                  ).display14W400.copyWith(color: AppColors.appWhiteColor),
                ),
              ],
            ),
          ),
        ),
      ).paddingSymmetric(vertical: 30),
    );
  }

  showWatchListSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: AppColors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        controller.isNewWatchList.value = false;
        return ShowWatchListWidget();
      },
    );
  }
}
