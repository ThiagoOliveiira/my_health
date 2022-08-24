import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../domain/entities/entities.dart';

abstract class FirebaseeAuthPresenter {
  RxBool get isLoading;

  Future<void> getCreateCurrentUser(UserEntity user);
  Future<UserCredential> signUp(String email, String password);
}
