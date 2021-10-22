// To parse this JSON data, do
//
//     final stockRecord = stockRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

StockRecord stockRecordFromJson(String str) =>
    StockRecord.fromJson(json.decode(str));

String stockRecordToJson(StockRecord data) => json.encode(data.toJson());

///
class StockRecord {
  StockRecord({
    required this.data,
  });

  Stock data;

  factory StockRecord.fromJson(Map<String, dynamic> json) => StockRecord(
        data: Stock.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

///
class Stock {
  Stock({
    required this.cost,
    required this.price,
    required this.diff,
    required this.date,
    required this.record,
  });

  int cost;
  int price;
  int diff;
  DateTime date;
  List<Record> record;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        cost: json["cost"],
        price: json["price"],
        diff: json["diff"],
        date: DateTime.parse(json["date"]),
        record:
            List<Record>.from(json["record"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cost": cost,
        "price": price,
        "diff": diff,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "record": List<dynamic>.from(record.map((x) => x.toJson())),
      };
}

///
class Record {
  Record({
    required this.name,
    required this.date,
    required this.num,
    required this.oneStock,
    required this.cost,
    required this.price,
    required this.diff,
    required this.data,
  });

  String name;
  DateTime date;
  int num;
  String oneStock;
  int cost;
  String price;
  int diff;
  String data;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        name: json["name"],
        date: DateTime.parse(json["date"]),
        num: json["num"],
        oneStock: json["oneStock"],
        cost: json["cost"],
        price: json["price"],
        diff: json["diff"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "num": num,
        "oneStock": oneStock,
        "cost": cost,
        "price": price,
        "diff": diff,
        "data": data,
      };
}
