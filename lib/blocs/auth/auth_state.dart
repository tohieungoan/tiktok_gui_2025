abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> user;

  AuthAuthenticated({required this.user});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
