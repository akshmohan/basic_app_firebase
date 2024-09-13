import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mechine_test_flutter/core/errors/server_exception.dart';
import 'package:mechine_test_flutter/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required DateTime createdAt,
  });

  Future<void> saveToFirestore({
    required String name,
    required String email,
    required String password,
    required String uid,
    required DateTime createdAt,
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    required DateTime createdAt,
  }) async {
    try {
      final response = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (response.user == null) {
        throw ServerException("User is null");
      }

      final uid = response.user!.uid;

      //CALLING 'saveToFirestore' FUNCTION HERE, CREATED DOWN BELOW
      await saveToFirestore(
        name: name,
        email: email,
        password: password,
        uid: uid,
        createdAt: createdAt,
      );

      UserModel userModel = UserModel(
        name: name,
        email: email,
        password: password,
        createdAt: DateTime.now(),
      );

      return userModel;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> saveToFirestore({
    required String name,
    required String email,
    required String password,
    required String uid,
    required DateTime createdAt,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'password': password,
        'uid': uid,
        'createdAt': createdAt.toIso8601String()
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException("User is null");
      }

      final uid = response.user!.uid;

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw ServerException("User data not found in Firestore!");
      }

      final data = userDoc.data()!;

      UserModel userModel = UserModel(
        name: data['name'],
        email: data['email'],
        password: data['password'],
        createdAt: DateTime.parse(data['createdAt']),
      );

      return userModel;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
