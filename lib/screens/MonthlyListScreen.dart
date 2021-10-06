// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'DetailDisplayScreen.dart';
import 'MonthlySpendItemScreen.dart';
import 'OnedayInputScreen.dart';

class MonthlyListScreen extends StatefulWidget {
  String date;

  MonthlyListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _MonthlyListScreenState createState() => _MonthlyListScreenState();
}

//graph
class MoneyData {
  double day;
  double total;

  MoneyData(this.day, this.total);
}

class _MonthlyListScreenState extends State<MonthlyListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _monthlyData = [];

  String _year = '';
  String _month = '';

  String _yearmonth = '';

  Map<String, dynamic> _holidayList = {};

  DateTime _prevMonth = DateTime.now();
  DateTime _nextMonth = DateTime.now();

  String _prevMonthEndDateTime = '';
  String _prevMonthEndDate = '';

  int _monthTotal = 0;

  List<MoneyData> _chartData = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(widget.date, 0);
    _year = _utility.year;
    _month = _utility.month;

    _yearmonth = '$_year-$_month';

    ///////////////////////////
    _utility.makeMonthEnd(int.parse(_year), int.parse(_month), 0);
    _prevMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_prevMonthEndDateTime, 0);
    _prevMonthEndDate = '${_utility.year}-${_utility.month}-${_utility.day}';

    int _prevMonthEndTotal = 0;

    /////////////////////////////////////
    await apiData.getMoneyOfDate(date: _prevMonthEndDate);
    if (apiData.MoneyOfDate != null) {
      if (apiData.MoneyOfDate['data'] != "-") {
        _utility.makeTotal(apiData.MoneyOfDate['data']);
        _prevMonthEndTotal = _utility.total;
      }
    }

    apiData.MoneyOfDate = {};
    /////////////////////////////////////

    /////////////////////////////////////
    await apiData.getMoneyOfAll();
    if (apiData.MoneyOfAll != null) {
      int j = 0;
      var _yesterdayTotal = 0;

      for (var i = 0; i < apiData.MoneyOfAll['data'].length; i++) {
        var exData = (apiData.MoneyOfAll['data'][i]).split('|');

        if ('$_year-$_month' == exData[1]) {
          _utility.makeYMDYData(exData[0], 0);

          var _map = {};
          _map["date"] = _utility.day;

          _map["strYen10000"] = exData[2];
          _map["strYen5000"] = exData[3];
          _map["strYen2000"] = exData[4];
          _map["strYen1000"] = exData[5];
          _map["strYen500"] = exData[6];
          _map["strYen100"] = exData[7];
          _map["strYen50"] = exData[8];
          _map["strYen10"] = exData[9];
          _map["strYen5"] = exData[10];
          _map["strYen1"] = exData[11];

          _map["strBankA"] = exData[12];
          _map["strBankB"] = exData[13];
          _map["strBankC"] = exData[14];
          _map["strBankD"] = exData[15];
          _map["strBankE"] = exData[16];

          _map["strPayA"] = exData[17];
          _map["strPayB"] = exData[18];
          _map["strPayC"] = exData[19];
          _map["strPayD"] = exData[20];
          _map["strPayE"] = exData[21];

          //-------------------------------------//
          List _list = [];
          for (var l = 2; l <= 21; l++) {
            _list.add(exData[l]);
          }
          _utility.makeTotal(_list.join('|'));
          _map['total'] = _utility.total;
          //-------------------------------------//

          _chartData.add(MoneyData(double.parse(_map["date"]),
              double.parse(_map['total'].toString())));

          if (j == 0) {
            _map['diff'] = (_prevMonthEndTotal - _utility.total);
            _monthTotal += (_prevMonthEndTotal - _utility.total);
          } else {
            _map['diff'] = (_yesterdayTotal - _utility.total);
            _monthTotal += (_yesterdayTotal - _utility.total);
          }

          _monthlyData.add(_map);

          _yesterdayTotal = _utility.total;

          j++;
        }
      }
    }
    apiData.MoneyOfAll = {};
    /////////////////////////////////////

    //----------------------------//
    await apiData.getHolidayOfAll();
    if (apiData.HolidayOfAll != null) {
      for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
        _holidayList[apiData.HolidayOfAll['data'][i]] = '';
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    _prevMonth = DateTime(int.parse(_year), int.parse(_month) - 1, 1);
    _nextMonth = DateTime(int.parse(_year), int.parse(_month) + 1, 1);

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
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
              _dispMonthlyGraph(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                    Text(_yearmonth),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _goMonthlySpendItemScreen(date: widget.date),
                          child: const Icon(Icons.list),
                        ),
                        SizedBox(width: 10),
                        Text(_utility
                            .makeCurrencyDisplay(_monthTotal.toString())),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _goMonthlyListScreen(
                              context: context, date: _prevMonth.toString()),
                          child: const Icon(Icons.skip_previous),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _goMonthlyListScreen(
                              context: context, date: _nextMonth.toString()),
                          child: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _monthlyList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _dispMonthlyGraph() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      height: 250,
      child: SfCartesianChart(
        title: ChartTitle(
          textStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
        series: <ChartSeries>[
          LineSeries<MoneyData, double>(
              color: Colors.yellowAccent,
              dataSource: _chartData,
              xValueMapper: (MoneyData data, _) => data.day,
              yValueMapper: (MoneyData data, _) => data.total)
        ],
      ),
    );
  }

  /// リスト表示
  Widget _monthlyList() {
    return ListView.builder(
      itemCount: _monthlyData.length,
      itemBuilder: (context, int position) {
        return _listItem(position: position);
      },
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    _utility.makeYMDYData("$_yearmonth-${_monthlyData[position]['date']}", 0);

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: Card(
        color: _utility.getBgColor(
            '$_yearmonth-${_monthlyData[position]['date']}', _holidayList),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
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
                Text('${_monthlyData[position]['date']}'),
                Text(
                  _utility.youbiStr,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          title: DefaultTextStyle(
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white.withOpacity(0.6),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _utility.makeCurrencyDisplay(
                            _monthlyData[position]['total'].toString()),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _utility.makeCurrencyDisplay(
                            _monthlyData[position]['diff'].toString()),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Table(
                  children: [
                    TableRow(children: [
                      Text(
                        '${_monthlyData[position]['strYen10000']}',
                        style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen5000']}',
                        style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen2000']}',
                        style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen1000']}',
                        style: TextStyle(
                            color: Colors.greenAccent.withOpacity(0.6)),
                      ),
                      Text('${_monthlyData[position]['strYen500']}'),
                      Text('${_monthlyData[position]['strYen100']}'),
                      Text('${_monthlyData[position]['strYen50']}'),
                      Text(
                        '${_monthlyData[position]['strYen10']}',
                        style: TextStyle(
                            color: Colors.yellowAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen5']}',
                        style: TextStyle(
                            color: Colors.yellowAccent.withOpacity(0.6)),
                      ),
                      Text(
                        '${_monthlyData[position]['strYen1']}',
                        style: TextStyle(
                            color: Colors.yellowAccent.withOpacity(0.6)),
                      ),
                    ]),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: <Widget>[
                      Table(
                        children: [
                          TableRow(children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _monthlyData[position]['strBankA'])),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _monthlyData[position]['strBankB'])),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _monthlyData[position]['strBankC'])),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _monthlyData[position]['strBankD'])),
                            ),
                          ]),
                        ],
                      ),
                      (_monthlyData[position]['strBankE'] == '0')
                          ? Container()
                          : Table(
                              children: [
                                TableRow(children: [
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(_utility.makeCurrencyDisplay(
                                        _monthlyData[position]['strBankE'])),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: const Text('0'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: const Text('0'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: const Text('0'),
                                  ),
                                ]),
                              ],
                            ),
                      Table(
                        children: [
                          TableRow(children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _monthlyData[position]['strPayA'])),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _monthlyData[position]['strPayB'])),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _monthlyData[position]['strPayC'])),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _monthlyData[position]['strPayD'])),
                            ),
                          ]),
                        ],
                      ),
                      (_monthlyData[position]['strBankE'] == '0')
                          ? Container()
                          : Table(
                              children: [
                                TableRow(children: [
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(_utility.makeCurrencyDisplay(
                                        _monthlyData[position]['strPayE'])),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: const Text('0'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: const Text('0'),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: const Text('0'),
                                  ),
                                ]),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      //actions: <Widget>[],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: _utility.getBgColor(
              _yearmonth + '-' + _monthlyData[position]['date'], _holidayList),
          foregroundColor: Colors.blueAccent,
          icon: Icons.details,
          onTap: () => _goDetailDisplayScreen(
            context: context,
            date: _yearmonth + '-' + _monthlyData[position]['date'],
          ),
        ),
        IconSlideAction(
          color: _utility.getBgColor(
              _yearmonth + '-' + _monthlyData[position]['date'], _holidayList),
          foregroundColor: Colors.blueAccent,
          icon: Icons.input,
          onTap: () => _goOnedayInputScreen(
              context: context,
              date: _yearmonth + '-' + _monthlyData[position]['date']),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /// 画面遷移（MonthlyListScreen）
  void _goMonthlyListScreen(
      {required BuildContext context, required String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(date: date),
      ),
    );
  }

  /// 画面遷移（DetailDisplayScreen）
  void _goDetailDisplayScreen(
      {required BuildContext context, required String date}) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date);
    _utility.makeYMDYData(date, 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: int.parse(_utility.day),
          detailDisplayArgs: detailDisplayArgs,
        ),
      ),
    );
  }

  /// 画面遷移（OnedayInputScreen）
  void _goOnedayInputScreen(
      {required BuildContext context, required String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: date,
        ),
      ),
    );
  }

  ///
  void _goMonthlySpendItemScreen({required String date}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlySpendItemScreen(
          date: date,
          monthlyData: _monthlyData,
          yearmonth: _yearmonth,
        ),
      ),
    );
  }
}
