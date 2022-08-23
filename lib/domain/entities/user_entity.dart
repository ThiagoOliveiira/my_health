import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? email;
  final String? name;

  @override
  List<Object> get props => [uid!, email!, name!];

  const UserEntity({this.uid, this.email, this.name});
}
