// To parse this JSON data, do
//
//     final loginPostRes = loginPostResFromJson(jsonString);

import 'dart:convert';

LoginPostRes loginPostResFromJson(String str) =>
    LoginPostRes.fromJson(json.decode(str));

String loginPostResToJson(LoginPostRes data) => json.encode(data.toJson());

class LoginPostRes {
  String memberId;
  String username;
  String email;
  String password;
  String walletBalance;
  String type;

  LoginPostRes({
    required this.memberId,
    required this.username,
    required this.email,
    required this.password,
    required this.walletBalance,
    required this.type,
  });

  factory LoginPostRes.fromJson(Map<String, dynamic> json) => LoginPostRes(
        memberId: json["member_id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        walletBalance: json["wallet_balance"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "username": username,
        "email": email,
        "password": password,
        "wallet_balance": walletBalance,
        "type": type,
      };
}
