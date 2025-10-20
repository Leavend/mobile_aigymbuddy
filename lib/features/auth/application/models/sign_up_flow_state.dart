// lib/features/auth/application/models/sign_up_flow_state.dart

class SignUpFlowState {
  const SignUpFlowState({
    required this.userId,
    required this.email,
    required this.displayName,
  });

  final String userId;
  final String email;
  final String displayName;
}
