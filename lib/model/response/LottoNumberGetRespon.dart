import 'dart:convert';

List<LottoNumberGetRespon> lottoNumberGetResponFromJson(String str) =>
    List<LottoNumberGetRespon>.from(
        json.decode(str).map((x) => LottoNumberGetRespon.fromJson(x)));

String lottoNumberGetResponToJson(List<LottoNumberGetRespon> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LottoNumberGetRespon {
  int lottoNumberId;
  dynamic memberId;
  String lottoNumber;
  DateTime purchaseDate;
  int amount;

  LottoNumberGetRespon({
    required this.lottoNumberId,
    required this.memberId,
    required this.lottoNumber,
    required this.purchaseDate,
    required this.amount,
  });

  factory LottoNumberGetRespon.fromJson(Map<String, dynamic> json) =>
      LottoNumberGetRespon(
        lottoNumberId: json["lotto_number_id"],
        memberId: json["member_id"],
        lottoNumber: json["lotto_number"],
        purchaseDate: DateTime.parse(json["purchase_date"]),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "lotto_number_id": lottoNumberId,
        "member_id": memberId,
        "lotto_number": lottoNumber,
        "purchase_date": purchaseDate.toIso8601String(),
        "amount": amount,
      };
}
