import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

/// Common scaffold used across the authentication flow to ensure
/// consistent layout and responsive behaviour on different screen sizes.
class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    this.backgroundColor = TColor.white,
    this.maxWidth = 420,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: padding,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    minHeight: constraints.maxHeight - padding.vertical,
                  ),
                  child: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
