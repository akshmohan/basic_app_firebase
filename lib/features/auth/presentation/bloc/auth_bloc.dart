import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/core/entities/user_entity.dart';
import 'package:mechine_test_flutter/core/usecases/usecase.dart';
import 'package:mechine_test_flutter/features/auth/domain/usecases/user_sign_up.dart';
import '../../../../core/cubits/logged_in/logged_in_cubit.dart';
import '../../domain/usecases/is_logged_in.dart';
import '../../domain/usecases/user_sign_in.dart';
import '../../domain/usecases/user_sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;
  final IsLoggedInCheck _isLoggedInCheck;
  final LoggedInCubit _loggedInCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required UserSignOut userSignOut,
    required IsLoggedInCheck isLoggedInCheck,
    required LoggedInCubit loggedInCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _userSignOut = userSignOut,
        _isLoggedInCheck = isLoggedInCheck,
        _loggedInCubit = loggedInCubit,
        super(AuthInitial()) {
    on<SignUpButtonPressed>((event, emit) async {
      emit(AuthLoading());

      try {
        final signUpResult = await _userSignUp(UserSignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
          createdAt: event.createdAt,
        ));

        signUpResult.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (userEntity) => emit(AuthSuccess(userEntity: userEntity)),
        );
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<SignInButtonPressed>((event, emit) async {
      emit(AuthLoading());

      try {
        final signInResult = await _userSignIn(UserSignInParams(
          email: event.email,
          password: event.password,
        ));

        signInResult.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (userEntity) => emit(AuthSuccess(userEntity: userEntity)),
        );
      } catch (e) {
        emit(AuthFailure(message: e.toString()));
      }
    });

    on<SignOutButtonPressed>((event, emit) async {
      emit(AuthLoading());

      _userSignOut();
      emit(AuthFailure(message: "Logged out successfully!"));
    });

    on<IsLoggedIn>((event, emit) async {
      final result = await _isLoggedInCheck(NoParams());

      result.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => _emitAuthSuccess(user, emit),
      );
    });
  }

  void _emitAuthSuccess(UserEntity user, Emitter<AuthState> emit) {
    _loggedInCubit.updateUser(user);
    emit(AuthSuccess(userEntity: user));
  }
}
