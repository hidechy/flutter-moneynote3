// ignore_for_file: file_names, must_be_immutable, prefer_const_constructors_in_immutables

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../riverpod/monthly_list/monthly_list_view_model.dart';
import '../riverpod/my_state/money_state.dart';
import '../riverpod/view_model/holiday_view_model.dart';
import '../riverpod/view_model/timeplace_zerousedate_view_model.dart';
import '../riverpod/view_model/money_view_model.dart';

import '../utilities/CustomShapeClipper.dart';
import '../utilities/utility.dart';

import 'DetailDisplayScreen.dart';
import 'EverydaySpendDisplayScreen.dart';
import 'OnedayInputScreen.dart';

class MonthlyListScreen extends ConsumerWidget {
  MonthlyListScreen({Key? key, required this.date}) : super(key: key);

  final String date;

  final Utility _utility = Utility();

  String _year = '';
  String _month = '';
  String _yearmonth = '';

  String _prevMonthEndDateTime = '';
  String _prevMonthEndDate = '';

  late WidgetRef _ref;
  late BuildContext _context;

  List<Map<String, int>> graphData = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    //---------------//

    _utility.makeYMDYData(date, 0);
    _year = _utility.year;
    _month = _utility.month;

    _yearmonth = '$_year-$_month';

    DateTime prevMonth = DateTime(int.parse(_year), int.parse(_month) - 1, 1);
    DateTime nextMonth = DateTime(int.parse(_year), int.parse(_month) + 1, 1);

    _utility.makeMonthEnd(int.parse(_year), int.parse(_month), 0);
    _prevMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_prevMonthEndDateTime, 0);
    _prevMonthEndDate = '${_utility.year}-${_utility.month}-${_utility.day}';

    //---------------//

    final allMoneyState = ref.watch(allMoneyProvider);
    final monthData = getMonthData(date: date, data: allMoneyState);

    final startMoney = ref.watch(moneyProvider(_prevMonthEndDate));
    final monthSpend = (monthData.isNotEmpty)
        ? startMoney.total - monthData[monthData.length - 1].total
        : 0;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(),
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
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => (prevMonth.toString() == '2019-12')
                              ? null
                              : _goMonthlyListScreen(
                                  date: prevMonth.toString(),
                                ),
                          child: const Icon(Icons.skip_previous),
                        ),
                        const SizedBox(width: 30),
                        Text(_yearmonth),
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () => _goMonthlyListScreen(
                            date: nextMonth.toString(),
                          ),
                          child: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              topButtonLine(
                prevMonth: prevMonth,
                nextMonth: nextMonth,
                monthSpend: monthSpend,
              ),
              Expanded(
                child: _monthList(data: monthData, startMoney: startMoney),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget topButtonLine(
      {required DateTime prevMonth,
      required DateTime nextMonth,
      required int monthSpend}) {
    final allMoneyState = _ref.watch(allMoneyProvider);
    final monthData = getMonthData(date: date, data: allMoneyState);

    makeGraphData(data: monthData);

    final graphSelectState = _ref.watch(graphSelectProvider);
    final graphSelectViewModel = _ref.watch(graphSelectProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: Colors.white),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(_context);
                },
                child: const Icon(Icons.close),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  _goEverydaySpendDisplayScreen(date: date);
                },
                child: const Icon(Icons.list),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: _context,
                builder: (_) {
                  return MonthGraphScreen(
                    graphData: graphData,
                  );
                },
              );
            },
            child: Icon(Icons.graphic_eq),
          ),
        ],
      ),
    );
  }

  ///
  void makeGraphData({required List<MoneyState> data}) {
    graphData = [];

    for (var i = 0; i < data.length; i++) {
      var exDate = data[i].date.split('-');
      graphData.add({
        'day': int.parse(exDate[2]),
        'total': data[i].total,
      });
    }
  }

  ///
  List<MoneyState> getMonthData(
      {required String date, required List<MoneyState> data}) {
    List<MoneyState> _list = [];

    final exDate = date.split('-');

    for (var i = 0; i < data.length; i++) {
      var exOneData = data[i].date.split('-');

      if ('${exDate[0]}-${exDate[1]}' == '${exOneData[0]}-${exOneData[1]}') {
        _list.add(data[i]);
      }
    }

    return _list;
  }

  ///
  Widget _monthList(
      {required List<MoneyState> data, required MoneyState startMoney}) {
    //----------------//
    final holidayState = _ref.watch(holidayProvider);
    Map<String, dynamic> _holidayList = {};
    for (var i = 0; i < holidayState.length; i++) {
      _holidayList[holidayState[i]] = '';
    }
    //----------------//

    //----------------//
    final timeplaceZerousedateState = _ref.watch(timeplaceZerousedateProvider);
    Map<String, dynamic> _zeroUseDateList = {};
    for (var i = 0; i < timeplaceZerousedateState.length; i++) {
      _zeroUseDateList[timeplaceZerousedateState[i]] = '';
    }
    //----------------//

    List<Widget> _list = [];

    for (var i = 0; i < data.length; i++) {
      var exOneData = data[i].date.split('-');

      _utility.makeYMDYData(data[i].date, 0);

      var diff = (i == 0)
          ? (startMoney.total - data[i].total)
          : (data[i - 1].total - data[i].total);

      _list.add(
        Slidable(
          actionPane: const SlidableDrawerActionPane(),
          actionExtentRatio: 0.15,

          //actions: <Widget>[],
          secondaryActions: <Widget>[
            IconSlideAction(
              foregroundColor: Colors.white,
              color: _utility.getBgColor(data[i].date, _holidayList),
              icon: Icons.details,
              onTap: () {
                _goDetailDisplayScreen(date: data[i].date);
              },
            ),
            IconSlideAction(
              foregroundColor: Colors.white,
              color: _utility.getBgColor(data[i].date, _holidayList),
              icon: Icons.input,
              onTap: () {
                _goOnedayInputScreen(date: data[i].date);
              },
            ),
          ],

          child: Card(
            color: _utility.getBgColor(data[i].date, _holidayList),
            child: ListTile(
              leading: Container(
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(exOneData[2]),
                    Text(
                      _utility.youbiStr,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              title: DefaultTextStyle(
                style: const TextStyle(fontSize: 12),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 2,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(bottom: 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _utility.makeCurrencyDisplay(
                              data[i].total.toString(),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                _utility.makeCurrencyDisplay(diff.toString()),
                              ),
                              const SizedBox(width: 10),
                              (_zeroUseDateList[data[i].date] != null)
                                  ? Icon(
                                      Icons.star,
                                      color:
                                          Colors.greenAccent.withOpacity(0.5),
                                      size: 12,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank,
                                      color: Color(0xFF2e2e2e),
                                      size: 12,
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        getDisplayContainer(value: data[i].yen_10000),
                        getDisplayContainer(value: data[i].yen_5000),
                        getDisplayContainer(value: data[i].yen_2000),
                        getDisplayContainer(value: data[i].yen_1000),
                        getDisplayContainer(value: data[i].yen_500),
                        getDisplayContainer(value: data[i].yen_100),
                        getDisplayContainer(value: data[i].yen_50),
                        getDisplayContainer(value: data[i].yen_10),
                        getDisplayContainer(value: data[i].yen_5),
                        getDisplayContainer(value: data[i].yen_1),
                      ],
                    ),
                    Row(
                      children: [
                        getDisplayContainer(value: data[i].bankA),
                        getDisplayContainer(value: data[i].bankB),
                        getDisplayContainer(value: data[i].bankC),
                        getDisplayContainer(value: data[i].bankD),
                      ],
                    ),
                    Row(
                      children: [
                        getDisplayContainer(value: data[i].bankE),
                        getDisplayContainer(value: 0),
                        getDisplayContainer(value: 0),
                        getDisplayContainer(value: 0),
                      ],
                    ),
                    Row(
                      children: [
                        getDisplayContainer(value: data[i].peyA),
                        getDisplayContainer(value: data[i].peyB),
                        getDisplayContainer(value: data[i].peyC),
                        getDisplayContainer(value: data[i].peyD),
                      ],
                    ),
                    Row(
                      children: [
                        getDisplayContainer(value: data[i].peyE),
                        getDisplayContainer(value: 0),
                        getDisplayContainer(value: 0),
                        getDisplayContainer(value: 0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(children: _list),
    );
  }

  ///
  Widget getDisplayContainer({required int value}) {
    return Expanded(
      child: Container(
        alignment: Alignment.topRight,
        child: Text(_utility.makeCurrencyDisplay(value.toString())),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /// 画面遷移（MonthlyListScreen）
  void _goMonthlyListScreen({required String date}) {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(date: date),
      ),
    );
  }

  ///
  void _goEverydaySpendDisplayScreen({required String date}) {
    Navigator.push(
      _context,
      MaterialPageRoute(
        builder: (context) => EverydaySpendDisplayScreen(
          date: date,
        ),
      ),
    );
  }

  ///
  void _goDetailDisplayScreen({required String date}) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date);
    _utility.makeYMDYData(date, 0);

    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: int.parse(_utility.day),
          detailDisplayArgs: detailDisplayArgs,
        ),
      ),
    );
  }

  ///
  void _goOnedayInputScreen({required String date}) {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(date: date),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class MonthGraphScreen extends StatelessWidget {
  MonthGraphScreen({Key? key, required this.graphData}) : super(key: key);

  final List<Map<String, int>> graphData;

  List<FlSpot> flspots = [];

  int graphMax = 0;
  int graphMin = 0;

  @override
  Widget build(BuildContext context) {
    List<int> list = [];
    for (var i = 0; i < graphData.length; i++) {
      flspots.add(
        FlSpot(
          double.parse((i + 1).toString()),
          double.parse(graphData[i]['total'].toString()),
        ),
      );

      list.add(int.parse(graphData[i]['total'].toString()));
    }

    //-----------------------//
    var minValue = list.reduce(min);
    var maxValue = list.reduce(max);

    var warisuu = 500000;

    graphMin = ((minValue / warisuu).floor()) * warisuu;
    graphMax = ((maxValue / warisuu).ceil()) * warisuu;
    //-----------------------//

    setChartData();

    Size size = MediaQuery.of(context).size;

    int graphWidth = (graphData.length > 20) ? 3 : 2;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: size.width * graphWidth,
          height: size.height - 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          child: LineChart(data),
        ),
      ),
    );
  }

  ///
  LineChartData data = LineChartData();

  void setChartData() {
    data = LineChartData(
      ///
      minX: 1,
      maxX: double.parse(flspots.length.toString()),
      //
      minY: double.parse(graphMin.toString()),
      maxY: double.parse(graphMax.toString()),

      ///
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.white.withOpacity(0.3),
        ),
      ),

      ///
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,

        //横線
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white30,
            strokeWidth: 1,
          );
        },

        //縦線
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white38,
            strokeWidth: 1,
          );
        },
      ),

      ///
      /// 全体の枠
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.white38,
          width: 2,
        ),
      ),

      ///
      lineBarsData: [
        LineChartBarData(
          spots: flspots,
//          isCurved: true,//グラフを曲線にするか
          barWidth: 5,
          isStrokeCapRound: true,
          color: Colors.yellowAccent,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.yellowAccent.withOpacity(0.1),
          ), // グラフの下の塗り
        ),
      ],

      ///
    );
  }
}
