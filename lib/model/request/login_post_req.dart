// To parse this JSON data, do
//
//     final loginPostReq = loginPostReqFromJson(jsonString);

import 'dart:convert';

LoginPostReq loginPostReqFromJson(String str) =>
    LoginPostReq.fromJson(json.decode(str));

String loginPostReqToJson(LoginPostReq data) => json.encode(data.toJson());

class LoginPostReq {
  String email;
  String password;

  LoginPostReq({
    required this.email,
    required this.password,
  });

  factory LoginPostReq.fromJson(Map<String, dynamic> json) => LoginPostReq(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
