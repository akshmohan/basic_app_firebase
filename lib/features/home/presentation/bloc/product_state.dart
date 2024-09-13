part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductsDisplayLoading extends ProductState {}

final class ProductsDisplaySuccess extends ProductState {
  final List<ProductEntity> data;
  final Map<int, bool> cartStatus;
  final Map<int, int> productCounts;

  const ProductsDisplaySuccess(
    this.data,
    this.cartStatus,
    this.productCounts,
  );

  @override
  List<Object?> get props => [data, cartStatus, productCounts];
}

final class ProductsDisplayFailure extends ProductState {
  final String message;

  const ProductsDisplayFailure(this.message);

  @override
  List<Object?> get props => [message];
}
