import 'package:practical_khazana/common/app_button.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/controllers/auth_controller.dart';
import 'package:practical_khazana/gen/fonts.gen.dart';
import 'package:practical_khazana/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            authController.isLoading.value == true
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.purple),
                )
                : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 30,
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Verification",
                          style: AppTextStyles(context).display22W700.copyWith(
                            fontFamily: FontFamily.gilroy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter the OTP send to your phone number",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      Colors
                                          .grey, // Customize the color as needed
                                  width: 2, // Customize the thickness as needed
                                ),
                              ),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (value) {
                            authController.otpCode.value = value;
                          },
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Obx(
                            () => AppButton(
                              isLoading: authController.isLoading.value,
                              onPressed: () {
                                authController.isLoading.value = true;
                                Future.delayed(Duration(seconds: 3), () {
                                  authController.isLoading.value = false;
                                  Get.toNamed(Routes.home);
                                });
                              },
                              text: 'Verify',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Didn't receive any code?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Resend New Code",
                          style: AppTextStyles(context).display17W700.copyWith(
                            fontFamily: FontFamily.gilroy,
                            color: AppColors.buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
