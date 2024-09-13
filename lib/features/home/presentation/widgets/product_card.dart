import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/features/home/domain/entities/product_entity.dart';
import 'package:mechine_test_flutter/features/home/presentation/bloc/product_bloc.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final bool showCounterTab;

  ProductCard({
    super.key,
    required this.product,
    this.showCounterTab = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsDisplaySuccess) {
          bool isInCart = state.cartStatus[product.id] ?? false;
          int count = state.productCounts[product.id] ?? 1;
          return Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Category: ${product.category}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Image.network(
                      product.image,
                      height: 100,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Price: \$${product.price}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Rating: ${product.rating.rate}/5",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<ProductBloc>()
                              .add(ToggleCartEvent(product.id));
                        },
                        icon: Icon(
                          isInCart
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined,
                        ),
                      ),
                    ],
                  ),
                  if (showCounterTab) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<ProductBloc>()
                                      .add(CounterDecrementEvent(product.id));
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Text('$count'),
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<ProductBloc>()
                                      .add(CounterIncrementEvent(product.id));
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                          Text(
                            'Total: \$${(product.price * count).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
