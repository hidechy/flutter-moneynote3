// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../riverpod/sameday_spend/sameday_spend_view_model.dart';
import '../riverpod/view_model/money_view_model.dart';
import '../riverpod/my_state/money_state.dart';

import '../utilities/CustomShapeClipper.dart';
import '../utilities/utility.dart';

class SamedayListScreen extends ConsumerWidget {
  SamedayListScreen({Key? key, required this.date}) : super(key: key);

  final String date;

  final Utility _utility = Utility();

  late WidgetRef _ref;
  late BuildContext _context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    final allMoneyState = ref.watch(allMoneyProvider);
    final samedayTotal = getSamedayTotal(date: date, data: allMoneyState);

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
              _makeDayButton(),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _makePrevNextButton(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return SamedayGraphScreen(date: date);
                              },
                            );
                          },
                          child: const Icon(Icons.graphic_eq),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
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
                child: _samedayList(data: samedayTotal),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _samedayList({required Map<String, dynamic> data}) {
    List<Widget> _list = [];

    final samedaySpendState = _ref.watch(samedaySpendProvider(date));

    final startMoney = _ref.watch(moneyProvider('2019-12-31'));

    for (var i = 0; i < samedaySpendState.length; i++) {
      if (data[samedaySpendState[i].ym] != null) {
        var diff = (i == 0)
            ? (data[samedaySpendState[i].ym] - startMoney.total)
            : (data[samedaySpendState[i].ym] -
                data[samedaySpendState[i - 1].ym]);

        _list.add(
          DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(child: Text(samedaySpendState[i].ym)),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        _utility.makeCurrencyDisplay(
                            samedaySpendState[i].sum.toString()),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        _utility.makeCurrencyDisplay(
                            data[samedaySpendState[i].ym].toString()),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        _utility.makeCurrencyDisplay(diff.toString()),
                        style: TextStyle(
                          color: (diff > 0)
                              ? Colors.greenAccent
                              : Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: _list,
      ),
    );
  }

  ///
  Map<String, dynamic> getSamedayTotal(
      {required String date, required List<MoneyState> data}) {
    Map<String, dynamic> _map = {};

    final exDate = date.split('-');

    for (var i = 0; i < data.length; i++) {
      var exOneDate = data[i].date.split('-');
      if (exDate[2] == exOneDate[2]) {
        _map['${exOneDate[0]}-${exOneDate[1]}'] = data[i].total;
      }
    }

    return _map;
  }

  ///
  Widget _makeDayButton() {
    List<Widget> _list = [];

    Size size = MediaQuery.of(_context).size;

    for (var i = 1; i <= 31; i++) {
      _list.add(
        GestureDetector(
          onTap: () => _makeDateForGoSamedayListScreen(day: i),
          child: Container(
            margin: const EdgeInsets.all(3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getButtonBgColor(day: i),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            width: (size.width / 5) - 10,
            child: Text(
              i.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      );
    }

    return Wrap(
      children: _list,
    );
  }

  ///
  Color _getButtonBgColor({required int day}) {
    var exDate = (date).split('-');

    if (day.toString().padLeft(2, '0') == exDate[2]) {
      return Colors.yellowAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.3);
    }
  }

  ///
  Widget _makePrevNextButton() {
    _utility.makeYMDYData(date, 0);

    var _prevDate = DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) - 1);
    var _nextDate = DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) + 1);

    _utility.makeYMDYData(_prevDate.toString(), 0);
    var pDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    _utility.makeYMDYData(_nextDate.toString(), 0);
    var nDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    return Row(
      children: [
        GestureDetector(
          onTap: () => _goSamedayListScreen(date: pDate),
          child: const Icon(
            Icons.skip_previous,
            color: Colors.greenAccent,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _goSamedayListScreen(date: nDate),
          child: const Icon(
            Icons.skip_next,
            color: Colors.greenAccent,
          ),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////
  ///
  void _makeDateForGoSamedayListScreen({required int day}) {
    var exDate = (date).split('-');
    var _date = "${exDate[0]}-${exDate[1]}-${day.toString().padLeft(2, '0')}";
    _goSamedayListScreen(date: _date);
  }

  ///
  void _goSamedayListScreen({required String date}) {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (context) => SamedayListScreen(date: date),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////
class SamedayGraphScreen extends ConsumerWidget {
  SamedayGraphScreen({Key? key, required this.date}) : super(key: key);

  final String date;

  late WidgetRef _ref;
  late BuildContext _context;

  final ScrollController _controller = ScrollController();

  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        child: Container(
          width: size.width,
          height: size.height * 3,
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
    final exDate = date.split('-');

    _utility.makeYMDYData(date, 0);

    var _prevDate = DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) - 1);
    var _nextDate = DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) + 1);

    _utility.makeYMDYData(_prevDate.toString(), 0);
    var pDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    _utility.makeYMDYData(_nextDate.toString(), 0);
    var nDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    List<ChartData> list = [];

    final samedaySpendState = _ref.watch(samedaySpendProvider(date));

    for (var i = 0; i < samedaySpendState.length; i++) {
      list.add(
        ChartData(
          ym: samedaySpendState[i].ym,
          sum: double.parse(samedaySpendState[i].sum.toString()),
        ),
      );
    }

    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      goSamedayGraphScreen(date: nDate);
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                  const SizedBox(height: 20),
                  Text(exDate[2]),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      goSamedayGraphScreen(date: pDate);
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      goSamedayListScreen();
                    },
                    child: const Icon(
                      FontAwesomeIcons.replyAll,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),

//        primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 1000000,
              ),

              series: <ChartSeries<ChartData, String>>[
                BarSeries<ChartData, String>(
                  dataSource: list,
                  xValueMapper: (ChartData data, _) => data.ym,
                  yValueMapper: (ChartData data, _) => data.sum,
                  color: Colors.yellowAccent,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //-------------------------

  ///
  void goSamedayGraphScreen({required String date}) {
    Navigator.push(
      _context,
      MaterialPageRoute(
        builder: (context) => SamedayGraphScreen(date: date),
      ),
    );
  }

  ///
  void goSamedayListScreen() {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (context) => SamedayListScreen(
          date: DateTime.now().toString().split(' ')[0],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////
class ChartData {
  final String ym;
  final double sum;

  ChartData({required this.ym, required this.sum});
}
