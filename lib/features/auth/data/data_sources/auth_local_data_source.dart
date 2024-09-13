import 'package:mechine_test_flutter/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';

abstract interface class AuthLocalDataSource {
  void uploadUserDataToHive(UserModel user);

  UserModel? checkUserLoggedIn();

  Future<void> signOut();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box box;

  AuthLocalDataSourceImpl(this.box);

  @override
  void uploadUserDataToHive(UserModel user) {
    box.write(() {
      box.put('user', user.toJson());
    });
  }

  @override
  UserModel? checkUserLoggedIn() {
    final result = box.get('user');
    print(result);
    if (result != null) {
      return UserModel.fromJson(result);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    box.clear();
  }
}
