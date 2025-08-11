import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class AppButton extends StatelessWidget {
  final String? buttonName;
  final Function()? onPress;
  final bool? isVisible;
  final TextStyle? style;
  final Color? buttonColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;
  final bool? isPadding;
  final String? iconImage;
  final EdgeInsetsGeometry? padding;

  AppButton({
    this.buttonName,
    this.onPress,
    this.isVisible,
    this.buttonColor,
    this.textColor,
    this.height,
    this.width,
    this.iconColor,
    this.iconImage,
    this.iconSize,
    this.icon,
    this.padding,
    this.isPadding,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isVisible == null || isVisible == true) {
          onPress!();
        }
      },
      child: Container(
        height: height ?? 50.0,
        width: width,
        padding: isPadding ?? false ? padding : null,
        decoration: ShapeDecoration(color: buttonColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: iconColor, size: iconSize),
            if (iconImage != null) Image.asset(iconImage ?? '', color: iconColor, height: 20.h, width: 20.w),
            SizedBox(width: 5.w),
            Center(child: Text(buttonName ?? '', style: style)),
          ],
        ),
      ),
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  final double? widthSize;
  final EdgeInsets? padding;
  final double? heightSize;
  final String? buttonName;
  final Function()? onPress;
  final bool? isVisible;
  final Color? outlineColor;

  AppOutlineButton({this.buttonName, this.onPress, this.isVisible, this.widthSize, this.heightSize, this.outlineColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isVisible == null || isVisible == true) {
          onPress!();
        }
      },
      child: Container(
        height: heightSize ?? 30.h,
        padding: padding,
        width: widthSize,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: outlineColor ?? AppColors.blue),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Center(child: Text(buttonName ?? '', style: AppStyles.fontStyleW600.copyWith(fontSize: 18.sp, color: AppColors.cancel))),
      ),
    );
  }
}
