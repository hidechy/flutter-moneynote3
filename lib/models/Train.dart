// To parse this JSON data, do
//
//     final train = trainFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

Train trainFromJson(String str) => Train.fromJson(json.decode(str));

String trainToJson(Train data) => json.encode(data.toJson());

///
class Train {
  Train({
    required this.data,
  });

  Map<String, String> data;

  factory Train.fromJson(Map<String, dynamic> json) => Train(
        data: Map.from(json["data"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
