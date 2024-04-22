import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? Name;
  String? image;
  String? password;

  UserModel({this.uid, this.email, this.Name, this.image, this.password});

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': Name,
      'image': image,
      'password': password,
    };
  }
}
