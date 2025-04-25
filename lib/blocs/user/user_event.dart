part of 'user_bloc.dart';

abstract class UserEvent {}

class UpdateUserEvent extends UserEvent {
  final Userapp user;

  UpdateUserEvent(this.user);
}
