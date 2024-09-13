import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/entities/user_entity.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';
import 'package:mechine_test_flutter/core/usecases/usecase.dart';
import 'package:mechine_test_flutter/features/auth/domain/repositories/auth_repository.dart';

class IsLoggedInCheck implements Usecase<UserEntity, NoParams> {
  final AuthRepository authRepository;

  IsLoggedInCheck(this.authRepository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return authRepository.checkUserLoggedIn();
  }
}
