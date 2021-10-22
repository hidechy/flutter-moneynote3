// To parse this JSON data, do
//
//     final stockDetail = stockDetailFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

StockDetail stockDetailFromJson(String str) =>
    StockDetail.fromJson(json.decode(str));

String stockDetailToJson(StockDetail data) => json.encode(data.toJson());

///
class StockDetail {
  StockDetail({
    required this.data,
  });

  List<String> data;

  factory StockDetail.fromJson(Map<String, dynamic> json) => StockDetail(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
