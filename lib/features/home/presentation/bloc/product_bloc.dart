import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/core/usecases/usecase.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/fetch_data_from_api.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchDataFromApi _fetchDataFromApi;

  ProductBloc({
    required FetchDataFromApi fetchDataFromApi,
  })  : _fetchDataFromApi = fetchDataFromApi,
        super(ProductInitial()) {
    on<ProductsFetchOnSignIn>(_onProductsFetchOnSignIn);
    on<ToggleCartEvent>(_onToggleCartEvent);
    on<CounterIncrementEvent>(_onCounterIncrement);
    on<CounterDecrementEvent>(_onCounterDecrement);
  }

  Future<void> _onProductsFetchOnSignIn(
    ProductsFetchOnSignIn event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductsDisplayLoading());
    final data = await _fetchDataFromApi(NoParams());

    data.fold(
      (failure) => emit(ProductsDisplayFailure(failure.message)),
      (success) {
        final cartStatus = <int, bool>{};
        final productCounts = <int, int>{};
        for (var product in success) {
          cartStatus[product.id] = false;
          productCounts[product.id] = 1;
        }
        emit(ProductsDisplaySuccess(success, cartStatus, productCounts));
      },
    );
  }

  void _onToggleCartEvent(ToggleCartEvent event, Emitter<ProductState> emit) {
    final currentState = state;
    if (currentState is ProductsDisplaySuccess) {
      final updatedCartStatus = Map<int, bool>.from(currentState.cartStatus);
      updatedCartStatus[event.productId] = !updatedCartStatus[event.productId]!;

      emit(ProductsDisplaySuccess(
          currentState.data, updatedCartStatus, currentState.productCounts));
    }
  }

  void _onCounterIncrement(
    CounterIncrementEvent event,
    Emitter<ProductState> emit,
  ) {
    final currentState = state;
    if (currentState is ProductsDisplaySuccess) {
      final updatedCounts = Map<int, int>.from(currentState.productCounts);
      updatedCounts[event.productId] =
          (updatedCounts[event.productId] ?? 1) + 1;

      emit(ProductsDisplaySuccess(
        currentState.data,
        currentState.cartStatus,
        updatedCounts,
      ));
    }
  }

  void _onCounterDecrement(
    CounterDecrementEvent event,
    Emitter<ProductState> emit,
  ) {
    final currentState = state;
    if (currentState is ProductsDisplaySuccess) {
      final updatedCounts = Map<int, int>.from(currentState.productCounts);
      if (updatedCounts[event.productId]! > 1) {
        updatedCounts[event.productId] = updatedCounts[event.productId]! - 1;
      }

      emit(ProductsDisplaySuccess(
        currentState.data,
        currentState.cartStatus,
        updatedCounts,
      ));
    }
  }
}
