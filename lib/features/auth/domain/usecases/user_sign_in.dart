import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/entities/user_entity.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';
import 'package:mechine_test_flutter/core/usecases/usecase.dart';
import 'package:mechine_test_flutter/features/auth/domain/repositories/auth_repository.dart';

class UserSignIn implements Usecase<UserEntity, UserSignInParams> {
  final AuthRepository authRepository;

  UserSignIn(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(UserSignInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}
