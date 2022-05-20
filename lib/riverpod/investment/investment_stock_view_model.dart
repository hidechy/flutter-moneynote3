import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

//////////////////////////////////////////////////////////////////////

final investmentStockProvider = StateNotifierProvider.autoDispose<
    InvestmentStockStateNotifier, List<dynamic>>((ref) {
  return InvestmentStockStateNotifier([])..getInvestmentStockData();
});

class InvestmentStockStateNotifier extends StateNotifier<List<dynamic>> {
  InvestmentStockStateNotifier(List<dynamic> state) : super(state);

  ///
  void getInvestmentStockData() async {
    String url = "http://toyohide.work/BrainLog/api/getStockDetail";
    Map<String, String> headers = {'content-type': 'application/json'};
    Response response = await post(Uri.parse(url), headers: headers);
    final investmentStock = jsonDecode(response.body);
    state = investmentStock['data'];
  }
}

//////////////////////////////////////////////////////////////////////
