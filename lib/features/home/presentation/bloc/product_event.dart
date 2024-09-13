part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

final class ProductsFetchOnSignIn extends ProductEvent {}

final class ToggleCartEvent extends ProductEvent {
  final int productId;

  const ToggleCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

final class UpdateProductCountEvent extends ProductEvent {
  final int productId;
  final int count;

  UpdateProductCountEvent(this.productId, this.count);

  @override
  List<Object?> get props => [productId, count];
}

final class CounterIncrementEvent extends ProductEvent {
  final int productId;

  CounterIncrementEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

final class CounterDecrementEvent extends ProductEvent {
  final int productId;

  CounterDecrementEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}
