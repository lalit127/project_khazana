import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/routes/app_pages.dart';
import 'package:practical_khazana/utils/base_extensions.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'One step closer to smarter\ninvesting. Let’s begin!',
                    style: AppTextStyles(context).display14W400.copyWith(
                      color: AppColors.grayLight.withOpacity(0.4),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppPages.auth),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      radius: 30,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
              27.0.toVSB,
            ],
          ).paddingSymmetric(horizontal: 24),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.icons.icDhanasaarthi),
                46.0.toVSB,
                Text(
                  'Welcome to \nDhanSaarthi !',
                  style: AppTextStyles(
                    context,
                  ).display32W400.copyWith(color: AppColors.appWhiteColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
