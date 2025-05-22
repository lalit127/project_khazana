import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/routes/app_pages.dart';
import 'package:practical_khazana/utils/base_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      checkSign();
    });
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    bool isSignedIn = s.getBool("is_signedin") ?? false;
    if (isSignedIn) {
      Get.offAllNamed(AppPages.dashboard);
    } else {
      Get.offAllNamed(AppPages.onboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
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
