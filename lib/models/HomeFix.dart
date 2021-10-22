// To parse this JSON data, do
//
//     final homeFix = homeFixFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

HomeFix homeFixFromJson(String str) => HomeFix.fromJson(json.decode(str));

String homeFixToJson(HomeFix data) => json.encode(data.toJson());

///
class HomeFix {
  HomeFix({
    required this.data,
  });

  List<String> data;

  factory HomeFix.fromJson(Map<String, dynamic> json) => HomeFix(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
