// To parse this JSON data, do
//
//     final credit = creditFromJson(jsonString);

import 'dart:convert';

Credit creditFromJson(String str) => Credit.fromJson(json.decode(str));

String creditToJson(Credit data) => json.encode(data.toJson());

class Credit {
  Credit({
    required this.data,
  });

  List<Datum> data;

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.ym,
    required this.date,
    required this.item,
    required this.price,
  });

  String ym;
  DateTime date;
  String item;
  String price;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        ym: json["ym"],
        date: DateTime.parse(json["date"]),
        item: json["item"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "ym": ym,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "item": item,
        "price": price,
      };
}
