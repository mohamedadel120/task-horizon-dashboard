import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_guard_state.dart';

class AuthGuardCubit extends Cubit<AuthGuardState> {
  AuthGuardCubit() : super(const AuthGuardState());

  void showDialog() {
    emit(state.copyWith(shouldShowDialog: true));
  }

  void hideDialog() {
    emit(state.copyWith(shouldShowDialog: false));
  }
}
