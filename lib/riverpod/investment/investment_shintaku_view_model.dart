import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

//////////////////////////////////////////////////////////////////////

final investmentShintakuProvider = StateNotifierProvider.autoDispose<
    InvestmentShintakuStateNotifier, List<dynamic>>((ref) {
  return InvestmentShintakuStateNotifier([])..getInvestmentShintakuData();
});

class InvestmentShintakuStateNotifier extends StateNotifier<List<dynamic>> {
  InvestmentShintakuStateNotifier(List<dynamic> state) : super(state);

  ///
  void getInvestmentShintakuData() async {
    String url = "http://toyohide.work/BrainLog/api/getShintakuDetail";
    Map<String, String> headers = {'content-type': 'application/json'};
    Response response = await post(Uri.parse(url), headers: headers);
    final investmentShintaku = jsonDecode(response.body);
    state = investmentShintaku['data'];
  }
}

//////////////////////////////////////////////////////////////////////
