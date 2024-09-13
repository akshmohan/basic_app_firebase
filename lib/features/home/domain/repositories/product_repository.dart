import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';
import 'package:mechine_test_flutter/features/home/domain/entities/product_entity.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> fetchDataFromApi();
}
