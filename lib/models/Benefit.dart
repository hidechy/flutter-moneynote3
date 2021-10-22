// To parse this JSON data, do
//
//     final benefit = benefitFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

Benefit benefitFromJson(String str) => Benefit.fromJson(json.decode(str));

String benefitToJson(Benefit data) => json.encode(data.toJson());

///
class Benefit {
  Benefit({
    required this.data,
  });

  List<String> data;

  factory Benefit.fromJson(Map<String, dynamic> json) => Benefit(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
