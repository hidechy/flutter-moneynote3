// To parse this JSON data, do
//
//     final cardItemRecord = cardItemRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

CardItemRecord cardItemRecordFromJson(String str) =>
    CardItemRecord.fromJson(json.decode(str));

String cardItemRecordToJson(CardItemRecord data) => json.encode(data.toJson());

///
class CardItemRecord {
  CardItemRecord({
    required this.data,
  });

  List<CardItem> data;

  factory CardItemRecord.fromJson(Map<String, dynamic> json) => CardItemRecord(
        data:
            List<CardItem>.from(json["data"].map((x) => CardItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class CardItem {
  CardItem({
    required this.payMonth,
    required this.item,
    required this.price,
    required this.date,
    required this.kind,
    required this.monthDiff,
    required this.flag,
  });

  String payMonth;
  String item;
  String price;
  DateTime date;
  String kind;
  int monthDiff;
  int flag;

  factory CardItem.fromJson(Map<String, dynamic> json) => CardItem(
        payMonth: json["pay_month"],
        item: json["item"],
        price: json["price"],
        date: DateTime.parse(json["date"]),
        kind: json["kind"],
        monthDiff: json["month_diff"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "pay_month": payMonth,
        "item": item,
        "price": price,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "kind": kind,
        "month_diff": monthDiff,
        "flag": flag,
      };
}
