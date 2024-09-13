import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/core/utils/show_snackbar.dart';
import 'package:mechine_test_flutter/core/widgets/loader.dart';
import 'package:mechine_test_flutter/features/home/presentation/pages/home_page.dart';
import '../../../../core/widgets/auth_button.dart';
import '../../../../core/widgets/auth_field.dart';
import '../bloc/auth_bloc.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  final bool fromSplash;

  const SignInPage({super.key, required this.fromSplash});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In Page'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure && widget.fromSplash != true) {
            showSnackbar(context, state.message);
          } else if (state is AuthSuccess) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthField(
                      hintText: "Enter e-mail", controller: emailController),
                  SizedBox(height: 30),
                  AuthField(
                    hintText: "Enter password",
                    controller: passwordController,
                    isObscure: true,
                  ),
                  SizedBox(height: 50),
                  AuthButton(
                      buttonText: "Sign In",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(SignInButtonPressed(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ));
                        }
                      }),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: Text("Don't have an account? Sign Up"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
