import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health/data/datasources/datasources.dart';
import 'package:my_health/domain/entities/entities.dart';
import 'package:my_health/domain/repositories/repositories.dart';

class AppUserUseCaseImp implements FirebaseRepository {
  final FirebaseRemoteDataSource dataSource;

  const AppUserUseCaseImp({required this.dataSource});

  @override
  Future<String> getCurrentUID() async {
    return await dataSource.getCurrentUID();
  }

  @override
  Future<UserCredential> signUp(String email, String password) async {
    return await dataSource.signUp(email, password);
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    return await dataSource.getCreateCurrentUser(user);
  }
}
