import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';
import 'package:mechine_test_flutter/core/errors/server_exception.dart';
import 'package:mechine_test_flutter/features/home/domain/entities/product_entity.dart';
import 'package:mechine_test_flutter/features/home/domain/repositories/product_repository.dart';
import '../data_sources/home_remote_data_source.dart';

class ProductRepoImpl implements ProductRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  ProductRepoImpl(this.homeRemoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchDataFromApi() async {
    try {
      final data = await homeRemoteDataSource.fetchDataFromApi();
      return Right(data);
    } on ServerException catch (e) {
      return Left(Failure(message: e.message));
    }
  }
}
