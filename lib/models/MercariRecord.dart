// To parse this JSON data, do
//
//     final mercariRecord = mercariRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

MercariRecord mercariRecordFromJson(String str) =>
    MercariRecord.fromJson(json.decode(str));

String mercariRecordToJson(MercariRecord data) => json.encode(data.toJson());

///
class MercariRecord {
  MercariRecord({
    required this.data,
  });

  List<Mercari> data;

  factory MercariRecord.fromJson(Map<String, dynamic> json) => MercariRecord(
        data: List<Mercari>.from(json["data"].map((x) => Mercari.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class Mercari {
  Mercari({
    required this.date,
    required this.record,
    required this.dayTotal,
    required this.total,
  });

  DateTime date;
  String record;
  int dayTotal;
  int total;

  factory Mercari.fromJson(Map<String, dynamic> json) => Mercari(
        date: DateTime.parse(json["date"]),
        record: json["record"],
        dayTotal: json["day_total"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "record": record,
        "day_total": dayTotal,
        "total": total,
      };
}
