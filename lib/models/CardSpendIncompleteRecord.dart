// To parse this JSON data, do
//
//     final cardSpendIncompleteRecord = cardSpendIncompleteRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

CardSpendIncompleteRecord cardSpendIncompleteRecordFromJson(String str) =>
    CardSpendIncompleteRecord.fromJson(json.decode(str));

String cardSpendIncompleteRecordToJson(CardSpendIncompleteRecord data) =>
    json.encode(data.toJson());

///
class CardSpendIncompleteRecord {
  CardSpendIncompleteRecord({
    required this.data,
  });

  List<CardSpendIncomplete> data;

  factory CardSpendIncompleteRecord.fromJson(Map<String, dynamic> json) =>
      CardSpendIncompleteRecord(
        data: List<CardSpendIncomplete>.from(
            json["data"].map((x) => CardSpendIncomplete.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class CardSpendIncomplete {
  CardSpendIncomplete({
    required this.item,
    required this.price,
    required this.date,
    required this.kind,
  });

  String item;
  String price;
  DateTime date;
  String kind;

  factory CardSpendIncomplete.fromJson(Map<String, dynamic> json) =>
      CardSpendIncomplete(
        item: json["item"],
        price: json["price"],
        date: DateTime.parse(json["date"]),
        kind: json["kind"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "price": price,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "kind": kind,
      };
}
