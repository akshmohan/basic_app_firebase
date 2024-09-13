import 'package:fpdart/fpdart.dart';
import 'package:mechine_test_flutter/core/errors/failure.dart';

abstract interface class Usecase<SuccessTupe, Params> {
  Future<Either<Failure, SuccessTupe>> call(Params params);
}

class NoParams {}
