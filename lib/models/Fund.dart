// To parse this JSON data, do
//
//     final fund = fundFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

Fund fundFromJson(String str) => Fund.fromJson(json.decode(str));

String fundToJson(Fund data) => json.encode(data.toJson());

///
class Fund {
  Fund({
    required this.data,
  });

  List<String> data;

  factory Fund.fromJson(Map<String, dynamic> json) => Fund(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
