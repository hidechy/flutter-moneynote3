// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';

//TODO
// import 'package:charts_flutter/flutter.dart' as charts;
//
//

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
  DateTime time;
  int sales;

  MoneyData(this.time, this.sales);
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

  //graph
  bool _graphDisplay = false;

  //TODO
  //
  // List<charts.Series<MoneyData, DateTime>> seriesList = [];
  //
  //
  //

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

    //graph
    final _graphdata = <MoneyData>[];

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

          if (j == 0) {
            _map['diff'] = (_prevMonthEndTotal - _utility.total);
            _monthTotal += (_prevMonthEndTotal - _utility.total);
          } else {
            _map['diff'] = (_yesterdayTotal - _utility.total);
            _monthTotal += (_yesterdayTotal - _utility.total);
          }

          _monthlyData.add(_map);

          _yesterdayTotal = _utility.total;
          //graph
          _graphDisplay = true;
          _graphdata.add(
            MoneyData(
                DateTime(
                  int.parse(_utility.year),
                  int.parse(_utility.month),
                  int.parse(_utility.day),
                ),
                _utility.total),
          );

          j++;
        }
      }
    }
    apiData.MoneyOfAll = {};
    /////////////////////////////////////

    //TODO
    //
    // //graph
    // seriesList.add(
    //   charts.Series<MoneyData, DateTime>(
    //     id: 'Sales',
    //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    //     domainFn: (MoneyData sales, _) => sales.time,
    //     measureFn: (MoneyData sales, _) => sales.sales,
    //     data: _graphdata,
    //   ),
    // );
    //
    //
    //
    //

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

  /// 画面描画
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(_yearmonth),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          color: Colors.greenAccent,
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () => _goMonthlyListScreen(
                context: context, date: _prevMonth.toString()),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌日',
            onPressed: () => _goMonthlyListScreen(
                context: context, date: _nextMonth.toString()),
          ),
        ],
      ),
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

          //----------------------//graph
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.white.withOpacity(0.8),
            child: (_graphDisplay == false)
                ? Container()
                : Container(
                    height: size.height - 40,
                    padding: const EdgeInsets.all(10),

                    //TODO
                    //
                    // child: charts.TimeSeriesChart(
                    //   seriesList,
                    //   animate: false,
                    //   dateTimeFactory: const charts.LocalDateTimeFactory(),
                    //   defaultRenderer: charts.LineRendererConfig(
                    //     includePoints: true,
                    //   ),
                    // ),
                    //
                    //
                    //
                  ),
          ),
          //----------------------//graph

          Column(
            children: <Widget>[
              Container(
                height: 250,
              ),
              Expanded(
                child: _utility.getBackGround(context: context),
              ),
            ],
          ),

          Column(
            children: <Widget>[
              Container(
                height: 250,
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 5,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
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
                    GestureDetector(
                      onTap: () => _goMonthlySpendItemScreen(date: widget.date),
                      child: const Icon(Icons.list),
                    ),
                    Text(_utility.makeCurrencyDisplay(_monthTotal.toString())),
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
