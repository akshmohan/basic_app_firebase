import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/entities/user_entity.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required DateTime createdAt,
  });

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<Either<Failure, UserEntity>> checkUserLoggedIn();
}
