// To parse this JSON data, do
//
//     final amazonPurchaseRecord = amazonPurchaseRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

AmazonPurchaseRecord amazonPurchaseRecordFromJson(String str) =>
    AmazonPurchaseRecord.fromJson(json.decode(str));

String amazonPurchaseRecordToJson(AmazonPurchaseRecord data) =>
    json.encode(data.toJson());

///
class AmazonPurchaseRecord {
  AmazonPurchaseRecord({
    required this.data,
  });

  List<AmazonPurchase> data;

  factory AmazonPurchaseRecord.fromJson(Map<String, dynamic> json) =>
      AmazonPurchaseRecord(
        data: List<AmazonPurchase>.from(
            json["data"].map((x) => AmazonPurchase.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class AmazonPurchase {
  AmazonPurchase({
    required this.date,
    required this.price,
    required this.orderNumber,
    required this.item,
  });

  DateTime date;
  String price;
  String orderNumber;
  String item;

  factory AmazonPurchase.fromJson(Map<String, dynamic> json) => AmazonPurchase(
        date: DateTime.parse(json["date"]),
        price: json["price"],
        orderNumber: json["order_number"],
        item: json["item"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "price": price,
        "order_number": orderNumber,
        "item": item,
      };
}
