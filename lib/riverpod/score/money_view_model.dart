import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import 'money_state.dart';

import '../../utilities/utility.dart';

//////////////////////////////////////////////////////////////////////
final moneyProvider = StateNotifierProvider.autoDispose
    .family<MoneyStateNotifier, MoneyState, String>((ref, date) {
  return MoneyStateNotifier(const MoneyState(
    date: '',
    yen_10000: 0,
    yen_5000: 0,
    yen_2000: 0,
    yen_1000: 0,
    yen_500: 0,
    yen_100: 0,
    yen_50: 0,
    yen_10: 0,
    yen_5: 0,
    yen_1: 0,
    bankA: 0,
    bankB: 0,
    bankC: 0,
    bankD: 0,
    bankE: 0,
    peyA: 0,
    peyB: 0,
    peyC: 0,
    peyD: 0,
    peyE: 0,
    total: 0,
  ))
    ..getMoneyData(date: date);
});

class MoneyStateNotifier extends StateNotifier<MoneyState> {
  MoneyStateNotifier(MoneyState state) : super(state);

  ///
  void getMoneyData({required String date}) async {
    String url = "http://toyohide.work/BrainLog/api/moneydownload";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": date});

    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    var money = jsonDecode(response.body);

    ///////////////////////////////////////////////
    Utility _utility = Utility();

    if (money['data'] != "-") {
      _utility.makeTotal(money['data'], 'one');

      var exMoney = (money['data']).split('|');

      state = state.copyWith(
        date: date,
        yen_10000: int.parse(exMoney[0]),
        yen_5000: int.parse(exMoney[1]),
        yen_2000: int.parse(exMoney[2]),
        yen_1000: int.parse(exMoney[3]),
        yen_500: int.parse(exMoney[4]),
        yen_100: int.parse(exMoney[5]),
        yen_50: int.parse(exMoney[6]),
        yen_10: int.parse(exMoney[7]),
        yen_5: int.parse(exMoney[8]),
        yen_1: int.parse(exMoney[9]),
        bankA: int.parse(exMoney[10]),
        bankB: int.parse(exMoney[11]),
        bankC: int.parse(exMoney[12]),
        bankD: int.parse(exMoney[13]),
        bankE: int.parse(exMoney[14]),
        peyA: int.parse(exMoney[15]),
        peyB: int.parse(exMoney[16]),
        peyC: int.parse(exMoney[17]),
        peyD: int.parse(exMoney[18]),
        peyE: int.parse(exMoney[19]),
        total: _utility.total,
      );
    }

    ///////////////////////////////////////////////
  }
}

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
final allMoneyProvider =
    StateNotifierProvider.autoDispose<AllMoneyStateNotifier, List<MoneyState>>(
        (ref) {
  return AllMoneyStateNotifier([])..getAllMoneyData();
});

class AllMoneyStateNotifier extends StateNotifier<List<MoneyState>> {
  AllMoneyStateNotifier(List<MoneyState> state) : super(state);

  ///
  void getAllMoneyData() async {
    ///////////////////////////////////////////////
    Utility _utility = Utility();
    ///////////////////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getAllMoney";
    Map<String, String> headers = {'content-type': 'application/json'};
    Response response = await post(Uri.parse(url), headers: headers);

    var money = jsonDecode(response.body);

    List<MoneyState> _list = [];
    for (var i = 0; i < money['data'].length; i++) {
      var exMoney = (money['data'][i]).split('|');

      ///////////////////////////////////////////////
      _utility.makeTotal(money['data'][i], 'all');
      ///////////////////////////////////////////////
      _list.add(
        MoneyState(
          date: exMoney[0],
          yen_10000: int.parse(exMoney[2]),
          yen_5000: int.parse(exMoney[3]),
          yen_2000: int.parse(exMoney[4]),
          yen_1000: int.parse(exMoney[5]),
          yen_500: int.parse(exMoney[6]),
          yen_100: int.parse(exMoney[7]),
          yen_50: int.parse(exMoney[8]),
          yen_10: int.parse(exMoney[9]),
          yen_5: int.parse(exMoney[10]),
          yen_1: int.parse(exMoney[11]),
          bankA: int.parse(exMoney[12]),
          bankB: int.parse(exMoney[13]),
          bankC: int.parse(exMoney[14]),
          bankD: int.parse(exMoney[15]),
          bankE: int.parse(exMoney[16]),
          peyA: int.parse(exMoney[17]),
          peyB: int.parse(exMoney[18]),
          peyC: int.parse(exMoney[19]),
          peyD: int.parse(exMoney[20]),
          peyE: int.parse(exMoney[21]),
          total: _utility.total,
        ),
      );
    }

    state = _list;
  }
}

//////////////////////////////////////////////////////////////////////
