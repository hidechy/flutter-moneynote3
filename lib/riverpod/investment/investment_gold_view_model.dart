import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../models/GoldRecord.dart';

final investmentGoldProvider =
    StateNotifierProvider.autoDispose<InvestmentGoldStateNotifier, List<Gold>>(
        (ref) {
  return InvestmentGoldStateNotifier([])..getInvestmentGoldData();
});

class InvestmentGoldStateNotifier extends StateNotifier<List<Gold>> {
  InvestmentGoldStateNotifier(List<Gold> state) : super(state);

  ///
  void getInvestmentGoldData() async {
    String url = "http://toyohide.work/BrainLog/api/getgolddata";
    Map<String, String> headers = {'content-type': 'application/json'};
    Response response = await post(Uri.parse(url), headers: headers);
    final goldRecord = jsonDecode(response.body);

    List<Gold> list = [];
    for (var i = 0; i < goldRecord['data'].length; i++) {
      if (goldRecord['data'][i]['gold_value'] != '-') {
        list.add(
          Gold(
            year: goldRecord['data'][i]['year'],
            month: goldRecord['data'][i]['month'],
            day: goldRecord['data'][i]['day'],
            goldTanka: goldRecord['data'][i]['gold_tanka'],
            upDown: goldRecord['data'][i]['up_down'],
            diff: goldRecord['data'][i]['diff'],
            gramNum: goldRecord['data'][i]['gram_num'],
            totalGram: goldRecord['data'][i]['total_gram'],
            goldValue: goldRecord['data'][i]['gold_value'],
            goldPrice: goldRecord['data'][i]['gold_price'],
            payPrice: goldRecord['data'][i]['pay_price'],
          ),
        );
      }
    }

    state = list;
  }
}
