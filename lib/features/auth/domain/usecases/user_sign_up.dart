import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/entities/user_entity.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';
import 'package:mechine_test_flutter/core/usecases/usecase.dart';
import 'package:mechine_test_flutter/features/auth/domain/repositories/auth_repository.dart';

class UserSignUp implements Usecase<UserEntity, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(params) async {
    return await authRepository.signUpWithEmailAndPassword(
        name: params.name,
        email: params.email,
        password: params.password,
        createdAt: params.createdAt);
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  UserSignUpParams(
      {required this.name,
      required this.email,
      required this.password,
      required this.createdAt});
}
