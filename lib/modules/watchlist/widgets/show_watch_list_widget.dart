import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/common/app_button.dart';
import 'package:practical_khazana/controllers/watch_list_controller.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/utils/app_toast.dart';
import 'package:practical_khazana/utils/base_extensions.dart';

import '../../../common/common_import.dart';

class ShowWatchListWidget extends StatelessWidget {
  ShowWatchListWidget({super.key});

  final controller = Get.find<WatchListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: Get.height * 0.4,
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    controller.isNewWatchList.value ||
                            controller.isEditWatchListName.value
                        ? controller.isEditWatchListName.value
                            ? 'Edit watchlist name'
                            : 'Create new watchlist'
                        : 'All Watchlist',
                    style: AppTextStyles(
                      context,
                    ).display20W400.copyWith(color: AppColors.appWhiteColor),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: 1.0,
                      child: Icon(Icons.close, color: AppColors.appWhiteColor),
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 21, vertical: 18),
            Divider(
              color: AppColors.appWhiteColor.withOpacity(0.4),
              thickness: 1,
            ),
            19.0.toVSB,
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    controller.isNewWatchList.value ||
                            controller.isEditWatchListName.value
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Watchlist Name',
                              style: AppTextStyles(context).display14W400
                                  .copyWith(color: AppColors.appWhiteColor),
                            ),
                            12.0.toVSB,
                            TextField(
                              controller: controller.watchListName,
                              obscureText: false,
                              maxLength: 20,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.blackLight,
                                counterText:
                                    '', // optional: hide character counter
                                hintText: 'Enter watchlist name',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        controller.enableWatchList.value ||
                                                controller
                                                    .isEditWatchListName
                                                    .value
                                            ? AppColors.primaryColor
                                            : AppColors.grayDark.withOpacity(
                                              0.4,
                                            ),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color:
                                        controller.enableWatchList.value ||
                                                controller
                                                    .isEditWatchListName
                                                    .value
                                            ? AppColors.primaryColor
                                            : AppColors.grayDark.withOpacity(
                                              0.4,
                                            ),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                            24.0.toVSB,
                            AppButton(
                              onPressed: () {
                                final text =
                                    controller.watchListName.text.trim();
                                if (text.isEmpty || text.length < 4) {
                                  AppToast.showError(
                                    title: 'Invalid name',
                                    description: 'Please add a name',
                                  );
                                  return;
                                }
                                controller.isEditWatchListName.value
                                    ? controller.updateWatchList()
                                    : controller.addToWatchList();
                              },
                              text:
                                  controller.isEditWatchListName.value
                                      ? 'Update'
                                      : 'Create',
                              borderColor:
                                  controller.enableWatchList.value ||
                                          controller.isEditWatchListName.value
                                      ? AppColors.primaryColor
                                      : AppColors.grayDark,
                              isEnabled:
                                  controller.enableWatchList.value ||
                                  controller.isEditWatchListName.value,
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 51)
                        : ListView.separated(
                          // key: const ValueKey('ListView'),
                          itemCount: controller.watchList.length,
                          padding: const EdgeInsets.symmetric(horizontal: 29),
                          separatorBuilder: (context, index) => 24.0.toVSB,
                          itemBuilder:
                              (context, index) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.watchList[index],
                                    style: AppTextStyles(
                                      context,
                                    ).display16W400.copyWith(
                                      color: AppColors.appWhiteColor,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.isEditWatchListName.value =
                                          true;
                                      controller.updateWatchListName =
                                          TextEditingController(
                                            text: controller.watchList[index],
                                          );
                                      controller.watchListName =
                                          TextEditingController(
                                            text: controller.watchList[index],
                                          );
                                    },
                                    child: SvgPicture.asset(
                                      Assets.icons.pencilSimple,
                                      height: 20,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                        ),
              ),
            ),
            20.0.toVSB,
            if (!controller.isNewWatchList.value &&
                !controller.isEditWatchListName.value)
              InkWell(
                onTap: () {
                  controller.isNewWatchList.value = true;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.primaryColor,
                      child: Center(child: Icon(Icons.add, size: 10)),
                    ),
                    16.0.toHSB,
                    Text(
                      'Create new watchlist',
                      style: AppTextStyles(
                        context,
                      ).display16W400.copyWith(color: AppColors.appWhiteColor),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 71),
              ),
            36.0.toVSB,
          ],
        ),
      ),
    );
  }
}
