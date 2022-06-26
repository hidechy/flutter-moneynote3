// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../riverpod/score/benefit_view_model.dart';
import '../utilities/CustomShapeClipper.dart';
import '../utilities/utility.dart';

import '../riverpod/my_state/money_state.dart';
import '../riverpod/view_model/money_view_model.dart';
import '../riverpod/score/score_entity.dart';
import '../riverpod/score/benefit_entity.dart';

class ScoreListScreen extends ConsumerWidget {
  ScoreListScreen({Key? key}) : super(key: key);

  late WidgetRef _ref;

  final Utility _utility = Utility();

  String minimumDate = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    List<Score> scoreData = getScoreData();

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
              Container(
                margin: const EdgeInsets.only(top: 30, bottom: 10, right: 10),
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close)),
              ),
              makeGraph(data: scoreData),
              Expanded(
                child: dispScoreList(data: scoreData),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  List<Score> getScoreData() {
    List<Score> _list = [];

    final allMoneyState = _ref.watch(allMoneyProvider);

    Map<String, dynamic> allDayMoneyTotalMap =
        getAllDayMoneyTotalMap(data: allMoneyState);

    if (allDayMoneyTotalMap.isNotEmpty) {
      final exMinimumDate = minimumDate.split('-');

      final beforeAdmtm =
          DateTime(int.parse(exMinimumDate[0]), int.parse(exMinimumDate[1]), 0);

      final exBeforeAdmtm = beforeAdmtm.toString().split(' ');

      final moneyState = _ref.watch(moneyProvider(exBeforeAdmtm[0]));

      allDayMoneyTotalMap[moneyState.date] = moneyState.total;

      List<Map<String, dynamic>> ymMap = getYmMap(data: allMoneyState);

      if (ymMap.isNotEmpty) {
        final benefitState = _ref.watch(benefitProvider);

        final benefitData = getBenefitData(data: benefitState);

        if (allDayMoneyTotalMap[ymMap[0]['lastMonthEndDate']] != null) {
          final startMoney = int.parse(
              allDayMoneyTotalMap[ymMap[0]['lastMonthEndDate']].toString());

          for (var i = 0; i < ymMap.length; i++) {
            final totalLmed =
                (allDayMoneyTotalMap[ymMap[i]['lastMonthEndDate']] != null)
                    ? int.parse(
                        allDayMoneyTotalMap[ymMap[i]['lastMonthEndDate']]
                            .toString())
                    : 0;
            final totalTmed =
                (allDayMoneyTotalMap[ymMap[i]['thisMonthEndDate']] != null)
                    ? allDayMoneyTotalMap[ymMap[i]['thisMonthEndDate']]
                    : 0;

            int _lmed = int.parse(totalLmed.toString());
            int _tmed = int.parse(totalTmed.toString());

            int _benefit = (benefitData[ymMap[i]['ym']] != null)
                ? benefitData[ymMap[i]['ym']]['sum']
                : 0;

            String _company = (benefitData[ymMap[i]['ym']] != null)
                ? benefitData[ymMap[i]['ym']]['company'].substring(
                    0, benefitData[ymMap[i]['ym']]['company'].length - 1)
                : '';

            int _score = ((_lmed - _tmed) * -1);
            int _minus = (_benefit > 0) ? (_benefit - _score) : (_score * -1);

            int average = ((totalTmed - startMoney) / (i + 1)).floor();

            _list.add(
              Score(
                yearmonth: ymMap[i]['ym'],
                prevTotal: totalLmed,
                thisTotal: totalTmed,
                score: _score,
                benefit: _benefit,
                benefitCompany: _company,
                minus: _minus,
                average: average,
              ),
            );
          }
        }
      }
    }

    return _list;
  }

  ///
  Map<String, dynamic> getAllDayMoneyTotalMap(
      {required List<MoneyState> data}) {
    Map<String, dynamic> moneyMap = {};

    for (var i = 0; i < data.length; i++) {
      if (i == 0) {
        minimumDate = data[i].date;
      }

      moneyMap[data[i].date.toString()] = data[i].total;
    }

    return moneyMap;
  }

  ///
  List<Map<String, dynamic>> getYmMap({required List<MoneyState> data}) {
    List<Map<String, dynamic>> ymMap = [];
    for (var i = 0; i < data.length; i++) {
      final exDate = data[i].date.split('-');
      if (exDate[exDate.length - 1] == '01') {
        final lmed = DateTime(int.parse(exDate[0]), int.parse(exDate[1]), 0);
        final exLmed = lmed.toString().split(' ');
        final lastMonthEndDate = exLmed[0];

        final tmed =
            DateTime(int.parse(exDate[0]), int.parse(exDate[1]) + 1, 0);
        final exTmed = tmed.toString().split(' ');
        final thisMonthEndDate = exTmed[0];

        Map<String, String> _map = {};
        _map['ym'] = '${exDate[0]}-${exDate[1]}';
        _map['lastMonthEndDate'] = lastMonthEndDate;
        _map['thisMonthEndDate'] = thisMonthEndDate;

        ymMap.add(_map);
      }
    }

    return ymMap;
  }

  ///
  Map<String, dynamic> getBenefitData({required List<BenefitEntity> data}) {
    Map<String, dynamic> benefitData = {};

    var yM = '';
    var sum = 0;
    var com = '';
    for (var i = 0; i < data.length; i++) {
      final ym = data[i].yearmonth;

      if (ym != yM) {
        sum = 0;
        com = '';
      }

      sum += data[i].price;
      com += data[i].company + '/';

      Map<String, dynamic> _map = {};
      _map['sum'] = sum;
      _map['company'] = com;
      benefitData[ym] = _map;

      yM = data[i].yearmonth;
    }

    return benefitData;
  }

  ///
  Widget dispScoreList({required List<Score> data}) {
    List<Widget> _list = [];

    for (var i = 0; i < data.length - 1; i++) {
      _list.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(data[i].yearmonth),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(_utility
                            .makeCurrencyDisplay(data[i].prevTotal.toString())),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          _utility.makeCurrencyDisplay(
                              data[i].thisTotal.toString()),
                          style: const TextStyle(color: Colors.yellowAccent),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(_utility
                            .makeCurrencyDisplay(data[i].benefit.toString())),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(_utility
                            .makeCurrencyDisplay(data[i].minus.toString())),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          _utility
                              .makeCurrencyDisplay(data[i].score.toString()),
                          style: TextStyle(
                              color: (data[i].benefit > data[i].minus)
                                  ? Colors.greenAccent
                                  : Colors.pinkAccent),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text((data[i].benefitCompany != '')
                      ? data[i].benefitCompany
                      : '-'),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                      _utility.makeCurrencyDisplay(data[i].average.toString())),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: _list,
      ),
    );
  }

  ///
  Widget makeGraph({required List<Score> data}) {
    List<ChartData> _list = [];
    for (var i = 0; i < data.length - 1; i++) {
      _list.add(
        ChartData(
          x: DateTime.parse('${data[i].yearmonth}-01'),
          val: data[i].thisTotal,
        ),
      );
    }

    return SfCartesianChart(
      series: <ChartSeries>[
        LineSeries<ChartData, DateTime>(
          color: Colors.yellowAccent,
          width: 3,
          dataSource: _list,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.val,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(
          width: 2,
          color: Colors.white30,
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime x;
  final num val;

  ChartData({required this.x, required this.val});
}
