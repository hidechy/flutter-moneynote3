// To parse this JSON data, do
//
//     final spendItemWeeklyRecord = spendItemWeeklyRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

SpendItemWeeklyRecord spendItemWeeklyRecordFromJson(String str) =>
    SpendItemWeeklyRecord.fromJson(json.decode(str));

String spendItemWeeklyRecordToJson(SpendItemWeeklyRecord data) =>
    json.encode(data.toJson());

///
class SpendItemWeeklyRecord {
  SpendItemWeeklyRecord({
    required this.data,
  });

  List<SpendItemWeekly> data;

  factory SpendItemWeeklyRecord.fromJson(Map<String, dynamic> json) =>
      SpendItemWeeklyRecord(
        data: List<SpendItemWeekly>.from(
            json["data"].map((x) => SpendItemWeekly.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class SpendItemWeekly {
  SpendItemWeekly({
    required this.date,
    required this.koumoku,
    this.price,
  });

  DateTime date;
  String koumoku;
  dynamic price;

  factory SpendItemWeekly.fromJson(Map<String, dynamic> json) =>
      SpendItemWeekly(
        date: DateTime.parse(json["date"]),
        koumoku: json["koumoku"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "koumoku": koumoku,
        "price": price,
      };
}
