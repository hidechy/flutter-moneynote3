import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bank.dart';

///
final bankSearchProvider =
    FutureProvider.autoDispose.family<Bank, String>((ref, ginkou) async {
  return BankSearchViewmodel().getData(ginkou);
});

///
class BankSearchViewmodel {
  Future<Bank> getData(String ginkou) async {
    try {
      String url = "http://toyohide.work/BrainLog/api/bankSearch";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"bank": ginkou});

      Response response =
          await post(Uri.parse(url), headers: headers, body: body);

      final bank = bankFromJson(response.body);
      return bank;
    } catch (e) {
      throw e.toString();
    }
  }
}
