// To parse this JSON data, do
//
//     final summaryRecord = summaryRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

SummaryRecord summaryRecordFromJson(String str) =>
    SummaryRecord.fromJson(json.decode(str));

String summaryRecordToJson(SummaryRecord data) => json.encode(data.toJson());

///
class SummaryRecord {
  SummaryRecord({
    required this.data,
  });

  List<Summary> data;

  factory SummaryRecord.fromJson(Map<String, dynamic> json) => SummaryRecord(
        data: List<Summary>.from(json["data"].map((x) => Summary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class Summary {
  Summary({
    required this.item,
    required this.sum,
    required this.percent,
  });

  String item;
  int sum;
  int percent;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        item: json["item"],
        sum: json["sum"],
        percent: json["percent"],
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "sum": sum,
        "percent": percent,
      };
}
