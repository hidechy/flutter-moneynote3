// To parse this JSON data, do
//
//     final timePlaceMonthlyRecord = timePlaceMonthlyRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'TimePlace.dart';

TimePlaceMonthlyRecord timePlaceMonthlyRecordFromJson(String str) =>
    TimePlaceMonthlyRecord.fromJson(json.decode(str));

String timePlaceMonthlyRecordToJson(TimePlaceMonthlyRecord data) =>
    json.encode(data.toJson());

///
class TimePlaceMonthlyRecord {
  TimePlaceMonthlyRecord({
    required this.data,
  });

  Map<String, List<TimePlace>> data;

  factory TimePlaceMonthlyRecord.fromJson(Map<String, dynamic> json) =>
      TimePlaceMonthlyRecord(
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<TimePlace>>(
                k, List<TimePlace>.from(v.map((x) => TimePlace.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}
