import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/utils/base_extensions.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final bottomNavController = Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(
        () =>
            bottomNavController
                .pages[bottomNavController.selectedIndex.value]
                .page,
      ),
      bottomNavigationBar: Obx(
        () => Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.blackLight, width: 1),
              bottom: BorderSide(color: AppColors.blackLight, width: 1),
            ),
            color: AppColors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(bottomNavController.pages.length, (index) {
              bool isSelected =
                  bottomNavController.selectedIndex.value == index;
              return GestureDetector(
                onTap: () => bottomNavController.changeTabIndex(index),
                behavior: HitTestBehavior.translucent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      bottomNavController.pages[index].icon,
                      height: 24,
                      width: 24,
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : AppColors.appWhiteColor.withOpacity(0.6),
                    ),
                    6.0.toVSB,
                    Text(
                      bottomNavController.pages[index].label,
                      style: AppTextStyles(context).display14W400.copyWith(
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : AppColors.appWhiteColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
