// To parse this JSON data, do
//
//     final shintakuDetail = shintakuDetailFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ShintakuDetail shintakuDetailFromJson(String str) =>
    ShintakuDetail.fromJson(json.decode(str));

String shintakuDetailToJson(ShintakuDetail data) => json.encode(data.toJson());

///
class ShintakuDetail {
  ShintakuDetail({
    required this.data,
  });

  List<String> data;

  factory ShintakuDetail.fromJson(Map<String, dynamic> json) => ShintakuDetail(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
