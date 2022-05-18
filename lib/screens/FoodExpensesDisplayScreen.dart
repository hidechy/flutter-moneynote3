// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/food_expenses/month_summary_model.dart';
import '../riverpod/food_expenses/month_summary_view_model.dart';
import '../riverpod/food_expenses/seiyu_purchase_model.dart';
import '../riverpod/food_expenses/seiyu_purchase_view_model.dart';

import '../utilities/CustomShapeClipper.dart';
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

    final prevMonth = DateTime(int.parse(year), int.parse(month) - 1, 1);
    final nextMonth = DateTime(int.parse(year), int.parse(month) + 1, 1);

    final monthSummaryState = ref.watch(monthSummaryProvider(_date));
    final monthSpendSum = getMonthSpendSum(data: monthSummaryState);
    _monthSpendSum = monthSpendSum;

    final seiyuPurchaseState = ref.watch(seiyuPurchaseProvider(_date));

    getFoodExpenses(data: monthSummaryState, data2: seiyuPurchaseState);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: size.height * 0.7,
              width: size.width * 0.7,
              margin: const EdgeInsets.only(top: 5, left: 6),
              color: Colors.yellowAccent.withOpacity(0.2),
              child: Text(
                '■',
                style: TextStyle(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: Row(
                      children: [
                        Text('$year-$month'),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            if ('$year-$month' == '2020-01') {
                            } else {
                              final exPrev = prevMonth.toString().split(' ');
                              final exPrevYmd = exPrev[0].split('-');

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FoodExpensesDisplayScreen(
                                    year: exPrevYmd[0],
                                    month: exPrevYmd[1],
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Icon(Icons.skip_previous),
                        ),
                        GestureDetector(
                          onTap: () {
                            final exNext = nextMonth.toString().split(' ');
                            final exNextYmd = exNext[0].split('-');

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodExpensesDisplayScreen(
                                  year: exNextYmd[0],
                                  month: exNextYmd[1],
                                ),
                              ),
                            );
                          },
                          child: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close)),
                  ),
                ],
              ),
              if (_foodExpenses['food'] != null)
                DefaultTextStyle(
                  style: const TextStyle(fontSize: 12),
                  child: Column(
                    children: [
                      _dispContainer(type: '食費', value: _foodExpenses['food']),
                      _dispContainer(type: '牛乳代', value: _foodExpenses['milk']),
                      _dispContainer(
                          type: '弁当代', value: _foodExpenses['bentou']),
                      _dispContainer(type: '西友', value: _foodExpenses['seiyu']),
                      _dispContainer2(type: '合計', value: _foodExpenses['sum']),
                      Divider(
                        thickness: 2,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _dispContainer2(type: '当月消費額', value: _monthSpendSum),
                      _dispContainer2(
                        type: '平均（${_foodExpenses['endDay']}日間）',
                        value: _foodExpenses['average'],
                      ),
                      _dispContainer2(
                        type: 'エンゲル係数',
                        value: _foodExpenses['wariai'],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _dispContainer({required String type, required value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: Colors.white.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(type),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Text(
                _utility.makeCurrencyDisplay(value.toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _dispContainer2({required String type, required value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Text(type),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Text(
                _utility.makeCurrencyDisplay(value.toString()),
              ),
            ),
          ),
        ],
      ),
    );
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
