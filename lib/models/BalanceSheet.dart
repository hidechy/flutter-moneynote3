// To parse this JSON data, do
//
//     final balanceSheet = balanceSheetFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

BalanceSheet balanceSheetFromJson(String str) =>
    BalanceSheet.fromJson(json.decode(str));

String balanceSheetToJson(BalanceSheet data) => json.encode(data.toJson());

///
class BalanceSheet {
  BalanceSheet({
    required this.data,
  });

  List<String> data;

  factory BalanceSheet.fromJson(Map<String, dynamic> json) => BalanceSheet(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
