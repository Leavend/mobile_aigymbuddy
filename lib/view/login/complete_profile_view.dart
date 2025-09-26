// lib/view/login/complete_profile_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  String? gender;
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController heightCtrl = TextEditingController();

  @override
  void dispose() {
    dobCtrl.dispose();
    weightCtrl.dispose();
    heightCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 90),
      lastDate: now,
      helpText: 'Select Date of Birth',
      builder: (context, child) {
        // opsional: tema datepicker biar selaras
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TColor.primaryColor1, // header background
              onPrimary: TColor.white,       // header text
              onSurface: TColor.black,       // body text
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobCtrl.text = "${picked.year.toString().padLeft(4, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420), // presisi lebar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ilustrasi proporsional (tidak full lebar)
                  Image.asset(
                    "assets/img/complete_profile.png",
                    width: media.width * 0.7,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 24),

                  // Title & subtitle
                  Text(
                    "Let’s complete your profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "It will help us to know more about you!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                  ),

                  const SizedBox(height: 24),

                  // Gender dropdown (card style)
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: TColor.lightGray,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/img/gender.png",
                          width: 20,
                          height: 20,
                          color: TColor.gray,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: gender,
                              icon: Icon(Icons.keyboard_arrow_down_rounded,
                                  color: TColor.gray),
                              items: const ["Male", "Female"]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                              color: TColor.gray, fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                              hint: Text("Choose Gender",
                                  style: TextStyle(
                                      color: TColor.gray, fontSize: 12)),
                              onChanged: (v) => setState(() => gender = v),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date of Birth (tap open picker)
                  GestureDetector(
                    onTap: _pickDob,
                    behavior: HitTestBehavior.opaque,
                    child: AbsorbPointer(
                      child: RoundTextField(
                        controller: dobCtrl,
                        hitText: "Date of Birth",
                        icon: "assets/img/date.png",
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Weight
                  Row(
                    children: [
                      Expanded(
                        child: RoundTextField(
                          controller: weightCtrl,
                          hitText: "Your Weight",
                          icon: "assets/img/weight.png",
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _UnitTag(text: "KG"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Height
                  Row(
                    children: [
                      Expanded(
                        child: RoundTextField(
                          controller: heightCtrl,
                          hitText: "Your Height",
                          icon: "assets/img/hight.png",
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _UnitTag(text: "CM"),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Button Next
                  RoundButton(
                    title: "Next >",
                    onPressed: () {
                      context.push(AppRoute.goal);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnitTag extends StatelessWidget {
  final String text;
  const _UnitTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: TColor.secondaryG),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Text(
        text,
        style: TextStyle(color: TColor.white, fontSize: 12),
      ),
    );
  }
}
