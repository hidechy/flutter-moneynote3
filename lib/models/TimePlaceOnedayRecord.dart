// To parse this JSON data, do
//
//     final timePlaceOnedayRecord = timePlaceOnedayRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'TimePlace.dart';

TimePlaceOnedayRecord timePlaceOnedayRecordFromJson(String str) =>
    TimePlaceOnedayRecord.fromJson(json.decode(str));

String timePlaceOnedayRecordToJson(TimePlaceOnedayRecord data) =>
    json.encode(data.toJson());

///
class TimePlaceOnedayRecord {
  TimePlaceOnedayRecord({
    required this.data,
  });

  List<TimePlace> data;

  factory TimePlaceOnedayRecord.fromJson(Map<String, dynamic> json) =>
      TimePlaceOnedayRecord(
        data: List<TimePlace>.from(
            json["data"].map((x) => TimePlace.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
