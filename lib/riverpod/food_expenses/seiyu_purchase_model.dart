// To parse this JSON data, do
//
//     final seiyuPurchase = seiyuPurchaseFromJson(jsonString);

import 'dart:convert';

SeiyuPurchase seiyuPurchaseFromJson(String str) =>
    SeiyuPurchase.fromJson(json.decode(str));

String seiyuPurchaseToJson(SeiyuPurchase data) => json.encode(data.toJson());

class SeiyuPurchase {
  SeiyuPurchase({
    required this.data,
  });

  List<SeiyuPurchaseData> data;

  factory SeiyuPurchase.fromJson(Map<String, dynamic> json) => SeiyuPurchase(
        data: List<SeiyuPurchaseData>.from(
            json["data"].map((x) => SeiyuPurchaseData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SeiyuPurchaseData {
  SeiyuPurchaseData({
    required this.date,
    required this.pos,
    required this.item,
    required this.tanka,
    required this.kosuu,
    required this.price,
    required this.img,
  });

  DateTime date;
  int pos;
  String item;
  String tanka;
  String kosuu;
  String price;
  String img;

  factory SeiyuPurchaseData.fromJson(Map<String, dynamic> json) =>
      SeiyuPurchaseData(
        date: DateTime.parse(json["date"]),
        pos: json["pos"],
        item: json["item"],
        tanka: json["tanka"],
        kosuu: json["kosuu"],
        price: json["price"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "pos": pos,
        "item": item,
        "tanka": tanka,
        "kosuu": kosuu,
        "price": price,
        "img": img,
      };
}
