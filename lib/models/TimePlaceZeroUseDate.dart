// To parse this JSON data, do
//
//     final timePlaceZeroUseDate = timePlaceZeroUseDateFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

TimePlaceZeroUseDate timePlaceZeroUseDateFromJson(String str) =>
    TimePlaceZeroUseDate.fromJson(json.decode(str));

String timePlaceZeroUseDateToJson(TimePlaceZeroUseDate data) =>
    json.encode(data.toJson());

///
class TimePlaceZeroUseDate {
  TimePlaceZeroUseDate({
    required this.data,
  });

  List<DateTime> data;

  factory TimePlaceZeroUseDate.fromJson(Map<String, dynamic> json) =>
      TimePlaceZeroUseDate(
        data: List<DateTime>.from(json["data"].map((x) => DateTime.parse(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
      };
}
