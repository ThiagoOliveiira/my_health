import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health/data/datasources/datasources.dart';
import 'package:my_health/data/models/models.dart';
import 'package:my_health/domain/entities/entities.dart';

class FirebaseAuthDataSourceImp implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;

  final FirebaseFirestore firestore;

  FirebaseAuthDataSourceImp({required this.auth, required this.firestore});

  @override
  Future<UserCredential> signUp(String email, String password) {
    return auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = firestore.collection("users");
    final uid = await getCurrentUID();

    userCollection.doc(uid).get().then((userDoc) {
      dynamic newUser = UserModel(
        uid: uid,
        email: user.email,
        name: user.name,
      );
      if (!userDoc.exists) {
        // create new user
        userCollection.doc(uid).set(newUser);
      } else {
        // update user doc
        userCollection.doc(uid).update(newUser);
      }
    });
  }

  @override
  Future<String> getCurrentUID() async => auth.currentUser!.uid;
}
