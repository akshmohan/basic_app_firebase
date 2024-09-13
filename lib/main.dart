import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechine_test_flutter/core/cubits/logged_in/logged_in_cubit.dart';
import 'package:mechine_test_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mechine_test_flutter/features/home/presentation/bloc/product_bloc.dart';
import 'package:mechine_test_flutter/features/home/presentation/pages/home_page.dart';
import 'package:mechine_test_flutter/init_dependencies.dart';
import 'features/auth/presentation/pages/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependecies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<LoggedInCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ProductBloc>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(IsLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocSelector<LoggedInCubit, LoggedInState, bool>(selector: (state) {
        return state is UserLoggedIn;
      }, builder: (context, state) {
        if (state) {
          return HomePage();
        } else {
          return const SignInPage(fromSplash: true);
        }
      }),
    );
  }
}
