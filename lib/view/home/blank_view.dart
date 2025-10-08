import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';

class BlankView extends StatelessWidget {
  const BlankView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: TColor.white);
  }
}
