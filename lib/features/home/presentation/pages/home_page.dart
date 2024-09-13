import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/core/utils/show_snackbar.dart';
import 'package:mechine_test_flutter/core/widgets/loader.dart';
import 'package:mechine_test_flutter/features/auth/presentation/pages/sign_in_page.dart';
import 'package:mechine_test_flutter/features/home/presentation/pages/cart_page.dart';
import 'package:mechine_test_flutter/features/home/presentation/pages/details_page.dart';
import 'package:mechine_test_flutter/features/home/presentation/widgets/product_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/product_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(ProductsFetchOnSignIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()));
              },
              child: Text("Go to Cart",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
                width: 10), // Add some space between "Go to Cart" and title
            Expanded(
              child: Text(
                "Home Page",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // context.read<AuthBloc>().add(SignOutButtonPressed());
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => SignInPage(fromSplash: true),
              //     ),
              //     (route) => false);
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductsDisplayFailure) {
            showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProductsDisplayLoading) {
            return Loader();
          } else if (state is ProductsDisplaySuccess) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(10),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                final product = state.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsPage(
                                  product: product,
                                )));
                  },
                  child: ProductCard(
                    product: product,
                  ),
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout Confirmation"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              context.read<AuthBloc>().add(SignOutButtonPressed());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(fromSplash: true),
                  ),
                  (route) => false);
            },
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}
