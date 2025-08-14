import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class AppButton extends StatefulWidget {
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
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        if (widget.isVisible == null || widget.isVisible == true) {
          widget.onPress?.call();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        height: widget.height ?? 50.0,
        width: widget.width,
        padding: widget.isPadding ?? false ? widget.padding : null,
        decoration: ShapeDecoration(
          color: _isPressed
              ? (widget.buttonColor ?? Colors.blue).withOpacity(0.7) // Darker on press
              : widget.buttonColor ?? Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) Icon(widget.icon, color: widget.iconColor, size: widget.iconSize),
            if (widget.iconImage != null) Image.asset(widget.iconImage ?? '', color: widget.iconColor, height: 20.h, width: 20.w),
            SizedBox(width: 5.w),
            Center(child: Text(widget.buttonName ?? '', style: widget.style)),
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
