import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'month_summary_model.dart';

import 'dart:convert';

import 'package:http/http.dart';

//////////////////////////////////////////////////////////////////////
final monthSummaryProvider = StateNotifierProvider.autoDispose
    .family<MonthSummaryStateNotifier, List<MonthSummaryData>, String>(
        (ref, date) {
  return MonthSummaryStateNotifier([])..getMonthSummaryData(date: date);
});

class MonthSummaryStateNotifier extends StateNotifier<List<MonthSummaryData>> {
  MonthSummaryStateNotifier(List<MonthSummaryData> state) : super(state);

  ///
  void getMonthSummaryData({required String date}) async {
    String url = "http://toyohide.work/BrainLog/api/monthsummary";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    final monthSummary = monthSummaryFromJson(response.body);
    state = monthSummary.data;
  }
}

//////////////////////////////////////////////////////////////////////
