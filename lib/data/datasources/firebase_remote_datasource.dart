import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/entities.dart';

abstract class FirebaseRemoteDataSource {
  Future<String> getCurrentUID();
  Future<void> getCreateCurrentUser(UserEntity user);

  Future<UserCredential> signUp(String email, String password);
}
