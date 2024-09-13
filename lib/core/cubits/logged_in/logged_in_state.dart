part of 'logged_in_cubit.dart';

@immutable
sealed class LoggedInState {}

final class LoggedInInitial extends LoggedInState {}

class UserLoggedIn extends LoggedInState {
  final UserEntity user;

  UserLoggedIn(this.user);
}
