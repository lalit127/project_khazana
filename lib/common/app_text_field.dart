import 'package:flutter/services.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final String? suffixIconPath;
  final Color? fillColor;
  final bool? isEnabled;
  final Widget? prefixWidget;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLength;
  final Color? borderColor;
  final int? maxLines;
  final TextStyle? hintStyle;

  const AppTextField({
    super.key,
    this.hintText,
    this.hintStyle,
    this.controller,
    this.obscureText = false,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.fillColor,
    this.prefixWidget,
    this.suffixIconPath,
    this.inputFormatters,
    this.borderColor,
    this.maxLength = 10,
    this.maxLines = 1, // Default to 1 line
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(color: AppColors.black, offset: Offset(2, 2)),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        enabled: isEnabled,
        onChanged: onChanged,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLines, // Apply maxLines
        inputFormatters: inputFormatters,
        style: AppTextStyles(
          context,
        ).display14W400.copyWith(color: AppColors.appWhiteColor),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: fillColor ?? Colors.white,
          hintStyle:
              hintStyle ??
              AppTextStyles(
                context,
              ).display14W400.copyWith(color: AppColors.appWhiteColor),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? AppColors.grayDark,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? AppColors.grayDark,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? AppColors.grayDark,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon:
              prefixWidget != null
                  ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: prefixWidget,
                  )
                  : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffix:
              suffixIconPath != null
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      suffixIconPath!,
                      width: 20,
                      height: 20,
                      color: Colors.grey,
                    ),
                  )
                  : null,
          counterText: '', // Hide the maxLength counter
        ),
      ),
    );
  }
}
