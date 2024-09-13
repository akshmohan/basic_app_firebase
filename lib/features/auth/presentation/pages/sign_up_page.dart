import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/core/utils/show_snackbar.dart';
import 'package:mechine_test_flutter/core/widgets/loader.dart';
import 'package:mechine_test_flutter/features/home/presentation/pages/home_page.dart';
import '../../../../core/widgets/auth_button.dart';
import '../../../../core/widgets/auth_field.dart';
import '../bloc/auth_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final uidController = TextEditingController();
  // final createdAtController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Sign Up Page"),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackbar(context, state.message);
          } else if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
            showSnackbar(context, "Sign up Successful!");
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AuthField(
                          hintText: "Enter name", controller: nameController),
                      const SizedBox(height: 20),
                      AuthField(
                          hintText: "Enter e-mail",
                          controller: emailController),
                      const SizedBox(height: 40),
                      AuthField(
                        hintText: "Enter password",
                        controller: passwordController,
                        isObscure: true,
                      ),
                      const SizedBox(height: 40),
                      AuthButton(
                          buttonText: 'Sign Up',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final createdAt = DateTime.now();
                              context.read<AuthBloc>().add(SignUpButtonPressed(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    createdAt: createdAt,
                                  ));
                            }
                          }),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: const Text("Already have an account? Sign in"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
