// To parse this JSON data, do
//
//     final money = moneyFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

Money moneyFromJson(String str) => Money.fromJson(json.decode(str));

String moneyToJson(Money data) => json.encode(data.toJson());

///
class Money {
  Money({
    required this.data,
  });

  List<String> data;

  factory Money.fromJson(Map<String, dynamic> json) => Money(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
