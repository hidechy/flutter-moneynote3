import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import 'bank_update_state.dart';

//////////////////////////////////////////////////////////////////////

final bankUpdateProvider =
    StateNotifierProvider.autoDispose<BankUpdateStateNotifier, String>((ref) {
  return BankUpdateStateNotifier('');
});

class BankUpdateStateNotifier extends StateNotifier<String> {
  BankUpdateStateNotifier(String state) : super(state);

  void setDate({required String date}) {
    state = date;
  }
}

//////////////////////////////////////////////////////////////////////

final bankMoneyUpdateProvider = StateNotifierProvider.family
    .autoDispose<BankMoneyUpdateStateNotifier, String, BankUpdateState>(
        (ref, param) {
  return BankMoneyUpdateStateNotifier('')..updateBankMoney(param: param);
});

class BankMoneyUpdateStateNotifier extends StateNotifier<String> {
  BankMoneyUpdateStateNotifier(String state) : super(state);

  void updateBankMoney({required BankUpdateState param}) async {
    String url = "http://toyohide.work/BrainLog/api/updateBankMoney";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({
      "date": param.date,
      "bank": param.bank,
      "price": param.price,
    });

    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    state = (response.statusCode == 200) ? "ok" : "ng";
  }
}
