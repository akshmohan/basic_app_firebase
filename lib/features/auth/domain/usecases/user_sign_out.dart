import 'package:mechine_test_flutter/features/auth/domain/repositories/auth_repository.dart';

class UserSignOut {
  final AuthRepository authRepository;

  UserSignOut(this.authRepository);

  Future<void> call() async {
    await authRepository.signOut();
  }
}
