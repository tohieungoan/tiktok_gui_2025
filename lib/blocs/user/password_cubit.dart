import 'package:bloc/bloc.dart';

class PasswordState {
  final bool isLengthValid;
  final bool isComplexValid;
  final bool hasSpecialChar;

  const PasswordState({
    required this.isLengthValid,
    required this.isComplexValid,
    required this.hasSpecialChar,
  });

  bool get isAllValid => isLengthValid && isComplexValid && hasSpecialChar;
  PasswordState copyWith({
    bool? isLengthValid,
    bool? isComplexValid,
    bool? hasSpecialChar,
  }) {
    return PasswordState(
      isLengthValid: isLengthValid ?? this.isLengthValid,
      isComplexValid: isComplexValid ?? this.isComplexValid,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
    );
  }

  factory PasswordState.initial() => const PasswordState(
    isLengthValid: false,
    isComplexValid: false,
    hasSpecialChar: false,
  );
}

class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit() : super(PasswordState.initial());

  void validate(String password) {
    final isLengthValid = password.length >= 8;
    final isComplexValid = RegExp(
      r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
    ).hasMatch(password);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    emit(
      PasswordState(
        isLengthValid: isLengthValid,
        isComplexValid: isComplexValid,
        hasSpecialChar: hasSpecialChar,
      ),
    );
  }
}
