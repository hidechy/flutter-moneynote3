// To parse this JSON data, do
//
//     final benefitSummaryRecord = benefitSummaryRecordFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

BenefitSummaryRecord benefitSummaryRecordFromJson(String str) =>
    BenefitSummaryRecord.fromJson(json.decode(str));

String benefitSummaryRecordToJson(BenefitSummaryRecord data) =>
    json.encode(data.toJson());

///
class BenefitSummaryRecord {
  BenefitSummaryRecord({
    required this.data,
  });

  List<BenefitSummary> data;

  factory BenefitSummaryRecord.fromJson(Map<String, dynamic> json) =>
      BenefitSummaryRecord(
        data: List<BenefitSummary>.from(
            json["data"].map((x) => BenefitSummary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

///
class BenefitSummary {
  BenefitSummary({
    required this.year,
    required this.salary,
  });

  int year;
  String salary;

  factory BenefitSummary.fromJson(Map<String, dynamic> json) => BenefitSummary(
        year: json["year"],
        salary: json["salary"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "salary": salary,
      };
}
