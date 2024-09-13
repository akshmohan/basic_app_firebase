import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mechine_test_flutter/core/cubits/logged_in/logged_in_cubit.dart';
import 'package:mechine_test_flutter/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:mechine_test_flutter/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mechine_test_flutter/features/auth/domain/usecases/is_logged_in.dart';
import 'package:mechine_test_flutter/features/auth/domain/usecases/user_sign_in.dart';
import 'package:mechine_test_flutter/features/auth/domain/usecases/user_sign_out.dart';
import 'package:mechine_test_flutter/features/auth/domain/usecases/user_sign_up.dart';
import 'package:mechine_test_flutter/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:mechine_test_flutter/features/home/data/repo_impl/product_repo_impl.dart';
import 'package:mechine_test_flutter/features/home/domain/repositories/product_repository.dart';
import 'package:mechine_test_flutter/features/home/domain/usecases/fetch_data_from_api.dart';
import 'package:mechine_test_flutter/features/home/presentation/bloc/product_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'features/auth/data/repo_impl/auth_rep_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependecies() async {
  final firebase = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  serviceLocator.registerFactory<FirebaseAuth>(
      () => FirebaseAuth.instanceFor(app: firebase));
  serviceLocator.registerFactory<FirebaseFirestore>(
      () => FirebaseFirestore.instanceFor(app: firebase));

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'data'));

  _initAuth();
  _initHome();
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
          serviceLocator(),
        ))
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator<AuthRemoteDataSource>(),
        serviceLocator<AuthLocalDataSource>(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignIn(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignOut(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => IsLoggedInCheck(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton<LoggedInCubit>(() => LoggedInCubit())
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        userSignOut: serviceLocator(),
        isLoggedInCheck: serviceLocator(),
        loggedInCubit: serviceLocator(),
      ),
    );
}

void _initHome() {
  // Datasource
  serviceLocator
    ..registerFactory<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(),
    )
    // Repository
    ..registerFactory<ProductRepository>(
      () => ProductRepoImpl(
        serviceLocator<HomeRemoteDataSource>(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => FetchDataFromApi(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => ProductBloc(
        fetchDataFromApi: serviceLocator(),
      ),
    );
}
