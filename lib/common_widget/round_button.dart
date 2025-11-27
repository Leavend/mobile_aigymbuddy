import 'package:flutter/material.dart';

import '../common/color_extension.dart';

/// Enumerasi tipe tampilan [`RoundButton`].
enum RoundButtonType {
  /// Tombol dengan gradient utama sebagai latar.
  bgGradient,

  /// Tombol dengan gradient sekunder sebagai latar.
  bgSGradient,

  /// Tombol dengan latar solid dan teks bernuansa gradient.
  textGradient,
}

/// Tombol bundar dengan opsi gradient pada latar atau teks.
class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.type = RoundButtonType.bgGradient,
    this.fontSize = 16,
    this.elevation = 1,
    this.fontWeight = FontWeight.w700,
    this.height = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.borderRadius = const BorderRadius.all(Radius.circular(25)),
    this.isEnabled = true,
    this.isLoading = false,
    this.textStyle,
    this.width, // Added width property for better control
  }) : assert(height > 0, 'height must be greater than zero'),
       assert(fontSize > 0, 'fontSize must be greater than zero'),
       assert(elevation >= 0, 'elevation cannot be negative');

  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final double elevation;
  final FontWeight fontWeight;
  final double height;
  final double? width; // Added width property
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool isEnabled;
  final bool isLoading;
  final TextStyle? textStyle;

  bool get _usesGradientBackground =>
      type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient;

  bool get _effectiveEnabled => isEnabled && !isLoading;

  List<Color> get _backgroundColors =>
      type == RoundButtonType.bgSGradient ? TColor.secondaryG : TColor.primaryG;

  static const LinearGradient _textGradient = LinearGradient(
    colors: TColor.primaryG,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  Color get _textColor =>
      textStyle?.color ??
      (_usesGradientBackground ? TColor.white : TColor.primaryColor1);

  static const List<BoxShadow> _defaultGradientShadows = [
    BoxShadow(color: Colors.black26, blurRadius: 0.5, offset: Offset(0, 0.5)),
  ];

  List<BoxShadow>? get _gradientShadows =>
      _usesGradientBackground ? _defaultGradientShadows : null;

  TextStyle _resolveTextStyle(BuildContext context) {
    final baseStyle = textStyle ?? Theme.of(context).textTheme.labelLarge;
    return (baseStyle ?? const TextStyle()).copyWith(
      color: _textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  Widget _buildLabel(TextStyle style) {
    if (_usesGradientBackground) {
      return Text(title, style: style, textAlign: TextAlign.center);
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => _textGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(title, style: style, textAlign: TextAlign.center),
    );
  }

  Widget _buildContent(TextStyle style) {
    if (isLoading) {
      final indicatorColor = _usesGradientBackground
          ? TColor.white
          : TColor.primaryColor1;
      return Padding(
        padding: padding,
        child: SizedBox(
          height: height,
          child: Center(
            child: SizedBox(
              width: height * 0.4,
              height: height * 0.4,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: padding,
      child: SizedBox(
        height: height,
        child: Center(child: _buildLabel(style)),
      ),
    );
  }

  Widget _wrapWithInkWell(Widget child) {
    return InkWell(
      onTap: _effectiveEnabled ? onPressed : null,
      borderRadius: borderRadius,
      child: child,
    );
  }

  Widget _buildGradientButton(TextStyle style) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _backgroundColors),
        borderRadius: borderRadius,
        boxShadow: _gradientShadows,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge, // Updated to use Clip.hardEdge
        child: _wrapWithInkWell(_buildContent(style)),
      ),
    );
  }

  Widget _buildSolidButton(TextStyle style) {
    return Material(
      color: TColor.white,
      elevation: elevation,
      borderRadius: borderRadius,
      shadowColor: Colors.black26,
      clipBehavior: Clip.hardEdge, // Updated to use Clip.hardEdge
      child: _wrapWithInkWell(_buildContent(style)),
    );
  }

  Widget _applyStateDecoration(Widget child) {
    if (_effectiveEnabled) {
      return child;
    }

    return Opacity(opacity: 0.6, child: IgnorePointer(child: child));
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveTextStyle(context);
    final button = _usesGradientBackground
        ? _buildGradientButton(style)
        : _buildSolidButton(style);

    Widget constrainedButton = _applyStateDecoration(button);

    // Apply width constraint if specified
    if (width != null) {
      constrainedButton = SizedBox(
        width: width,
        height: height,
        child: constrainedButton,
      );
    } else {
      constrainedButton = ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: constrainedButton,
      );
    }

    return Semantics(
      button: true,
      enabled: _effectiveEnabled,
      label: title,
      child: constrainedButton,
    );
  }
}
