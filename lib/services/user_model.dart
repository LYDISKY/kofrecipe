// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String username;
  final String email;
  final String password;
  final String profileImageUrl;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      profileImageUrl: json['profil_image'],
    );
  }

   Future<UserModel> _loadUser() async {
    var InfoUser;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = await _auth.currentUser!;
    final email = user.email;
    var url = Uri.parse('http://192.168.0.110:8000/user/$email/');

    final response = await http.get(url);

    if(response.statusCode == 200){
        final Map<String, dynamic> userData = json.decode(response.body);
        final UserModel utilisateur = UserModel.fromJson(userData);
        print(userData);
        print('Utilisateur trouvé');

        InfoUser = utilisateur;
    }

   
    return InfoUser;
    
  }


}
Future <void> UpdateProfil_image(File ImageFile) async {
  
}
