import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import 'sameday_spend_state.dart';

//////////////////////////////////////////////////////////////////////

final samedaySpendProvider = StateNotifierProvider.autoDispose
    .family<SamedaySpendStateNotifier, List<SamedaySpendState>, String>(
        (ref, date) {
  return SamedaySpendStateNotifier([])..getSamedaySpendData(date: date);
});

class SamedaySpendStateNotifier extends StateNotifier<List<SamedaySpendState>> {
  SamedaySpendStateNotifier(List<SamedaySpendState> state) : super(state);

  ///
  void getSamedaySpendData({required String date}) async {
    String url = "http://toyohide.work/BrainLog/api/getSamedaySpend";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    var samedaySpend = jsonDecode(response.body);

    List<SamedaySpendState> _list = [];
    for (var i = 0; i < samedaySpend['data'].length; i++) {
      _list.add(
        SamedaySpendState(
          ym: samedaySpend['data'][i]['ym'],
          sum: samedaySpend['data'][i]['sum'],
        ),
      );
    }

    state = _list;
  }
}

//////////////////////////////////////////////////////////////////////
