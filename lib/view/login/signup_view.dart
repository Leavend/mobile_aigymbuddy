<<<<<<< HEAD
// lib/view/login/signup_view.dart

=======
>>>>>>> refs/remotes/origin/main
import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420), // presisi max width
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // full-width
                    children: [
                      // Header
                      Text("Hey there,",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: TColor.gray, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("Create an Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 24),

                      // Fields
                      const RoundTextField(
                        hitText: "First Name",
                        icon: "assets/img/user_text.png",
                      ),
                      const SizedBox(height: 16),
                      const RoundTextField(
                        hitText: "Last Name",
                        icon: "assets/img/user_text.png",
                      ),
                      const SizedBox(height: 16),
                      const RoundTextField(
                        hitText: "Email",
                        icon: "assets/img/email.png",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      RoundTextField(
                        hitText: "Password",
                        icon: "assets/img/lock.png",
                        obscureText: true,
                        rigtIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/img/show_password.png",
                            width: 20,
                            height: 20,
<<<<<<< HEAD
                            color: TColor.gray,
=======
                            fit: BoxFit.contain,
                            color: TColor.yellow,
                          ))),
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isCheck = !isCheck;
                        });
                      },
                      icon: Icon(
                        isCheck
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined,
                        color: TColor.yellow,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child:  Text(
                          "By continuing you accept our Privacy Policy and\nTerm of Use",
                          style: TextStyle(color: TColor.yellow, fontSize: 10),
                        ),
                     
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.4,
                ),
                RoundButton(
                    title: "Register",
                    onPressed: () {
                      context.push(AppRoute.completeProfile);
                    }),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.yellow.withValues(alpha: 0.5),
                    )),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: TColor.yellow.withValues(alpha: 0.5),
                    )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                            width: 1,
                            color: TColor.yellow.withValues(alpha: 0.4),
>>>>>>> refs/remotes/origin/main
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Checkbox rapi tanpa IconButton
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isCheck,
                            onChanged: (v) => setState(() => isCheck = v ?? false),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "By continuing you accept our Privacy Policy and\nTerm of Use",
                              style: TextStyle(color: TColor.gray, fontSize: 12),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Button full-width
                      RoundButton(
                          title: "Register",
                          onPressed: () {
                            context.push(AppRoute.completeProfile);
                      }),

                      const SizedBox(height: 16),

                      // Divider "Or"
                      Row(
                        children: [
                          Expanded(child: Container(height: 1, color: TColor.gray.withValues(alpha: 0.3))),
                          const SizedBox(width: 8),
                          Text("Or", style: TextStyle(color: TColor.black, fontSize: 12)),
                          const SizedBox(width: 8),
                          Expanded(child: Container(height: 1, color: TColor.gray.withValues(alpha: 0.3))),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Socials
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialIcon(path: "assets/img/google.png"),
                          const SizedBox(width: 12),
                          _SocialIcon(path: "assets/img/facebook.png"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Footer link
                      TextButton(
                        onPressed: () {
                          context.push(AppRoute.login);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Already have an account? ",
                                style: TextStyle(color: TColor.black, fontSize: 14)),
                            Text("Login",
                                style: TextStyle(
                                  color: TColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                )),
                          ],
                        ),
                      ),
<<<<<<< HEAD
=======
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    context.push(AppRoute.login);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      )
>>>>>>> refs/remotes/origin/main
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final String path;
  const _SocialIcon({required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TColor.white,
          border: Border.all(width: 1, color: TColor.gray.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(path, width: 20, height: 20),
      ),
    );
  }
}
