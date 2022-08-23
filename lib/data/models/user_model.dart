import '../../domain/entities/entities.dart';

class UserModel {
  final String? uid;
  final String? email;
  final String? name;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
  });

  factory UserModel.fromJson(Map json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
    );
  }

  UserEntity toEntity() => UserEntity(uid: uid, email: email, name: name);
}
