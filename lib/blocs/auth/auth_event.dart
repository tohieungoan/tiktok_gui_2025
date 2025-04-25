import 'package:flutter/material.dart';

abstract class AuthEvent {}

class FacebookLoginRequested extends AuthEvent {
  final BuildContext context;

  FacebookLoginRequested({required this.context});
}

class GoogleLoginRequested extends AuthEvent {
  final BuildContext context;

  GoogleLoginRequested({required this.context});
}

class EmailLoginRequested extends AuthEvent {
  final BuildContext context;
  final String email;
  final String password;

  EmailLoginRequested({
    required this.context,
    required this.email,
    required this.password,
  });
}
class EmailSignUpRequested extends AuthEvent {
  final BuildContext context;
  final String username;
  final String email;
  final String password;

  EmailSignUpRequested({
    required this.context,
    required this.username,
    required this.email,
    required this.password,
  });
}
class LogoutRequested extends AuthEvent {}
