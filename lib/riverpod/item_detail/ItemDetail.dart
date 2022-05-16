// To parse this JSON data, do
//
//     final itemDetail = itemDetailFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

ItemDetail itemDetailFromJson(String str) =>
    ItemDetail.fromJson(json.decode(str));

String itemDetailToJson(ItemDetail data) => json.encode(data.toJson());

class ItemDetail {
  ItemDetail({
    required this.data,
  });

  List<Detail> data;

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
        data: List<Detail>.from(json["data"].map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    required this.date,
    required this.price,
  });

  DateTime date;
  String price;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        date: DateTime.parse(json["date"]),
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "price": price,
      };
}
