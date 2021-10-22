// To parse this JSON data, do
//
//     final seiyuuPurchaseRecord = seiyuuPurchaseRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

SeiyuuPurchaseRecord seiyuuPurchaseRecordFromJson(String str) =>
    SeiyuuPurchaseRecord.fromJson(json.decode(str));

String seiyuuPurchaseRecordToJson(SeiyuuPurchaseRecord data) =>
    json.encode(data.toJson());

///
class SeiyuuPurchaseRecord {
  SeiyuuPurchaseRecord({
    required this.data,
  });

  List<SeiyuuPurchase> data;

  factory SeiyuuPurchaseRecord.fromJson(Map<String, dynamic> json) =>
      SeiyuuPurchaseRecord(
        data: List<SeiyuuPurchase>.from(
            json["data"].map((x) => SeiyuuPurchase.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class SeiyuuPurchase {
  SeiyuuPurchase({
    required this.date,
    required this.pos,
    required this.item,
    required this.tanka,
    required this.kosuu,
    required this.price,
  });

  DateTime date;
  int pos;
  String item;
  String tanka;
  String kosuu;
  String price;

  factory SeiyuuPurchase.fromJson(Map<String, dynamic> json) => SeiyuuPurchase(
        date: DateTime.parse(json["date"]),
        pos: json["pos"],
        item: json["item"],
        tanka: json["tanka"],
        kosuu: json["kosuu"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "pos": pos,
        "item": item,
        "tanka": tanka,
        "kosuu": kosuu,
        "price": price,
      };
}
