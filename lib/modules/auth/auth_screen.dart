import 'package:country_picker/country_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:practical_khazana/common/app_button.dart';
import 'package:practical_khazana/common/app_scaffold.dart';
import 'package:practical_khazana/common/app_text_field.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/gen/assets.gen.dart';
import 'package:practical_khazana/utils/base_extensions.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Auth Screen',
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: SafeArea(
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back,\nWe Missed You! 🎉',
                  style: AppTextStyles(
                    context,
                  ).display24W400.copyWith(color: AppColors.appWhiteColor),
                ),
                8.0.toVSB,
                RichText(
                  text: TextSpan(
                    text: 'Glad to have you back at ',
                    children: [
                      TextSpan(
                        text: 'Dhan Saarthi',
                        style: AppTextStyles(
                          context,
                        ).display14W400.copyWith(color: AppColors.primaryColor),
                      ),
                    ],
                    style: AppTextStyles(
                      context,
                    ).display14W400.copyWith(color: AppColors.appWhiteColor),
                  ),
                ),
                82.0.toVSB,
                Text(
                  authController.isOtpView.value
                      ? 'Enter OTP'
                      : 'Enter your phone number',
                  style: AppTextStyles(
                    context,
                  ).display14W400.copyWith(color: AppColors.appWhiteColor),
                ),
                12.0.toVSB,
                AnimatedCrossFade(
                  firstChild: AppTextField(
                    hintText: 'Phone Number',
                    fillColor: AppColors.blackLight,
                    controller: authController.phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    prefixWidget: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            authController.selectedCountry.value = country;
                          },
                        );
                      },
                      child: Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "+${authController.selectedCountry.value.phoneCode}",
                              style: AppTextStyles(context).display14W400
                                  .copyWith(color: AppColors.appWhiteColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  secondChild: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: Get.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      authController.isOtpError.value
                                          ? AppColors.errorColor
                                          : AppColors.grayDark,
                                  width: 3,
                                ),
                              ),
                            ),
                            textStyle: AppTextStyles(context).display24W400
                                .copyWith(color: AppColors.backgroundLight),
                          ),
                          onCompleted: (value) {
                            authController.otpCode.value = value;
                            authController
                                .verifyOtp(); // Auto-verify on completion
                          },
                        ),
                        34.0.toVSB,
                        authController.isOtpError.value
                            ? Text(
                              'Invalid OTP! Please try again',
                              style: AppTextStyles(context).display12W400
                                  .copyWith(color: AppColors.errorColor),
                            )
                            : const SizedBox.shrink(),
                        16.0.toVSB,
                        RichText(
                          text: TextSpan(
                            text:
                                !authController.canResend.value
                                    ? "${authController.resendTimer.value}sec"
                                    : "Didn't Receive OTP? ",
                            style: AppTextStyles(context).display12W400
                                .copyWith(color: AppColors.appWhiteColor),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap:
                                      () =>
                                          !authController.canResend.value
                                              ? null
                                              : authController.registerPhone(),
                                  child: Text(
                                    'Resend',
                                    style: AppTextStyles(
                                      context,
                                    ).display12W400.copyWith(
                                      color:
                                          !authController.canResend.value
                                              ? AppColors.grayDark
                                              : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        16.0.toVSB,
                        Row(
                          children: [
                            Text(
                              'OTP has been sent on ${authController.phoneNumber.value.maskedPhone}',
                              style: AppTextStyles(context).display12W400
                                  .copyWith(color: AppColors.grayLight),
                            ),
                            8.0.toHSB,
                            GestureDetector(
                              onTap: () {
                                authController.backToPhoneNumber();
                              },
                              child: SvgPicture.asset(
                                Assets.icons.pencilSimple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  crossFadeState:
                      authController.isOtpView.value
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                  duration: const Duration(
                    milliseconds: 300,
                  ), // Transition duration
                ),
                56.0.toVSB,
                AppButton(
                  onPressed: () {
                    authController.isOtpView.value
                        ? authController.verifyOtp()
                        : authController.registerPhone();
                  },
                  text: 'Proceed',
                  isEnabled:
                      authController.isOtpView.value
                          ? authController.otpCode.value.length == 6
                          : authController.phoneNumber.value.length >= 10,
                ).paddingSymmetric(horizontal: 35),
                const Spacer(),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'By signing in, you agree to our ',
                      style: AppTextStyles(
                        context,
                      ).display10W400.copyWith(color: AppColors.appWhiteColor),
                      children: [
                        TextSpan(
                          text: 'T&C ',
                          style: AppTextStyles(context).display10W400.copyWith(
                            color: AppColors.primaryColor,
                          ),
                          children: [
                            TextSpan(
                              text: 'and ',
                              style: AppTextStyles(context).display10W400
                                  .copyWith(color: AppColors.appWhiteColor),
                              children: [
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTextStyles(context).display10W400
                                      .copyWith(color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    authController.phoneController.dispose();
    super.dispose();
  }
}
