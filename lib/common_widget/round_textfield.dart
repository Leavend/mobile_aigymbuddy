import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundTextField extends StatelessWidget {
  const RoundTextField({
    required this.hintText, required this.icon, super.key,
    this.controller,
    this.margin,
    this.keyboardType,
    this.obscureText = false,
    this.rightIcon,
    this.inputFormatters,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.autovalidateMode,
    this.focusNode,
    this.onFieldSubmitted,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines,
    this.textAlign = TextAlign.start,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hintText;
  final String icon;
  final Widget? rightIcon;
  final bool obscureText;
  final EdgeInsets? margin;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final int? minLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = enabled
        ? TColor.lightGray
        : TColor.lightGray.withValues(alpha: 0.6);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        // Added subtle border for better visual definition
        border: Border.all(color: TColor.gray.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        validator: validator,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        onFieldSubmitted: onFieldSubmitted,
        enabled: enabled,
        maxLines: maxLines,
        minLines: minLines,
        textAlign: textAlign,
        // Added cursor color for better UX
        cursorColor: TColor.primaryColor1,
        // Added text selection theme
        style: const TextStyle(color: TColor.black, fontSize: 14),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          // Improved border styling
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: TColor.gray.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: TColor.primaryColor1, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          hintText: hintText,
          suffixIcon: rightIcon,
          prefixIcon: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(left: 15),
            child: Image.asset(
              icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: TColor.gray,
            ),
          ),
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(
            color: TColor.gray,
            fontSize: 14, // Increased font size for better readability
          ),
          // Removed content padding conflict
          isDense: true,
        ),
      ),
    );
  }
}
