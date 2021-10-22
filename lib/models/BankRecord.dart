// To parse this JSON data, do
//
//     final bankRecord = bankRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

BankRecord bankRecordFromJson(String str) =>
    BankRecord.fromJson(json.decode(str));

String bankRecordToJson(BankRecord data) => json.encode(data.toJson());

///
class BankRecord {
  BankRecord({
    required this.data,
  });

  List<Bank> data;

  factory BankRecord.fromJson(Map<String, dynamic> json) => BankRecord(
        data: List<Bank>.from(json["data"].map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class Bank {
  Bank({
    required this.day,
    required this.item,
    required this.price,
    required this.bank,
  });

  String day;
  String item;
  String price;
  String bank;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        day: json["day"],
        item: json["item"],
        price: json["price"],
        bank: json["bank"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "item": item,
        "price": price,
        "bank": bank,
      };
}
