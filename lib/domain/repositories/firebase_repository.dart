import 'package:firebase_auth/firebase_auth.dart';

import '../entities/entities.dart';

abstract class FirebaseRepository {
  Future<UserCredential> signUp(String email, String password);
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<String> getCurrentUID();
}
