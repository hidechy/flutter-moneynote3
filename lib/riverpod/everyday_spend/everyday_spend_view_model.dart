// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import 'everyday_spend_state.dart';

//////////////////////////////////////////////////////////////////////

final EverydaySpendProvider = StateNotifierProvider.autoDispose
    .family<EverydaySpendStateNotifier, List<EverydaySpendState>, String>(
        (ref, date) {
  return EverydaySpendStateNotifier([])..getEverydaySpendData(date: date);
});

class EverydaySpendStateNotifier
    extends StateNotifier<List<EverydaySpendState>> {
  EverydaySpendStateNotifier(List<EverydaySpendState> state) : super(state);

  ///
  void getEverydaySpendData({required String date}) async {
    String url = "http://toyohide.work/BrainLog/api/everydaySpendSearch";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    var everydaySpend = jsonDecode(response.body);

    List<EverydaySpendState> _list = [];
    for (var i = 0; i < everydaySpend['data'].length; i++) {
      _list.add(
        EverydaySpendState(
          date: everydaySpend['data'][i]['date'],
          spend: everydaySpend['data'][i]['spend'],
          record: everydaySpend['data'][i]['record'],
          diff: everydaySpend['data'][i]['diff'],
          step: everydaySpend['data'][i]['step'],
          distance: everydaySpend['data'][i]['distance'],
        ),
      );
    }

    state = _list;
  }
}

//////////////////////////////////////////////////////////////////////
