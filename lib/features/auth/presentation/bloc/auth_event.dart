part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpButtonPressed extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  const SignUpButtonPressed({
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [name, email, password, createdAt];
}

class SignInButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const SignInButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignOutButtonPressed extends AuthEvent {}

class IsLoggedIn extends AuthEvent {}

// class ShowLogoutConfirmationDialog extends AuthState {
//   final BuildContext context;
//
//   const ShowLogoutConfirmationDialog(this.context);
//
//   @override
//   List<Object?> get props => [context];
// }
