import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:get/get.dart';

class AppToast {
  static void showSuccess({required String title, String? description}) {
    toastification.show(
      context: Get.context!,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static void showError({required String title, String? description}) {
    toastification.show(
      context: Get.context!,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static void showInfo({required String title, String? description}) {
    toastification.show(
      context: Get.context!,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}
