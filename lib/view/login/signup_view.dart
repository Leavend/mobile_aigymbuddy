import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:aigymbuddy/common_widget/round_textfield.dart';
import 'package:aigymbuddy/common_widget/social_auth_button.dart';
import 'package:aigymbuddy/view/base/base_view.dart';
import 'package:aigymbuddy/view/login/controllers/signup_controller.dart';
import 'package:aigymbuddy/view/login/widgets/auth_page_layout.dart';
import 'package:aigymbuddy/view/login/widgets/auth_validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

abstract final class _SignUpTexts {
  static const greeting = LocalizedText(
    english: 'Hey there,',
    indonesian: 'Hai,',
  );
  static const createAccount = LocalizedText(
    english: 'Create an Account',
    indonesian: 'Buat Akun',
  );
  static const firstNameHint = LocalizedText(
    english: 'First Name',
    indonesian: 'Nama Depan',
  );
  static const lastNameHint = LocalizedText(
    english: 'Last Name',
    indonesian: 'Nama Belakang',
  );
  static const emailHint = LocalizedText(english: 'Email', indonesian: 'Email');
  static const passwordHint = LocalizedText(
    english: 'Password',
    indonesian: 'Kata Sandi',
  );
  static const termsText = LocalizedText(
    english: 'By continuing you accept our Privacy Policy and\nTerm of Use',
    indonesian:
        'Dengan melanjutkan kamu menyetujui Kebijakan Privasi dan\nSyarat Penggunaan kami',
  );
  static const registerButton = LocalizedText(
    english: 'Register',
    indonesian: 'Daftar',
  );
  static const divider = LocalizedText(english: 'Or', indonesian: 'Atau');
  static const footerQuestion = LocalizedText(
    english: 'Already have an account? ',
    indonesian: 'Sudah punya akun? ',
  );
  static const footerAction = LocalizedText(
    english: 'Login',
    indonesian: 'Masuk',
  );

  static const socialProviders = [
    'assets/img/google.png',
    'assets/img/facebook.png',
  ];

  static const firstNameRequired = LocalizedText(
    english: 'First name is required',
    indonesian: 'Nama depan wajib diisi',
  );
  static const lastNameRequired = LocalizedText(
    english: 'Last name is required',
    indonesian: 'Nama belakang wajib diisi',
  );
  static const emailRequired = LocalizedText(
    english: 'Email is required',
    indonesian: 'Email wajib diisi',
  );
  static const emailInvalid = LocalizedText(
    english: 'Enter a valid email address',
    indonesian: 'Masukkan alamat email yang valid',
  );
  static const passwordRequired = LocalizedText(
    english: 'Password is required',
    indonesian: 'Kata sandi wajib diisi',
  );
  static const passwordLength = LocalizedText(
    english: 'Password must be at least 8 characters',
    indonesian: 'Kata sandi minimal 8 karakter',
  );
  static const passwordWeak = LocalizedText(
    english: 'Password must contain uppercase, lowercase, and numbers',
    indonesian: 'Kata sandi harus mengandung huruf besar, kecil, dan angka',
  );
  static const termsRequired = LocalizedText(
    english: 'Please accept the terms to continue',
    indonesian: 'Silakan setujui syarat dan ketentuan terlebih dahulu',
  );
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupController(),
      child: const _SignUpContent(),
    );
  }
}

class _SignUpContent extends BaseView<SignupController> {
  const _SignUpContent();

  @override
  Widget buildContent(BuildContext context, SignupController controller) {
    return AuthPageLayout(child: _SignUpForm(controller: controller));
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm({required this.controller});

  final SignupController controller;

  @override
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      final data = widget.controller.submit();
      if (data != null) {
        context.push(AppRoute.completeProfile, extra: data);
      }
    } else {
      // Trigger validation UI updates in controller even if form is invalid
      widget.controller.submit();
    }
  }

  String? _validateFirstName(String? value) => AuthValidators.validateRequired(
    context: context,
    value: value,
    emptyMessage: _SignUpTexts.firstNameRequired,
  );

  String? _validateLastName(String? value) => AuthValidators.validateRequired(
    context: context,
    value: value,
    emptyMessage: _SignUpTexts.lastNameRequired,
  );

  String? _validateEmail(String? value) => AuthValidators.validateEmail(
    context: context,
    value: value,
    emptyMessage: _SignUpTexts.emailRequired,
    invalidMessage: _SignUpTexts.emailInvalid,
  );

  String? _validatePassword(String? value) => AuthValidators.validatePassword(
    context: context,
    value: value,
    emptyMessage: _SignUpTexts.passwordRequired,
    lengthMessage: _SignUpTexts.passwordLength,
    weakMessage: _SignUpTexts.passwordWeak,
  );

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final autovalidateMode = controller.autoValidate
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(context),
        const SizedBox(height: 28),
        _buildForm(context, controller, autovalidateMode),
        const SizedBox(height: 12),
        _buildTermsRow(context, controller),
        if (controller.showTermsError && !controller.isTermsAccepted) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              context.localize(_SignUpTexts.termsRequired),
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        RoundButton(
          title: context.localize(_SignUpTexts.registerButton),
          onPressed: _onRegisterPressed,
          isEnabled: controller.isRegisterEnabled,
        ),
        const SizedBox(height: 16),
        _buildDivider(context),
        const SizedBox(height: 16),
        _buildSocialRow(),
        const SizedBox(height: 20),
        _buildLoginPrompt(context),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          context.localize(_SignUpTexts.greeting),
          textAlign: TextAlign.center,
          style: const TextStyle(color: TColor.gray, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          context.localize(_SignUpTexts.createAccount),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: TColor.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(
    BuildContext context,
    SignupController controller,
    AutovalidateMode autovalidateMode,
  ) {
    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundTextField(
            controller: controller.firstNameController,
            focusNode: _firstNameFocusNode,
            hintText: context.localize(_SignUpTexts.firstNameHint),
            icon: 'assets/img/user_text.png',
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: _validateFirstName,
            onFieldSubmitted: (_) => _lastNameFocusNode.requestFocus(),
          ),
          const SizedBox(height: 16),
          RoundTextField(
            controller: controller.lastNameController,
            focusNode: _lastNameFocusNode,
            hintText: context.localize(_SignUpTexts.lastNameHint),
            icon: 'assets/img/user_text.png',
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: _validateLastName,
            onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
          ),
          const SizedBox(height: 16),
          RoundTextField(
            controller: controller.emailController,
            focusNode: _emailFocusNode,
            hintText: context.localize(_SignUpTexts.emailHint),
            icon: 'assets/img/email.png',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),
          const SizedBox(height: 16),
          RoundTextField(
            controller: controller.passwordController,
            focusNode: _passwordFocusNode,
            hintText: context.localize(_SignUpTexts.passwordHint),
            icon: 'assets/img/lock.png',
            obscureText: !controller.isPasswordVisible,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
            onFieldSubmitted: (_) => _onRegisterPressed(),
            rightIcon: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: controller.togglePasswordVisibility,
              icon: Image.asset(
                controller.isPasswordVisible
                    ? 'assets/img/hide_password.png'
                    : 'assets/img/show_password.png',
                width: 20,
                height: 20,
                color: TColor.gray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsRow(BuildContext context, SignupController controller) {
    return Row(
      children: [
        Checkbox(
          value: controller.isTermsAccepted,
          onChanged: controller.toggleTermsAccepted,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            context.localize(_SignUpTexts.termsText),
            style: const TextStyle(color: TColor.gray, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: TColor.gray.withValues(alpha: 0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            context.localize(_SignUpTexts.divider),
            style: const TextStyle(color: TColor.black, fontSize: 12),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: TColor.gray.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < _SignUpTexts.socialProviders.length; i++) ...[
          SocialAuthButton(assetPath: _SignUpTexts.socialProviders[i]),
          if (i < _SignUpTexts.socialProviders.length - 1)
            const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(AppRoute.login),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.localize(_SignUpTexts.footerQuestion),
            style: const TextStyle(color: TColor.black, fontSize: 14),
          ),
          Text(
            context.localize(_SignUpTexts.footerAction),
            style: const TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
