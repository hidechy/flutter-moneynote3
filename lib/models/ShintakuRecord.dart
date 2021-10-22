// To parse this JSON data, do
//
//     final shintakuRecord = shintakuRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ShintakuRecord shintakuRecordFromJson(String str) =>
    ShintakuRecord.fromJson(json.decode(str));

String shintakuRecordToJson(ShintakuRecord data) => json.encode(data.toJson());

///
class ShintakuRecord {
  ShintakuRecord({
    required this.data,
  });

  Shintaku data;

  factory ShintakuRecord.fromJson(Map<String, dynamic> json) => ShintakuRecord(
        data: Shintaku.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

///
class Shintaku {
  Shintaku({
    required this.cost,
    required this.price,
    required this.diff,
    required this.date,
    required this.record,
  });

  int cost;
  int price;
  int diff;
  DateTime date;
  List<Record> record;

  factory Shintaku.fromJson(Map<String, dynamic> json) => Shintaku(
        cost: json["cost"],
        price: json["price"],
        diff: json["diff"],
        date: DateTime.parse(json["date"]),
        record:
            List<Record>.from(json["record"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cost": cost,
        "price": price,
        "diff": diff,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "record": List<dynamic>.from(record.map((x) => x.toJson())),
      };
}

///
class Record {
  Record({
    required this.name,
    required this.date,
    required this.num,
    required this.shutoku,
    required this.cost,
    required this.price,
    required this.diff,
    required this.data,
  });

  String name;
  DateTime date;
  String num;
  String shutoku;
  String cost;
  String price;
  int diff;
  String data;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        name: json["name"],
        date: DateTime.parse(json["date"]),
        num: json["num"],
        shutoku: json["shutoku"],
        cost: json["cost"],
        price: json["price"],
        diff: json["diff"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "num": num,
        "shutoku": shutoku,
        "cost": cost,
        "price": price,
        "diff": diff,
        "data": data,
      };
}
