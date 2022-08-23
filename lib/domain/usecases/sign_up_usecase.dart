import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health/domain/repositories/repositories.dart';

class GetCreateCurrentUser {
  final FirebaseRepository repository;

  GetCreateCurrentUser({required this.repository});

  Future<UserCredential> call(String email, String password) async {
    return await repository.signUp(email, password);
  }
}
