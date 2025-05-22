import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/models/user_model.dart';
import 'package:practical_khazana/routes/app_pages.dart';
import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;
  RxString verificationId = ''.obs;
  RxString otpCode = ''.obs;
  var phoneController = TextEditingController();
  RxString phoneNumber = ''.obs;
  var selectedCountry =
      Country(
        phoneCode: "91",
        countryCode: "IN",
        e164Sc: 0,
        geographic: true,
        level: 1,
        name: "India",
        example: "India",
        displayName: "India",
        displayNameNoCountryCode: "IN",
        e164Key: '',
      ).obs;

  RxBool isSignedIn = false.obs;

  RxBool isLoading = false.obs;

  RxnString uid = RxnString();
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(() {
      phoneNumber.value = phoneController.text;
    });
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    isSignedIn.value = true;
  }

  void registerPhone() async {
    String fullPhoneNumber =
        "+${selectedCountry.value.phoneCode}${phoneNumber.value}";
    await signInWithPhone(fullPhoneNumber);
  }

  RxBool isOtpView = false.obs;
  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      isLoading.value = true;
      await supabase.auth.signInWithOtp(phone: phoneNumber);
      isOtpView.value = true;
      startResendTimer();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }

  RxInt resendTimer = 30.obs;
  RxBool canResend = false.obs;
  Timer? _timer;

  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 30;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        resendTimer.value--;
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Verify OTP
  RxBool isOtpError = false.obs;
  Future<void> verifyOtp() async {
    isLoading.value = true;
    isOtpError.value = false;
    try {
      String phoneNumber =
          "+${selectedCountry.value.phoneCode}${phoneController.text.trim()}";

      final response = await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: otpCode.value,
        type: OtpType.sms,
      );

      print("Session: $response");

      final user = response.user;
      if (user != null) {
        uid.value = user.id;
        await checkUserExistOnDB();
      } else {
        isOtpError.value = true;
        Get.snackbar('Error', 'Invalid OTP. Please try again.');
      }
    } catch (e) {
      isOtpError.value = true;
      print(e);
      Get.snackbar('Error', 'OTP verification failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveUserDataToSupabase({
    required UserModel userModel,
    bool isNew = false,
  }) async {
    isLoading.value = true;
    try {
      if (isNew) {
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      }
      userModel.phoneNumber = supabase.auth.currentUser?.phone ?? '';
      userModel.uid = uid.value ?? '';

      await supabase.from('users').upsert(userModel.toMap());
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to save user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch user data from Supabase
  Future<void> getDataFromSupabase() async {
    try {
      final response =
          await supabase
              .from('users')
              .select()
              .eq('uid', supabase.auth.currentUser?.id ?? '')
              .single();

      if (response.isNotEmpty) {
        userModel.value = UserModel.fromMap(response);
        uid.value = userModel.value.uid;
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }

  // Store user data locally in SharedPreferences
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.value.toMap()));
  }

  // Retrieve user data from SharedPreferences
  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    if (data.isNotEmpty) {
      userModel.value = UserModel.fromMap(jsonDecode(data));
      uid.value = userModel.value.uid;
    }
  }

  // Sign out user
  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await supabase.auth.signOut();
    isSignedIn.value = false;
    s.clear();
  }

  // Check if user exists in Supabase database
  Future<bool> checkExistingUser() async {
    try {
      final response =
          await supabase
              .from('users')
              .select()
              .eq('uid', supabase.auth.currentUser?.id ?? '')
              .maybeSingle();

      return response != null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to check user: $e');
      return false;
    }
  }

  Future<void> checkUserExistOnDB() async {
    final userExists = await checkExistingUser();
    if (userExists) {
      await getDataFromSupabase();
      await saveUserDataToSP();
      await setSignIn();
      Get.offAllNamed(AppPages.dashboard);
    } else {
      UserModel newUser = UserModel(
        uid: supabase.auth.currentUser?.id ?? '',
        phoneNumber: supabase.auth.currentUser?.phone ?? '',
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      await saveUserDataToSupabase(userModel: newUser, isNew: true);
      await getDataFromSupabase(); // fetch the new user data
      await saveUserDataToSP();
      await setSignIn();
      Get.offAllNamed(AppPages.dashboard);
    }
  }

  backToPhoneNumber() {
    isOtpView.value = false;
    canResend.value = false;
    isOtpError.value = false;
  }
}
