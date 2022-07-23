// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

import 'dart:convert';

import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../riverpod/my_state/money_state.dart';
import '../riverpod/view_model/benefit_view_model.dart';
import '../riverpod/view_model/holiday_view_model.dart';
import '../riverpod/view_model/money_view_model.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

class YearlySpendDisplayScreen extends ConsumerWidget {
  YearlySpendDisplayScreen({Key? key, required this.date}) : super(key: key);

  final String date;

  final Utility _utility = Utility();

  late DateTime prevYear;
  late DateTime nextYear;

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _context = context;

    var exDate = date.split('-');
    prevYear = DateTime(int.parse(exDate[0]) - 1, int.parse(exDate[1]), 1);
    nextYear = DateTime(int.parse(exDate[0]) + 1, int.parse(exDate[1]), 1);

    final now = DateTime.now();

    final yearlySpendState = ref.watch(yearlySpendProvider(date));

    final allMoneyState = ref.watch(allMoneyProvider);
    final benefitList = ref.watch(benefitSearchProvider);
    var monthSpendTotal = makeMonthSpendTotal(
      data: allMoneyState,
      data2: benefitList,
    );

    //----------------//
    final holidayState = ref.watch(holidayProvider);
    Map<String, dynamic> _holidayList = {};
    for (var i = 0; i < holidayState.length; i++) {
      _holidayList[holidayState[i]] = '';
    }
    //----------------//

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
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              (prevYear.toString().split('-')[0] == '2019')
                                  ? null
                                  : _goYearlySpendDisplayScreen(date: prevYear),
                          child: const Icon(Icons.skip_previous),
                        ),
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () =>
                              (int.parse(nextYear.toString().split('-')[0]) >
                                      int.parse(now.toString().split('-')[0]))
                                  ? null
                                  : _goYearlySpendDisplayScreen(date: nextYear),
                          child: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: _context,
                              builder: (_) {
                                return YearlySpendGraphScreen(
                                  graphData: yearlySpendState,
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.graphic_eq),
                        ),
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GroupedListView<dynamic, dynamic>(
                  padding: EdgeInsets.zero,
                  elements: yearlySpendState,
                  groupBy: (item) => item['group'],
                  groupSeparatorBuilder: (groupValue) {
                    var monthSpend = _utility.makeCurrencyDisplay(
                      monthSpendTotal[groupValue]['monthSpend'].toString(),
                    );

                    var start = _utility.makeCurrencyDisplay(
                      monthSpendTotal[groupValue]['start'].toString(),
                    );

                    var end = _utility.makeCurrencyDisplay(
                      monthSpendTotal[groupValue]['end'].toString(),
                    );

                    var benefit = _utility.makeCurrencyDisplay(
                      monthSpendTotal[groupValue]['benefit'].toString(),
                    );

                    var score = _utility.makeCurrencyDisplay(
                      monthSpendTotal[groupValue]['score'].toString(),
                    );

                    return DefaultTextStyle(
                      style: TextStyle(fontSize: 12),
                      child: Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(groupValue),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('spend: $monthSpend'),
                                Text(
                                  'start: $start / end: $end',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'benefit: $benefit',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'score: $score',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, item) {
                    return DefaultTextStyle(
                      style: TextStyle(fontSize: 12),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          color:
                              _utility.getBgColor(item['date'], _holidayList),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['date']),
                                Text(
                                  _utility.makeCurrencyDisplay(
                                    item['spend'].toString(),
                                  ),
                                  style: (item['spend'] <= 0)
                                      ? const TextStyle(
                                          color: Colors.yellowAccent)
                                      : const TextStyle(),
                                ),
                              ],
                            ),
                            _displayItems(data: item['item']),
                          ],
                        ),
                      ),
                    );
                  },
                  groupComparator: (group1, group2) => group1.compareTo(group2),
                  itemComparator: (item1, item2) =>
                      item1['date'].compareTo(item2['date']),
                  useStickyGroupSeparators: true,
                  floatingHeader: false,
                  order: GroupedListOrder.ASC,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _displayItems({required data}) {
    List<Widget> list = [];

    for (var i = 0; i < data.length; i++) {
      TextStyle style = const TextStyle();
      if (int.parse(data[i]['price'].toString()) >= 50000) {
        style = const TextStyle(color: Colors.pinkAccent);
      } else if (data[i]['flag'] == 1) {
        style = const TextStyle(color: Colors.lightBlueAccent);
      } else if (int.parse(data[i]['price'].toString()) <= 0) {
        style = const TextStyle(color: Colors.yellowAccent);
      }

      list.add(
        Row(
          children: [
            Expanded(child: Container()),
            Expanded(
              child: Text(
                data[i]['item'],
                style: style,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  _utility.makeCurrencyDisplay(
                    data[i]['price'].toString(),
                  ),
                  style: style,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: list,
    );
  }

  ///
  Map<String, dynamic> makeMonthSpendTotal(
      {required List<MoneyState> data, required List data2}) {
    Map<String, dynamic> map = {};

    final now = DateTime.now();
    final today = now.toString().split(' ')[0];
    final exToday = today.split('-');

    final DateTime yesterdayDt = now.add(const Duration(days: 1) * -1);
    final yesterday = yesterdayDt.toString().split(' ')[0];

    var exDate = date.split('-');

    for (var i = 1; i <= 12; i++) {
      var month = i.toString().padLeft(2, '0');
      var ym = '${exDate[0]}-$month';

      var startDt = DateTime(int.parse(exDate[0]), int.parse(month), 0);
      var start = startDt.toString().split(' ')[0];

      var endDt = DateTime(int.parse(exDate[0]), int.parse(month) + 1, 0);
      var end = endDt.toString().split(' ')[0];

      var startTotal = 0;
      var endTotal = 0;
      var todayTotal = 0;
      var yesterdayTotal = 0;

      for (var j = 0; j < data.length; j++) {
        if (data[j].date == start) {
          startTotal = data[j].total;
        }

        //----------------------

        if (data[j].date == end) {
          endTotal = data[j].total;
        }

        if (data[j].date == today) {
          todayTotal = data[j].total;
        }

        if (data[j].date == yesterday) {
          yesterdayTotal = data[j].total;
        }

        //----------------------

      }

      var aEnd = endTotal;
      if (i == int.parse(exToday[1])) {
        if (exDate[0] == exToday[0]) {
          if (todayTotal != 0) {
            aEnd = todayTotal;
          } else {
            aEnd = yesterdayTotal;
          }
        }
      }

      // benefit
      var benefit = 0;
      for (var j = 0; j < data2.length; j++) {
        if (ym == data2[j]['ym']) {
          benefit += int.parse(data2[j]['price']);
        }
      }

      // monthtotal
      var ms = startTotal - aEnd + benefit;

      // score
      var score = aEnd - startTotal;

      map[ym] = {
        "start": startTotal,
        "end": aEnd,
        "benefit": benefit,
        "monthSpend": ms,
        "score": score
      };
    }

    return map;
  }

  ///
  void _goYearlySpendDisplayScreen({required DateTime date}) {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (_context) => YearlySpendDisplayScreen(
          date: date.toString().split(' ')[0],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class YearlySpendGraphScreen extends StatelessWidget {
  YearlySpendGraphScreen({Key? key, required this.graphData}) : super(key: key);

  final List graphData;

  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: size.width * 7,
          height: size.height - 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          child: Column(
            children: [
              _makeGraph(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _makeGraph() {
    var graphMakeData = makeGraphData();

    var twelveColor = _utility.getTwelveColor();

    return Expanded(
      child: SfCartesianChart(
        legend: Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          LineSeries<SpendData, double>(
            name: 'January',
            color: twelveColor[0],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point01,
          ),
          LineSeries<SpendData, double>(
            name: 'February',
            color: twelveColor[1],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point02,
          ),
          LineSeries<SpendData, double>(
            name: 'March',
            color: twelveColor[2],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point03,
          ),
          LineSeries<SpendData, double>(
            name: 'April',
            color: twelveColor[3],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point04,
          ),
          LineSeries<SpendData, double>(
            name: 'May',
            color: twelveColor[4],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point05,
          ),
          LineSeries<SpendData, double>(
            name: 'June',
            color: twelveColor[5],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point06,
          ),
          LineSeries<SpendData, double>(
            name: 'July',
            color: twelveColor[6],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point07,
          ),
          LineSeries<SpendData, double>(
            name: 'August',
            color: twelveColor[7],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point08,
          ),
          LineSeries<SpendData, double>(
            name: 'September',
            color: twelveColor[8],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point09,
          ),
          LineSeries<SpendData, double>(
            name: 'October',
            color: twelveColor[9],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point10,
          ),
          LineSeries<SpendData, double>(
            name: 'November',
            color: twelveColor[10],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point11,
          ),
          LineSeries<SpendData, double>(
            name: 'December',
            color: twelveColor[11],
            width: 3,
            dataSource: graphMakeData,
            xValueMapper: (SpendData data, _) => data.day,
            yValueMapper: (SpendData data, _) => data.point12,
          ),
        ],
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(
            width: 1,
            color: Colors.white30,
          ),
        ),
        primaryXAxis: NumericAxis(
          majorGridLines: const MajorGridLines(
            width: 1,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }

  ///
  List<SpendData> makeGraphData() {
    List<SpendData> list = [];

    final year = graphData[0]['date'].split('-')[0];

    //-------------------------//
    Map<String, Map<dynamic, dynamic>> spendMap = {};
    var keepMonth = '';
    var sum = 0;
    for (var p = 0; p < graphData.length; p++) {
      var exDate = graphData[p]['date'].split('-');
      if (keepMonth != exDate[1]) {
        sum = 0;
      }
      sum += int.parse(graphData[p]['spend'].toString());

      spendMap[graphData[p]['date']] = {
        "month": int.parse(exDate[1]),
        "spend": sum
      };

      keepMonth = exDate[1];
    }
    //-------------------------//

    //-------------------------//
    Map<dynamic, List<double>> map = {};
    for (var i = 1; i <= 31; i++) {
      var day = i.toString().padLeft(2, '0');
      map[i] = [];
      for (var j = 1; j <= 12; j++) {
        var month = j.toString().padLeft(2, '0');
        var spend = (spendMap['$year-$month-$day'] != null)
            ? double.parse(
                spendMap['$year-$month-$day']!['spend'].toString(),
              )
            : 0.0;

        map[i]?.add(spend);
      }
    }
    //-------------------------//

    //-------------------------//
    for (var i = 1; i <= 31; i++) {
      list.add(
        SpendData(
          double.parse(i.toString()),
          map[i]![0],
          map[i]![1],
          map[i]![2],
          map[i]![3],
          map[i]![4],
          map[i]![5],
          map[i]![6],
          map[i]![7],
          map[i]![8],
          map[i]![9],
          map[i]![10],
          map[i]![11],
        ),
      );
    }
    //-------------------------//

    return list;
  }
}

/////////////////////////////////////////////////////////////
//graph
class SpendData {
  double day;
  double point01;
  double point02;
  double point03;
  double point04;
  double point05;
  double point06;
  double point07;
  double point08;
  double point09;
  double point10;
  double point11;
  double point12;

  SpendData(
    this.day,
    this.point01,
    this.point02,
    this.point03,
    this.point04,
    this.point05,
    this.point06,
    this.point07,
    this.point08,
    this.point09,
    this.point10,
    this.point11,
    this.point12,
  );
}

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
final yearlySpendProvider = StateNotifierProvider.autoDispose
    .family<YearlySpendStateNotifier, List<dynamic>, String>((ref, date) {
  return YearlySpendStateNotifier([])..getYearlySpend(date: date);
});

class YearlySpendStateNotifier extends StateNotifier<List<dynamic>> {
  YearlySpendStateNotifier(List<dynamic> state) : super([]);

  void getYearlySpend({required String date}) async {
    String url = "http://toyohide.work/BrainLog/api/getYearSpend";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    var yearlySpend = jsonDecode(response.body);

    List<dynamic> _list = [];

    for (var i = 0; i < yearlySpend['data'].length; i++) {
      List<Map<dynamic, dynamic>> _item = [];
      for (var j = 0; j < yearlySpend['data'][i]['item'].length; j++) {
        Map _map2 = {};
        _map2['item'] = yearlySpend['data'][i]['item'][j]['item'] ?? "";
        _map2['price'] = yearlySpend['data'][i]['item'][j]['price'] ?? 0;
        _map2['flag'] = yearlySpend['data'][i]['item'][j]['flag'] ?? 0;
        _item.add(_map2);
      }

      var exDate = yearlySpend['data'][i]['date'].split('-');

      Map _map = {};
      _map['date'] = yearlySpend['data'][i]['date'] ?? "";
      _map['spend'] = yearlySpend['data'][i]['spend'] ?? 0;
      _map['item'] = _item;
      _map['group'] = '${exDate[0]}-${exDate[1]}';
      _list.add(_map);
    }

    state = _list;
  }
}

//////////////////////////////////////////////////////////////////////
