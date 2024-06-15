import 'package:intl/intl.dart';

class UserModel {
  final String userkey;
  final String name;
  final String email;
  final String pw;
  final String ph_num;

  UserModel({
    required this.userkey,
    required this.name,
    required this.email,
    required this.pw,
    required this.ph_num,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    final userkey = json['userkey'];
    final name = json['name'];
    final email = json['email'];
    final pw = json['pw'];
    final ph_num = json['ph_num'];
    return UserModel(userkey: userkey, name: name, email: email, pw: pw, ph_num: ph_num);
  }

  static fromMap(Map<dynamic, dynamic> uservalue){
    var userkey = uservalue["userkey"] ?? '';
    var name = uservalue["name"] ?? '';
    var email = uservalue["email"] ?? '';
    var pw = uservalue["pw"] ?? '';
    var ph_num =uservalue["ph_num"] ?? '';

    return UserModel(
      userkey: userkey,
      name: name,
      email: email,
      pw: pw,
      ph_num: ph_num
    );
  }
}