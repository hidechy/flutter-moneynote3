// To parse this JSON data, do
//
//     final everydaySpend = everydaySpendFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

EverydaySpend everydaySpendFromJson(String str) =>
    EverydaySpend.fromJson(json.decode(str));

String everydaySpendToJson(EverydaySpend data) => json.encode(data.toJson());

class EverydaySpend {
  EverydaySpend({
    required this.data,
  });

  List<Datum> data;

  factory EverydaySpend.fromJson(Map<String, dynamic> json) => EverydaySpend(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.date,
    required this.spend,
    required this.record,
    required this.diff,
    required this.step,
    required this.distance,
  });

  DateTime date;
  int spend;
  String record;
  int diff;
  String step;
  String distance;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: DateTime.parse(json["date"]),
        spend: json["spend"],
        record: json["record"],
        diff: json["diff"],
        step: json["step"],
        distance: json["distance"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "spend": spend,
        "record": record,
        "diff": diff,
        "step": step,
        "distance": distance,
      };
}
