// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/food_expenses/month_summary_model.dart';
import '../riverpod/food_expenses/month_summary_view_model.dart';
import '../riverpod/food_expenses/seiyu_purchase_model.dart';
import '../riverpod/food_expenses/seiyu_purchase_view_model.dart';

import '../utilities/utility.dart';

class FoodExpensesDisplayScreen extends ConsumerWidget {
  FoodExpensesDisplayScreen({Key? key, required this.year, required this.month})
      : super(key: key);

  final String year;
  final String month;

  final Utility _utility = Utility();

  int _monthSpendSum = 0;

  Map<String, dynamic> _foodExpenses = {};

  String _ym = '';
  String _date = '';

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ym = '$year-$month';
    _date = '$year-$month-01';

    final monthSummaryState = ref.watch(monthSummaryProvider(_date));
    final monthSpendSum = getMonthSpendSum(data: monthSummaryState);
    _monthSpendSum = monthSpendSum;

    final seiyuPurchaseState = ref.watch(seiyuPurchaseProvider(_date));

    getFoodExpenses(data: monthSummaryState, data2: seiyuPurchaseState);

    print(_foodExpenses);

    return Container();
  }

  ///
  int getMonthSpendSum({required List<MonthSummaryData> data}) {
    int sum = 0;

    for (var i = 0; i < data.length; i++) {
      sum += data[i].sum;
    }

    return sum;
  }

  ///
  void getFoodExpenses(
      {required List<MonthSummaryData> data,
      required List<SeiyuPurchaseData> data2}) {
    var food = 0;
    var milk = 0;
    var bentou = 0;
    for (var i = 0; i < data.length; i++) {
      switch (data[i].item) {
        case '食費':
          food = data[i].sum;
          break;
        case '牛乳代':
          milk = data[i].sum;
          break;
        case '弁当代':
          bentou = data[i].sum;
          break;
      }
    }

    var seiyu = 0;
    for (var i = 0; i < data2.length; i++) {
      final exDate = data2[i].date.toString().split('-');
      if (_ym == '${exDate[0]}-${exDate[1]}') {
        if (RegExp(r'非食品').hasMatch(data2[i].item)) {
          continue;
        }

        seiyu += int.parse(data2[i].price);
      }
    }

    final sum = (food + milk + bentou + seiyu);

    if (sum == 0) {
      return;
    }

    final wariai = (sum / _monthSpendSum * 100).floor();

    ////////////////////////////////////////
    final now = DateTime.now();
    _utility.makeYMDYData(now.toString(), 0);

    var endDay = 0;
    if ('$year-$month' == '${_utility.year}-${_utility.month}') {
      endDay = int.parse(_utility.day);
    } else {
      final lastMonthEndDate =
          DateTime(int.parse(year), (int.parse(month) + 1), 0);
      _utility.makeYMDYData(lastMonthEndDate.toString(), 0);
      endDay = int.parse(_utility.day);
    }

    final average = (sum / endDay).ceil();
    ////////////////////////////////////////

    _foodExpenses = {
      "food": food,
      "milk": milk,
      "bentou": bentou,
      "seiyu": seiyu,
      "sum": sum,
      "wariai": wariai,
      "endDay": endDay,
      "average": average,
    };
  }
}
