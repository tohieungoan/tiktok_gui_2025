import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_app/models/User.dart';
import 'package:tiktok_app/features/profile/controller/UpdateUser.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(Userapp user) : super(UserInitial(user)) {
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserUpdating());
    try {
      final updatedUser = await UpdateUserController.updateUserapi(
        id: event.user.id!,
        email: event.user.email,
        username: event.user.username,
        firstname: event.user.firstname,
        lastname: event.user.lastname,
        password: event.user.password,
        phone: event.user.phone,
        birthdate: event.user.birthdate,
        gender: event.user.gender,
        bio: event.user.bio,
        avatar: event.user.avatar,
      );

      emit(UserUpdated(updatedUser!)); // Cập nhật thành công
    } catch (e) {
      emit(UserUpdateError(e.toString())); // Lỗi
    }
  }
}