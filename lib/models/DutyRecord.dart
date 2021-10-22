// To parse this JSON data, do
//
//     final dutyDataRecord = dutyDataRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

DutyRecord dutyDataRecordFromJson(String str) =>
    DutyRecord.fromJson(json.decode(str));

String dutyDataRecordToJson(DutyRecord data) => json.encode(data.toJson());

///
class DutyRecord {
  DutyRecord({
    required this.data,
  });

  Duty data;

  factory DutyRecord.fromJson(Map<String, dynamic> json) => DutyRecord(
        data: Duty.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

///
class Duty {
  Duty({
    required this.zeikin,
    required this.nenkin,
    required this.nenkinkikin,
    required this.kenkouhoken,
  });

  List<String> zeikin;
  List<String> nenkin;
  List<String> nenkinkikin;
  List<String> kenkouhoken;

  factory Duty.fromJson(Map<String, dynamic> json) => Duty(
        zeikin: List<String>.from(json["税金"].map((x) => x)),
        nenkin: List<String>.from(json["年金"].map((x) => x)),
        nenkinkikin: List<String>.from(json["国民年金基金"].map((x) => x)),
        kenkouhoken: List<String>.from(json["国民健康保険"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "税金": List<dynamic>.from(zeikin.map((x) => x)),
        "年金": List<dynamic>.from(nenkin.map((x) => x)),
        "国民年金基金": List<dynamic>.from(nenkinkikin.map((x) => x)),
        "国民健康保険": List<dynamic>.from(kenkouhoken.map((x) => x)),
      };
}
