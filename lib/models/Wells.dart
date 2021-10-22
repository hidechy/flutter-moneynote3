// To parse this JSON data, do
//
//     final wells = wellsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

Wells wellsFromJson(String str) => Wells.fromJson(json.decode(str));

String wellsToJson(Wells data) => json.encode(data.toJson());

///
class Wells {
  Wells({
    required this.data,
  });

  List<String> data;

  factory Wells.fromJson(Map<String, dynamic> json) => Wells(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
