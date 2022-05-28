import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../my_state/money_state.dart';
import '../view_model/money_view_model.dart';

import 'bank_input_state.dart';

//////////////////////////////////////////////////////////////////////

final bankProvider =
    StateNotifierProvider.autoDispose<BankStateNotifier, String>((ref) {
  return BankStateNotifier('');
});

class BankStateNotifier extends StateNotifier<String> {
  BankStateNotifier(String state) : super(state);

  void setBank({required String bank}) {
    state = bank;
  }
}

//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////

final bankInputProvider = StateNotifierProvider.autoDispose
    .family<BankInputStateNotifier, List<BankInputState>, String>((ref, bank) {
  final allMoneyState = ref.watch(allMoneyProvider);

  return BankInputStateNotifier([])
    ..getBankInputData(
      bank: bank,
      data: allMoneyState,
    );
});

class BankInputStateNotifier extends StateNotifier<List<BankInputState>> {
  BankInputStateNotifier(List<BankInputState> state) : super(state);

  ///
  void getBankInputData(
      {required String bank, required List<MoneyState> data}) async {
    List<BankInputState> _list = [];

    var lastChangeDate = '';
//    var skipFlag = true;
    for (var i = 0; i < data.length; i++) {
      var _price = 0;
      var _prev = 0;
      switch (bank) {
        case 'bank_a':
          _price = data[i].bankA;
          if (i > 0) _prev = data[i - 1].bankA;
          break;
        case 'bank_b':
          _price = data[i].bankB;
          if (i > 0) _prev = data[i - 1].bankB;
          break;
        case 'bank_c':
          _price = data[i].bankC;
          if (i > 0) _prev = data[i - 1].bankC;
          break;
        case 'bank_d':
          _price = data[i].bankD;
          if (i > 0) _prev = data[i - 1].bankD;
          break;
        case 'bank_e':
          _price = data[i].bankE;
          if (i > 0) _prev = data[i - 1].bankE;
          break;

        case 'pay_a':
          _price = data[i].peyA;
          if (i > 0) _prev = data[i - 1].peyA;
          break;
        case 'pay_b':
          _price = data[i].peyB;
          if (i > 0) _prev = data[i - 1].peyB;
          break;
        case 'pay_c':
          _price = data[i].peyC;
          if (i > 0) _prev = data[i - 1].peyC;
          break;
        case 'pay_d':
          _price = data[i].peyD;
          if (i > 0) _prev = data[i - 1].peyD;
          break;
        case 'pay_e':
          _price = data[i].peyE;
          if (i > 0) _prev = data[i - 1].peyE;
          break;
      }

      // //----------------------------//
      // if (skipFlag) {
      //   if (_price > 0) {
      //     skipFlag = false;
      //   }
      //
      //   if (_price == 0) {
      //     continue;
      //   }
      // }
      // //----------------------------//

      var diff = _price - _prev;

      var changeFlag = (_price != _prev) ? true : false;
      var upFlag = (_price > _prev) ? true : false;

      if (changeFlag) {
        lastChangeDate = data[i].date;
      }

      _list.add(
        BankInputState(
          date: data[i].date,
          price: _price,
          diff: diff,
          changeFlag: changeFlag,
          upFlag: upFlag,
          lastChangeDate: lastChangeDate,
        ),
      );
    }

    state = _list;
  }
}

//////////////////////////////////////////////////////////////////////
