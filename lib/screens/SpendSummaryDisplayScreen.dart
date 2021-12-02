// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison, unused_local_variable

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'CreditSpendDisplayScreen.dart';
import 'FoodExpensesDisplayScreen.dart';
import 'YearSummaryCompareScreen.dart';
import 'YearSummaryScreen.dart';

class SpendSummaryDisplayScreen extends StatefulWidget {
  String date;

  SpendSummaryDisplayScreen({Key? key, required this.date}) : super(key: key);

  @override
  _SpendSummaryDisplayScreenState createState() =>
      _SpendSummaryDisplayScreenState();
}

class SpendSummary {
  final String item;
  final num sum;

  SpendSummary(this.item, this.sum);
}

class _SpendSummaryDisplayScreenState extends State<SpendSummaryDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<DropdownMenuItem<String>> _dropdownYears = [];

  String _selectedYear = '';
  String _selectedMonth = '';

  List<Widget> _monthButton = [];

  num _total = 0;
  List<Map<dynamic, dynamic>> _summaryData = [];

  List<SpendSummary> _chartData = [];

  List<Map<dynamic, dynamic>> _timeplace1000over = [];
  num _totalTm1000over = 0;

  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    List explodedDate = DateTime.now().toString().split(' ');
    List explodedSelectedDate = explodedDate[0].split('-');

    for (int i = int.parse(explodedSelectedDate[0]); i >= 2020; i--) {
      _dropdownYears.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Text(i.toString()),
        ),
      );
    }

    _utility.makeYMDYData(widget.date, 0);
    _selectedYear = _utility.year;

    _makeMonthButton();

    num _piechartOther = 0;
    ///////////////////////
    await apiData.getYearSummaryOfDate(date: widget.date);
    if (apiData.YearSummaryOfDate != null) {
      _total = 0;
      num _piechartOther = 0;
      for (var i = 0; i < apiData.YearSummaryOfDate['data'].length; i++) {
        Map _map = {};
        _map['item'] = apiData.YearSummaryOfDate['data'][i]['item'];
        _map['sum'] = apiData.YearSummaryOfDate['data'][i]['sum'];
        _map['percent'] = apiData.YearSummaryOfDate['data'][i]['percent'];
        _map['total'] = _total;
        _summaryData.add(_map);

        _total += (_map['sum'] != null) ? _map['sum'] : 0;

        if (_map['percent'] > 5) {
          _chartData.add(SpendSummary(_map['item'], _map['sum']));
        } else {
          _piechartOther += (_map['sum'] != null) ? _map['sum'] : 0;
        }
      }
    }
    apiData.YearSummaryOfDate = {};
    ///////////////////////

    if (_piechartOther > 0) {
      _chartData.add(SpendSummary('その他', _piechartOther));
    }

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
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
              _dispGraph(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(width: 20),
                        (_selectedMonth != "")
                            ? GestureDetector(
                                onTap: () => _showBankRecord(),
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.greenAccent,
                                ),
                              )
                            : GestureDetector(
                                onTap: () => _goYearSummaryScreen(),
                                child: const Icon(
                                  Icons.select_all,
                                  color: Colors.greenAccent,
                                ),
                              ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => _goYearSummaryCompareScreen(),
                          child: const Icon(
                            Icons.list,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$_total',
                      style: const TextStyle(color: Colors.yellowAccent),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: DropdownButton(
                        dropdownColor: Colors.black.withOpacity(0.1),
                        items: _dropdownYears,
                        value: _selectedYear,
                        onChanged: (value) =>
                            _goSpendSummaryDisplayScreen(value: value),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _monthButton,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: (_summaryData.isNotEmpty)
                    ? _summaryList()
                    : Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: const Text(
                          'No Data.',
                          style: TextStyle(color: Colors.yellowAccent),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _summaryList() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView.builder(
        itemCount: _summaryData.length,
        itemBuilder: (context, int position) => _listItem(position: position),
      ),
    );
  }

  ///
  Widget _listItem({required int position}) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 10.0),
          child: Table(
            children: [
              TableRow(children: [
                Text('${_summaryData[position]['item']}'),
                Container(
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(_utility.makeCurrencyDisplay(
                          _summaryData[position]['sum'].toString())),
                      Text(
                        '${_summaryData[position]['total']}',
                        style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text('${_summaryData[position]['percent']}'),
                ),
              ]),
            ],
          ),
        ),
        trailing: _makeTrailing(position: position),
      ),
    );
  }

  ///
  Widget _makeTrailing({position}) {
    if (_selectedMonth == '') {
      return const Icon(Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e));
    } else {
      switch (_summaryData[position]['item']) {
        case "credit":
          return GestureDetector(
//            onTap: () => _goCreditSpendDisplayScreen(),
            onTap: () {
              Get.to(() => CreditSpendDisplayScreen(
                  date: '$_selectedYear-$_selectedMonth-01'));
            },
            child: const Icon(
              Icons.credit_card,
              color: Colors.greenAccent,
            ),
          );
        case "食費":
          return GestureDetector(
//            onTap: () => _goFoodExpensesDisplayScreen(),
            onTap: () {
              Get.to(() => FoodExpensesDisplayScreen(
                  year: _selectedYear, month: _selectedMonth));
            },
            child: const Icon(
              Icons.fastfood,
              color: Colors.greenAccent,
            ),
          );
        default:
          return const Icon(Icons.check_box_outline_blank,
              color: Color(0xFF2e2e2e));
      }
    }
  }

  ///
  Widget _dispGraph() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      height: 250,
      child: SfCircularChart(
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          PieSeries<SpendSummary, String>(
            dataSource: _chartData,
            xValueMapper: (SpendSummary data, _) => data.item,
            yValueMapper: (SpendSummary data, _) => data.sum,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
          )
        ],
      ),
    );
  }

  ///
  void _makeMonthButton() {
    _monthButton = [];

    for (int i = 1; i <= 12; i++) {
      _monthButton.add(
        GestureDetector(
          onTap: () =>
              _monthSummaryDisplay(month: i.toString().padLeft(2, '0')),
          child: Container(
            width: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: (i.toString().padLeft(2, '0') == _selectedMonth)
                  ? Colors.yellowAccent.withOpacity(0.3)
                  : Colors.black.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Center(child: Text(i.toString().padLeft(2, '0'))),
          ),
        ),
      );
    }
  }

  ///
  Future<void> _monthSummaryDisplay({required String month}) async {
    _selectedMonth = month;
    _makeMonthButton();

    _chartData = [];

    List<Map<dynamic, dynamic>> _summaryData2 = [];

    String date = "$_selectedYear-$month-01";
    await apiData.getMonthSummaryOfDate(date: date);
    if (apiData.MonthSummaryOfDate != null) {
      _total = 0;
      num _piechartOther = 0;
      for (var i = 0; i < apiData.MonthSummaryOfDate['data'].length; i++) {
        Map _map = {};
        _map['item'] = apiData.MonthSummaryOfDate['data'][i]['item'];
        _map['sum'] = apiData.MonthSummaryOfDate['data'][i]['sum'];
        _map['percent'] = apiData.MonthSummaryOfDate['data'][i]['percent'];
        _map['total'] = _total;
        _summaryData2.add(_map);

        _total += (_map['sum'] != null) ? _map['sum'] : 0;

        if (_map['percent'] > 5) {
          _chartData.add(SpendSummary(_map['item'], _map['sum']));
        } else {
          _piechartOther += (_map['sum'] != null) ? _map['sum'] : 0;
        }
      }

      if (_piechartOther > 0) {
        _chartData.add(SpendSummary('その他', _piechartOther));
      }
    }
    apiData.MonthSummaryOfDate = {};

    _summaryData = _summaryData2;

    setState(() {});
  }

  ///
  void _showBankRecord() async {
    var bankTotal = 0;

    //----------------------------//
    Map bankRecord = {};
    var date2 = '$_selectedYear-$_selectedMonth-01';
    await apiData.getMonthlyBankRecordOfDate(date: date2);
    if (apiData.MonthlyBankRecordOfDate != null) {
      bankRecord = apiData.MonthlyBankRecordOfDate;

      for (var i = 0; i < apiData.MonthlyBankRecordOfDate['data'].length; i++) {
        bankTotal +=
            int.parse(apiData.MonthlyBankRecordOfDate['data'][i]['price']);
      }
    }
    apiData.MonthlyBankRecordOfDate = {};
    //----------------------------//

    /////////////////////////////
    var date = "$_selectedYear-$_selectedMonth-01";
    await apiData.getMonthlyTimePlaceDataOfDate(date: date);
    if (apiData.MonthlyTimePlaceDataOfDate != null) {
      _timeplace1000over = [];
      _totalTm1000over = 0;

      apiData.MonthlyTimePlaceDataOfDate['data'].forEach((key, value) {
        for (var i = 0; i < value.length; i++) {
          if (value[i]['price'] >= 1000) {
            Map _map = {};
            _map['date'] = '$key　${value[i]['time']}';
            _map['place'] = value[i]['place'];
            _map['price'] = value[i]['price'];
            _timeplace1000over.add(_map);

            _totalTm1000over +=
                (value[i]['price'] != null) ? value[i]['price'] : 0;
          }
        }
      });
    }
    apiData.MonthlyTimePlaceDataOfDate = {};
    /////////////////////////////

    return showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.1),
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border(
                top: BorderSide(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  width: 10,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Divider(color: Colors.indigo),
                Container(
                  height: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _showBankRecordRow(value: bankRecord['data']),
                ),
                const Divider(color: Colors.indigo),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(_utility.makeCurrencyDisplay(_total.toString())),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text('-'),
                      ),
                      Text(_utility.makeCurrencyDisplay(bankTotal.toString())),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Text('<Hand>'),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text('='),
                      ),
                      Text(_utility.makeCurrencyDisplay(
                          (_total - bankTotal).toString())),
                    ],
                  ),
                ),
                const Divider(color: Colors.indigo),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _showTm1000OverRow(value: _timeplace1000over),
                ),
                const Divider(color: Colors.indigo),
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(_utility
                      .makeCurrencyDisplay(_totalTm1000over.toString())),
                ),
                Container(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///
  Widget _showBankRecordRow({value}) {
    List<Widget> _list = [];

    if (value != null) {
      for (var i = 0; i < value.length; i++) {
        _list.add(
          Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            )),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
              ),
              child: Table(
                children: [
                  TableRow(
                    children: [
                      Text('${value[i]['bank']} / ${value[i]['day']}'),
                      Text('${value[i]['item']}'),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(_utility
                            .makeCurrencyDisplay(value[i]['price'].toString())),
                      ),
                    ],
                  )
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
  _showTm1000OverRow({required List<Map> value}) {
    List<Widget> _list = [];
    for (var i = 0; i < value.length; i++) {
      _list.add(
        Table(
          children: [
            TableRow(
              children: [
                Text(
                  '${value[i]['date']}',
                  strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${value[i]['place']}',
                    strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    _utility.makeCurrencyDisplay(value[i]['price'].toString()),
                    strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Column(
          children: _list,
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  ///
  void _goSpendSummaryDisplayScreen({value}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpendSummaryDisplayScreen(date: '$value-01-01'),
      ),
    );
  }

  ///
  void _goYearSummaryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YearSummaryScreen(
          year: _selectedYear,
          month: '',
        ),
      ),
    );
  }

  ///
  void _goYearSummaryCompareScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const YearSummaryCompareScreen(),
      ),
    );
  }
}
