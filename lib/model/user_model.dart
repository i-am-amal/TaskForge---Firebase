import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? uid;
  String? password;
  int? status;
  DateTime? createdAt;

  UserModel(
      {this.createdAt,
      this.email,
      this.name,
      this.password,
      this.status,
      this.uid});

  factory UserModel.fromJson(DocumentSnapshot data) {
    return UserModel(
        email: data['email'],
        name: data['name'],
        uid: data['uid'],
        createdAt: data['createdAt'],
        status: data['status']);
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "password": password,
      "status": status,
      "createdAt": createdAt
    };
  }
}
