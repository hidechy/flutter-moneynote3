// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison, prefer_is_empty

import 'package:flutter/material.dart';

//TODO
//import 'package:charts_flutter/flutter.dart' as charts;

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'CreditSpendDisplayScreen.dart';
import 'FoodExpensesDisplayScreen.dart';

class SpendSummaryDisplayScreen extends StatefulWidget {
  String date;

  SpendSummaryDisplayScreen({Key? key, required this.date}) : super(key: key);

  @override
  _SpendSummaryDisplayScreenState createState() =>
      _SpendSummaryDisplayScreenState();
}

//graph
class SpendSummary {
  String item;
  int sales;

  SpendSummary(this.item, this.sales);
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

  //graph
  bool _graphDisplay = false;

  //TODO
  //
  //
  //
  // List<charts.Series<SpendSummary, String>> seriesList = [];
  //
  //
  //

  List<Map<dynamic, dynamic>> _timeplace1000over = [];
  int _totalTm1000over = 0;

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

    ///////////////////////
    await apiData.getYearSummaryOfDate(date: widget.date);
    if (apiData.YearSummaryOfDate != null) {
      //graph
      final _graphdata = <SpendSummary>[];

      //TODO
      //
      //
      //
      //
      // seriesList = [];
      //
      //
      //

      _total = 0;
      num _piechartOther = 0;
      for (var i = 0; i < apiData.YearSummaryOfDate['data'].length; i++) {
        _total += (apiData.YearSummaryOfDate['data'][i]['sum'] != null)
            ? apiData.YearSummaryOfDate['data'][i]['sum']
            : 0;

        Map _map = {};
        _map['item'] = apiData.YearSummaryOfDate['data'][i]['item'];
        _map['sum'] = apiData.YearSummaryOfDate['data'][i]['sum'];
        _map['percent'] = apiData.YearSummaryOfDate['data'][i]['percent'];
        _map['total'] = _total;
        _summaryData.add(_map);

        //graph
        _graphDisplay = true;

        if (apiData.YearSummaryOfDate['data'][i]['percent'] > 5) {
          _graphdata.add(
            SpendSummary(
              apiData.YearSummaryOfDate['data'][i]['item'],
              apiData.YearSummaryOfDate['data'][i]['sum'],
            ),
          );
        } else {
          _piechartOther +=
              (apiData.YearSummaryOfDate['data'][i]['sum'] != null)
                  ? apiData.YearSummaryOfDate['data'][i]['sum']
                  : 0;
        }
      }

      //graph
      if (_graphdata.length > 0) {
        //
        //
        // TODO
        //
        // _graphdata.add(
        //   SpendSummary(
        //     'その他',
        //     _piechartOther,
        //   ),
        //
        //

        _graphdata.add(
          SpendSummary(
            'その他',
            0,
          ),
        );
      } else {
        _graphDisplay = false;
      }

      //TODO
      //
      //
      //
      // //graph
      // seriesList.add(
      //   charts.Series<SpendSummary, String>(
      //     id: 'Sales',
      //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      //     domainFn: (SpendSummary sales, _) => sales.item,
      //     measureFn: (SpendSummary sales, _) => sales.sales,
      //     data: _graphdata,
      //   ),
      // );
      //
      //
      //

    }
    apiData.YearSummaryOfDate = {};
    ///////////////////////

    setState(() {});
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
  @override
  Widget build(BuildContext context) {
    var _dispDate = _selectedYear;
    if (_selectedMonth != '') {
      _dispDate += '-' + _selectedMonth;
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text(_dispDate),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: const Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
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
          Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white.withOpacity(0.8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: (_graphDisplay == false)
                      ? const SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          height: 200,

                          //TODO
                          //
                          //
                          //
                          //
                          // child: charts.PieChart(
                          //   seriesList,
                          //   animate: false,
                          //   behaviors: [
                          //     charts.DatumLegend(
                          //       position: charts.BehaviorPosition.end,
                          //       outsideJustification:
                          //           charts.OutsideJustification.endDrawArea,
                          //       horizontalFirst: false,
                          //       cellPadding: const EdgeInsets.only(
                          //           right: 4.0, bottom: 4.0),
                          //       entryTextStyle: charts.TextStyleSpec(
                          //         color: charts
                          //             .MaterialPalette.purple.shadeDefault,
                          //         fontSize: 11,
                          //       ),
                          //     )
                          //   ],
                          // ),
                          //
                          //
                          //
                          //
                          //
                          //
                          //
                        ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              (_graphDisplay == false)
                  ? Container(height: 230)
                  : Container(height: 200),
              Row(
                children: <Widget>[
                  (_graphDisplay == false)
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Text(
                            _utility.makeCurrencyDisplay(_total.toString()),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
              (_selectedMonth != "")
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () => _showBankRecord(),
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.green[900]!.withOpacity(0.5)),
                            child: const Icon(Icons.keyboard_arrow_up),
                          ),
                        ),
                      ],
                    )
                  : Container(),
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
                child: Container(
                  child: (_graphDisplay == false)
                      ? Container(
                          padding: const EdgeInsets.only(left: 20),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'no data',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                        )
                      : _summaryList(),
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
    return ListView.builder(
      itemCount: _summaryData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
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
            onTap: () => _goCreditSpendDisplayScreen(),
            child: const Icon(
              Icons.credit_card,
              color: Colors.greenAccent,
            ),
          );
        case "食費":
          return GestureDetector(
            onTap: () => _goFoodExpensesDisplayScreen(),
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
  Future<void> _monthSummaryDisplay({required String month}) async {
    _selectedMonth = month;
    _makeMonthButton();

    List<Map<dynamic, dynamic>> _summaryData2 = [];

    String date = "$_selectedYear-$month-01";
    await apiData.getMonthSummaryOfDate(date: date);
    if (apiData.MonthSummaryOfDate != null) {
      //graph
      final _graphdata = <SpendSummary>[];

      //TODO
      //
      //
      // seriesList = [];
      //
      //

      _total = 0;

      num _piechartOther = 0;
      for (var i = 0; i < apiData.MonthSummaryOfDate['data'].length; i++) {
        _total += (apiData.MonthSummaryOfDate['data'][i]['sum'] != null)
            ? apiData.MonthSummaryOfDate['data'][i]['sum']
            : 0;

        Map _map = {};
        _map['item'] = apiData.MonthSummaryOfDate['data'][i]['item'];
        _map['sum'] = apiData.MonthSummaryOfDate['data'][i]['sum'];
        _map['percent'] = apiData.MonthSummaryOfDate['data'][i]['percent'];
        _map['total'] = _total;
        _summaryData2.add(_map);

        //graph
        _graphDisplay = true;

        if (apiData.MonthSummaryOfDate['data'][i]['percent'] > 5) {
          _graphdata.add(
            SpendSummary(
              apiData.MonthSummaryOfDate['data'][i]['item'],
              apiData.MonthSummaryOfDate['data'][i]['sum'],
            ),
          );
        } else {
          _piechartOther +=
              (apiData.MonthSummaryOfDate['data'][i]['sum'] != null)
                  ? apiData.MonthSummaryOfDate['data'][i]['sum']
                  : 0;
        }
      }

      //graph
      if (_graphdata.length > 0) {
        _graphdata.add(
          //
          // TODO
          //
          // SpendSummary(
          //   'その他',
          //   _piechartOther,
          // ),
          //
          //

          SpendSummary(
            'その他',
            0,
          ),
        );
      } else {
        _graphDisplay = false;
      }

      //TODO
      //
      //
      //
      // //graph
      // seriesList.add(
      //   charts.Series<SpendSummary, String>(
      //     id: 'Sales',
      //     colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      //     domainFn: (SpendSummary sales, _) => sales.item,
      //     measureFn: (SpendSummary sales, _) => sales.sales,
      //     data: _graphdata,
      //   ),
      // );
      //
      //
      //

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
                (value[i]['price'] != null) ? int.parse(value[i]['price']) : 0;
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
  void _goCreditSpendDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreditSpendDisplayScreen(date: '$_selectedYear-$_selectedMonth-01'),
      ),
    );
  }

  ///
  void _goFoodExpensesDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FoodExpensesDisplayScreen(
                year: _selectedYear,
                month: _selectedMonth,
              )),
    );
  }
}
