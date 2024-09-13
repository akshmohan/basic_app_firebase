import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';
import 'package:mechine_test_flutter/core/usecases/usecase.dart';
import 'package:mechine_test_flutter/features/home/domain/entities/product_entity.dart';
import 'package:mechine_test_flutter/features/home/domain/repositories/product_repository.dart';

class FetchDataFromApi implements Usecase<List<ProductEntity>, NoParams> {
  final ProductRepository productRepository;

  FetchDataFromApi(this.productRepository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(params) async {
    return await productRepository.fetchDataFromApi();
  }
}
