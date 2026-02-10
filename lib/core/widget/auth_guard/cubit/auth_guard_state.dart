part of 'auth_guard_cubit.dart';

class AuthGuardState {
  final bool shouldShowDialog;

  const AuthGuardState({this.shouldShowDialog = false});

  AuthGuardState copyWith({bool? shouldShowDialog}) {
    return AuthGuardState(
      shouldShowDialog: shouldShowDialog ?? this.shouldShowDialog,
    );
  }

  @override
  List<Object> get props => [shouldShowDialog];
}
