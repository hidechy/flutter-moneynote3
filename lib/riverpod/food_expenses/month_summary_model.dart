// To parse this JSON data, do
//
//     final monthSummary = monthSummaryFromJson(jsonString);

import 'dart:convert';

MonthSummary monthSummaryFromJson(String str) =>
    MonthSummary.fromJson(json.decode(str));

String monthSummaryToJson(MonthSummary data) => json.encode(data.toJson());

class MonthSummary {
  MonthSummary({
    required this.data,
  });

  List<MonthSummaryData> data;

  factory MonthSummary.fromJson(Map<String, dynamic> json) => MonthSummary(
        data: List<MonthSummaryData>.from(
            json["data"].map((x) => MonthSummaryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MonthSummaryData {
  MonthSummaryData({
    required this.item,
    required this.sum,
    required this.percent,
  });

  String item;
  int sum;
  int percent;

  factory MonthSummaryData.fromJson(Map<String, dynamic> json) =>
      MonthSummaryData(
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
