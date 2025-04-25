part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {
  final Userapp user;

  UserInitial(this.user); // Lưu trữ thông tin người dùng trong UserInitial
}

class UserUpdating extends UserState {}

class UserUpdated extends UserState {
  final Userapp user;

  UserUpdated(this.user);
}

class UserUpdateError extends UserState {
  final String message;

  UserUpdateError(this.message);
}
