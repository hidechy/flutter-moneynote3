// To parse this JSON data, do
//
//     final timePlaceWeeklyRecord = timePlaceWeeklyRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

TimePlaceWeeklyRecord timePlaceWeeklyRecordFromJson(String str) =>
    TimePlaceWeeklyRecord.fromJson(json.decode(str));

String timePlaceWeeklyRecordToJson(TimePlaceWeeklyRecord data) =>
    json.encode(data.toJson());

///
class TimePlaceWeeklyRecord {
  TimePlaceWeeklyRecord({
    required this.data,
  });

  List<TimePlaceWeekly> data;

  factory TimePlaceWeeklyRecord.fromJson(Map<String, dynamic> json) =>
      TimePlaceWeeklyRecord(
        data: List<TimePlaceWeekly>.from(
            json["data"].map((x) => TimePlaceWeekly.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class TimePlaceWeekly {
  TimePlaceWeekly({
    required this.date,
    required this.time,
    required this.place,
    required this.price,
  });

  DateTime date;
  String time;
  String place;
  int price;

  factory TimePlaceWeekly.fromJson(Map<String, dynamic> json) =>
      TimePlaceWeekly(
        date: DateTime.parse(json["date"]),
        time: json["time"],
        place: json["place"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "place": place,
        "price": price,
      };
}
