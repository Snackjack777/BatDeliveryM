// To parse this JSON data, do
//
//     final registerUserPostRes = registerUserPostResFromJson(jsonString);

import 'dart:convert';

RegisterUserPostRes registerUserPostResFromJson(String str) =>
    RegisterUserPostRes.fromJson(json.decode(str));

String registerUserPostResToJson(RegisterUserPostRes data) =>
    json.encode(data.toJson());

class RegisterUserPostRes {
  String username;
  String password;
  String email;
  String walletBalance;
  String type;

  RegisterUserPostRes({
    required this.username,
    required this.password,
    required this.email,
    required this.walletBalance,
    required this.type,
  });

  factory RegisterUserPostRes.fromJson(Map<String, dynamic> json) =>
      RegisterUserPostRes(
        username: json["username"],
        password: json["password"],
        email: json["email"],
        walletBalance: json["wallet_balance"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "email": email,
        "wallet_balance": walletBalance,
        "type": type,
      };
}
