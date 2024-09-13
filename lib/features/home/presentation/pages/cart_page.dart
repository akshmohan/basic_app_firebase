import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/core/widgets/loader.dart';
import 'package:mechine_test_flutter/features/home/presentation/bloc/product_bloc.dart';
import 'package:mechine_test_flutter/features/home/presentation/widgets/product_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Items in you cart:"),
        centerTitle: true,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductsDisplaySuccess) {
            final cartProducts = state.data
                .where((product) => state.cartStatus[product.id] ?? false)
                .toList();

            if (cartProducts.isEmpty) {
              return Center(
                child: Text("Your cart is empty"),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProducts.length,
                      itemBuilder: (context, index) {
                        final product = cartProducts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ProductCard(
                            product: product,
                            showCounterTab: true,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Loader();
        },
      ),
    );
  }
}
