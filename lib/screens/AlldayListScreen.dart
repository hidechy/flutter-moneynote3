// ignore_for_file: unnecessary_null_comparison, file_names, import_of_legacy_library_into_null_safe, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../riverpod/view_model/money_view_model.dart';

import '../riverpod/view_model/timeplace_zerousedate_view_model.dart';
import '../riverpod/view_model/holiday_view_model.dart';

import '../utilities/CustomShapeClipper.dart';
import '../utilities/utility.dart';

class AlldayListScreen extends ConsumerWidget {
  AlldayListScreen({Key? key, required this.date}) : super(key: key);

  final String date;

  final ItemScrollController _itemScrollController = ItemScrollController();

  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  Utility _utility = Utility();

  late WidgetRef _ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

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
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                ),
                child: Wrap(
                  children: _makeYmBtn(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlldayGraphScreen();
                              },
                            );
                          },
                          child: const Icon(Icons.graphic_eq),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: buildAlldayList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget buildAlldayList() {
    final allMoneyState = _ref.watch(allMoneyProvider);

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

    final startMoney = _ref.watch(moneyProvider('2019-12-31'));

    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        var prevTotal =
            (index == 0) ? startMoney.total : allMoneyState[index - 1].total;

        return Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: _utility.getBgColor(allMoneyState[index].date, _holidayList),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                      '${allMoneyState[index].date}（${_utility.youbiStr}）'),
                ),
                Expanded(
                  child: Text(_utility.makeCurrencyDisplay(
                      allMoneyState[index].total.toString())),
                ),
                Container(
                  width: 100,
                  alignment: Alignment.topRight,
                  child: Text(
                    _utility.makeCurrencyDisplay(
                      (prevTotal - allMoneyState[index].total).toString(),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  alignment: Alignment.topRight,
                  child: (_zeroUseDateList[allMoneyState[index].date] != null)
                      ? Icon(
                          Icons.home,
                          color: Colors.greenAccent.withOpacity(0.5),
                          size: 12,
                        )
                      : const Icon(
                          Icons.check_box_outline_blank,
                          color: Color(0xFF2e2e2e),
                          size: 12,
                        ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: allMoneyState.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  ///
  List<Widget> _makeYmBtn() {
    List<Widget> _btnList = [];

    final allMoneyState = _ref.watch(allMoneyProvider);

    var _ym = "";
    for (var i = 0; i < allMoneyState.length; i++) {
      var exDate = allMoneyState[i].date.split('-');

      if (_ym != "${exDate[0]}-${exDate[1]}") {
        _btnList.add(
          GestureDetector(
            onTap: () => _scroll(pos: i),
            child: Container(
              color: Colors.green[900]!.withOpacity(0.5),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
              width: 60,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "${exDate[0]}-${exDate[1]}",
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        );
      }

      _ym = "${exDate[0]}-${exDate[1]}";
    }

    return _btnList;
  }

  ///
  void _scroll({required int pos}) {
    _itemScrollController.scrollTo(
      index: pos,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }
}

/////////////////////////////////////////////////////////////

class AlldayGraphScreen extends ConsumerWidget {
  AlldayGraphScreen({Key? key}) : super(key: key);

  late WidgetRef _ref;

  Utility _utility = Utility();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: size.width * 10,
          height: size.height - 100,
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
    final allMoneyState = _ref.watch(allMoneyProvider);

    List<ChartData> _list = [];

    int minimumTotal = 0;
    for (var i = 0; i < allMoneyState.length; i++) {
      _utility.makeYMDYData(allMoneyState[i].date, 0);

      if (minimumTotal == 0) {
        if (minimumTotal < allMoneyState[i].total) {
          minimumTotal = allMoneyState[i].total;
        }
      }

      _list.add(
        ChartData(
          x: DateTime(
            int.parse(_utility.year),
            int.parse(_utility.month),
            int.parse(_utility.day),
          ),
          total: allMoneyState[i].total,
        ),
      );
    }

    var devide1000000 = (minimumTotal / 1000000).floor();

    return Expanded(
      child: SfCartesianChart(
        series: <ChartSeries>[
          LineSeries<ChartData, DateTime>(
            color: Colors.yellowAccent,
            width: 3,
            dataSource: _list,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.total,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          dateFormat: DateFormat.MMM(),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(
            width: 2,
            color: Colors.white30,
          ),
          minimum: (devide1000000 * 1000000),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class ChartData {
  final DateTime x;
  final num total;

  ChartData({
    required this.x,
    required this.total,
  });
}
