// To parse this JSON data, do
//
//     final trainMonthly = trainMonthlyFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

TrainMonthly trainMonthlyFromJson(String str) =>
    TrainMonthly.fromJson(json.decode(str));

String trainMonthlyToJson(TrainMonthly data) => json.encode(data.toJson());

///
class TrainMonthly {
  TrainMonthly({
    required this.data,
  });

  Map<String, List<String>> data;

  factory TrainMonthly.fromJson(Map<String, dynamic> json) => TrainMonthly(
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<String>>(
                k, List<String>.from(v.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map((k, v) =>
            MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
      };
}
