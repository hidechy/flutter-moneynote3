// To parse this JSON data, do
//
//     final allCardSpendRecord = allCardSpendRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

CardSpendRecord allCardSpendRecordFromJson(String str) =>
    CardSpendRecord.fromJson(json.decode(str));

String allCardSpendRecordToJson(CardSpendRecord data) =>
    json.encode(data.toJson());

///
class CardSpendRecord {
  CardSpendRecord({
    required this.data,
  });

  List<CardSpend> data;

  factory CardSpendRecord.fromJson(Map<String, dynamic> json) =>
      CardSpendRecord(
        data: List<CardSpend>.from(
            json["data"].map((x) => CardSpend.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class CardSpend {
  CardSpend({
    required this.payMonth,
    required this.item,
    required this.price,
    required this.date,
    required this.kind,
    required this.monthDiff,
  });

  String payMonth;
  String item;
  String price;
  DateTime date;
  String kind;
  int monthDiff;

  factory CardSpend.fromJson(Map<String, dynamic> json) => CardSpend(
        payMonth: json["pay_month"],
        item: json["item"],
        price: json["price"],
        date: DateTime.parse(json["date"]),
        kind: json["kind"],
        monthDiff: json["month_diff"],
      );

  Map<String, dynamic> toJson() => {
        "pay_month": payMonth,
        "item": item,
        "price": price,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "kind": kind,
        "month_diff": monthDiff,
      };
}
