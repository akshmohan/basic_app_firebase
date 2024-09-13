import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/entities/user_entity.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';
import 'package:mechine_test_flutter/core/errors/server_exception.dart';
import 'package:mechine_test_flutter/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mechine_test_flutter/features/auth/data/models/user_model.dart';
import 'package:mechine_test_flutter/features/auth/domain/repositories/auth_repository.dart';

import '../data_sources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource, this.authLocalDataSource);

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required DateTime createdAt,
  }) async {
    try {
      UserModel userModel =
          await authRemoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
        createdAt: createdAt,
      );
      UserEntity userEntity = UserEntity(
        name: userModel.name,
        email: userModel.email,
        password: userModel.password,
        createdAt: userModel.createdAt,
      );

      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserModel userModel =
          await authRemoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      authLocalDataSource.uploadUserDataToHive(userModel);

      UserEntity userEntity = UserEntity(
        name: userModel.name,
        email: userModel.email,
        password: userModel.password,
        createdAt: userModel.createdAt,
      );

      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await authLocalDataSource.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkUserLoggedIn() async {
    try {
      UserModel? usermodel = authLocalDataSource.checkUserLoggedIn();

      if (usermodel != null) {
        print(usermodel.name);
        return Right(usermodel);
      }
      return const Left(Failure(message: "User doesn't exist!"));
    } on ServerException catch (e) {
      return Left(Failure(message: e.message.toString()));
    }
  }
}
