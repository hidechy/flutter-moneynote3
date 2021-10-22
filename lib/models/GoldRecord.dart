// To parse this JSON data, do
//
//     final goldRecord = goldRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

GoldRecord goldRecordFromJson(String str) =>
    GoldRecord.fromJson(json.decode(str));

String goldRecordToJson(GoldRecord data) => json.encode(data.toJson());

///
class GoldRecord {
  GoldRecord({
    required this.data,
  });

  List<Gold> data;

  factory GoldRecord.fromJson(Map<String, dynamic> json) => GoldRecord(
        data: List<Gold>.from(json["data"].map((x) => Gold.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class Gold {
  Gold({
    required this.year,
    required this.month,
    required this.day,
    required this.goldTanka,
    this.upDown,
    this.diff,
    this.gramNum,
    this.totalGram,
    this.goldValue,
    required this.goldPrice,
    this.payPrice,
  });

  String year;
  String month;
  String day;
  String goldTanka;
  dynamic upDown;
  dynamic diff;
  dynamic gramNum;
  dynamic totalGram;
  dynamic goldValue;
  String goldPrice;
  dynamic payPrice;

  factory Gold.fromJson(Map<String, dynamic> json) => Gold(
        year: json["year"],
        month: json["month"],
        day: json["day"],
        goldTanka: json["gold_tanka"],
        upDown: json["up_down"],
        diff: json["diff"],
        gramNum: json["gram_num"],
        totalGram: json["total_gram"],
        goldValue: json["gold_value"],
        goldPrice: json["gold_price"],
        payPrice: json["pay_price"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "month": month,
        "day": day,
        "gold_tanka": goldTanka,
        "up_down": upDown,
        "diff": diff,
        "gram_num": gramNum,
        "total_gram": totalGram,
        "gold_value": goldValue,
        "gold_price": goldPrice,
        "pay_price": payPrice,
      };
}
