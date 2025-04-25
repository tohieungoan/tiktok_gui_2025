import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_app/features/auth/controllers/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is FacebookLoginRequested) {
      yield* _mapFacebookLoginRequestedToState(event.context);
    } else if (event is EmailSignUpRequested) {
      yield* _mapEmailSignUpRequestedToState(
        event.context,
        event.username,
        event.email,
        event.password,
      );
    } else if (event is GoogleLoginRequested) {
      yield* _mapGoogleLoginRequestedToState(event.context);
    } else if (event is EmailLoginRequested) {
      yield* _mapEmailLoginRequestedToState(
        event.context,
        event.email,
        event.password,
      );
    } else if (event is LogoutRequested) {
      yield* _mapLogoutRequestedToState();
    }
  }

  Stream<AuthState> _mapFacebookLoginRequestedToState(
    BuildContext context,
  ) async* {
    yield AuthLoading();
    print("Đang xử lý đăng nhập với Facebook...");
    final result = await AuthService.signInWithFacebook(context: context);
    if (result != null) {
      yield AuthAuthenticated(user: result);
    } else {
      yield AuthError(message: "Đăng nhập Facebook thất bại");
    }
  }

  // Phương thức đăng ký mới
  Stream<AuthState> _mapEmailSignUpRequestedToState(
    BuildContext context,
    String username,
    String email,
    String password,
  ) async* {
    yield AuthLoading();
    final result = await AuthService.signUpWithEmail(
      context: context,
      username: username,
      email: email,
      password: password,
    );
    if (result != null) {
      yield AuthAuthenticated(user: result);
    } else {
      yield AuthError(message: "Đăng ký thất bại");
    }
  }

  Stream<AuthState> _mapGoogleLoginRequestedToState(
    BuildContext context,
  ) async* {
    yield AuthLoading();
    final result = await AuthService.signInWithGoogle(context: context);
    if (result != null) {
      yield AuthAuthenticated(user: result);
    } else {
      yield AuthError(message: "Đăng nhập Google thất bại");
    }
  }

  Stream<AuthState> _mapEmailLoginRequestedToState(
    BuildContext context,
    String email,
    String password,
  ) async* {
    yield AuthLoading();
    final result = await AuthService.signInWithEmail(
      context: context,
      email: email,
      password: password,
    );
    if (result != null) {
      yield AuthAuthenticated(user: result);
    } else {
      yield AuthError(message: "Đăng nhập email thất bại");
    }
  }

  Stream<AuthState> _mapLogoutRequestedToState() async* {
    yield AuthInitial();
  }
}
