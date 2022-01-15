// To parse this JSON data, do
//
//     final sameSpend = sameSpendFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

SameSpend sameSpendFromJson(String str) => SameSpend.fromJson(json.decode(str));

String sameSpendToJson(SameSpend data) => json.encode(data.toJson());

class SameSpend {
  SameSpend({
    required this.data,
  });

  List<Datum> data;

  factory SameSpend.fromJson(Map<String, dynamic> json) => SameSpend(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.ym,
    required this.sum,
  });

  String ym;
  int sum;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        ym: json["ym"],
        sum: json["sum"],
      );

  Map<String, dynamic> toJson() => {
        "ym": ym,
        "sum": sum,
      };
}
