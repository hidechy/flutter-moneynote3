// To parse this JSON data, do
//
//     final monthStartMoneyRecord = monthStartMoneyRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

MoneyMonthStartRecord monthStartMoneyRecordFromJson(String str) =>
    MoneyMonthStartRecord.fromJson(json.decode(str));

String monthStartMoneyRecordToJson(MoneyMonthStartRecord data) =>
    json.encode(data.toJson());

///
class MoneyMonthStartRecord {
  MoneyMonthStartRecord({
    required this.data,
  });

  List<MonthStartMoney> data;

  factory MoneyMonthStartRecord.fromJson(Map<String, dynamic> json) =>
      MoneyMonthStartRecord(
        data: List<MonthStartMoney>.from(
            json["data"].map((x) => MonthStartMoney.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class MonthStartMoney {
  MonthStartMoney({
    required this.year,
    required this.price,
    required this.manen,
    required this.updown,
    required this.sagaku,
  });

  int year;
  String price;
  String manen;
  String updown;
  String sagaku;

  factory MonthStartMoney.fromJson(Map<String, dynamic> json) =>
      MonthStartMoney(
        year: json["year"],
        price: json["price"],
        manen: json["manen"],
        updown: json["updown"],
        sagaku: json["sagaku"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "price": price,
        "manen": manen,
        "updown": updown,
        "sagaku": sagaku,
      };
}
