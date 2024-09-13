import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/features/home/domain/entities/product_entity.dart';
import 'package:mechine_test_flutter/features/home/presentation/bloc/product_bloc.dart';

class DetailsPage extends StatelessWidget {
  final ProductEntity product;

  const DetailsPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductsDisplaySuccess) {
          bool isInCart = state.cartStatus[product.id] ?? false;

          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    product.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Category: ${product.category}"),
                      IconButton(
                        onPressed: () {
                          context
                              .read<ProductBloc>()
                              .add(ToggleCartEvent(product.id));
                        },
                        icon: Icon(
                          size: 30,
                          isInCart
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Image.network(product.image),
                  SizedBox(height: 20),
                  Text("Description: ${product.description}"),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Price: \$${product.price}"),
                      Text("Rating: ${product.rating.rate}/5"),
                      Text("Count: ${product.rating.count}")
                    ],
                  ),
                  Row(
                    children: [],
                  )
                ],
              ),
            ),
          );
        }
        // Handle other states if needed
        return SizedBox();
      },
    );
  }
}
