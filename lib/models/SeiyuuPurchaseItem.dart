// To parse this JSON data, do
//
//     final seiyuuPurchaseItem = seiyuuPurchaseItemFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

SeiyuuPurchaseItem seiyuuPurchaseItemFromJson(String str) =>
    SeiyuuPurchaseItem.fromJson(json.decode(str));

String seiyuuPurchaseItemToJson(SeiyuuPurchaseItem data) =>
    json.encode(data.toJson());

///
class SeiyuuPurchaseItem {
  SeiyuuPurchaseItem({
    required this.data,
    required this.data2,
  });

  List<String> data;
  List<String> data2;

  factory SeiyuuPurchaseItem.fromJson(Map<String, dynamic> json) =>
      SeiyuuPurchaseItem(
        data: List<String>.from(json["data"].map((x) => x)),
        data2: List<String>.from(json["data2"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
        "data2": List<dynamic>.from(data2.map((x) => x)),
      };
}
