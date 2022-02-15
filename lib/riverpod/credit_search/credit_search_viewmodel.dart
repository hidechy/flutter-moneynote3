import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'credit.dart';

///
final creditSearchProvider =
    FutureProvider.autoDispose.family<Credit, String>((ref, company) async {
  return CreditSearchViewmodel().getData(company);
});

///
class CreditSearchViewmodel {
  Future<Credit> getData(String company) async {
    try {
      String url = "http://toyohide.work/BrainLog/api/creditCompanySearch";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"company": company});

      Response response =
          await post(Uri.parse(url), headers: headers, body: body);

      final credit = creditFromJson(response.body);
      return credit;
    } catch (e) {
      throw e.toString();
    }
  }
}
