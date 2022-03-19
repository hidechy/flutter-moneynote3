// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class FoodExpensesDisplayScreen extends StatefulWidget {
  String year;
  String month;

  FoodExpensesDisplayScreen({Key? key, required this.year, required this.month})
      : super(key: key);

  @override
  _FoodExpensesDisplayScreenState createState() =>
      _FoodExpensesDisplayScreenState();
}

class _FoodExpensesDisplayScreenState extends State<FoodExpensesDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  int _foodExpenses = 0;
  int _seiyuPurchase = 0;
  int _bentouExpenses = 0;

  int _monthEndDay = 0;

  int _monthTotal = 0;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    DateTime _today = DateTime.now();
    _utility.makeYMDYData(_today.toString(), 0);

    if (_utility.year == widget.year && _utility.month == widget.month) {
      _monthEndDay = int.parse(_utility.day);

      //-------------------------------------------//(s)
      var _date = '${_utility.year}-${_utility.month}-${_utility.day}';
      await apiData.getMoneyOfDate(date: _date);
      if (apiData.MoneyOfDate != null) {
        _utility.makeTotal(apiData.MoneyOfDate['data']);
      }
      apiData.MoneyOfDate = {};

      var _num2 = _utility.total;

      _utility.makeMonthEnd(int.parse(widget.year), int.parse(widget.month), 0);

      _utility.makeYMDYData(_utility.monthEndDateTime, 0);

      var _date2 = '${_utility.year}-${_utility.month}-${_utility.day}';
      await apiData.getMoneyOfDate(date: _date2);
      if (apiData.MoneyOfDate != null) {
        _utility.makeTotal(apiData.MoneyOfDate['data']);
      }
      apiData.MoneyOfDate = {};

      var _num1 = _utility.total;

      _monthTotal = (_num1 - _num2);
      //-------------------------------------------//(e)
    } else {
      _utility.makeMonthEnd(
          int.parse(widget.year), int.parse(widget.month) + 1, 0);
      _utility.makeYMDYData(_utility.monthEndDateTime, 0);
      _monthEndDay = int.parse(_utility.day);

      //-------------------------------------------//(s)
      var _date3 = '${widget.year}-${widget.month}-$_monthEndDay';
      await apiData.getMoneyOfDate(date: _date3);
      if (apiData.MoneyOfDate != null) {
        _utility.makeTotal(apiData.MoneyOfDate['data']);
      }
      apiData.MoneyOfDate = {};

      var _num2 = _utility.total;

      _utility.makeMonthEnd(int.parse(widget.year), int.parse(widget.month), 0);

      _utility.makeYMDYData(_utility.monthEndDateTime, 0);

      var _date4 = '${_utility.year}-${_utility.month}-${_utility.day}';
      await apiData.getMoneyOfDate(date: _date4);
      if (apiData.MoneyOfDate != null) {
        _utility.makeTotal(apiData.MoneyOfDate['data']);
      }
      apiData.MoneyOfDate = {};

      var _num1 = _utility.total;

      //<<<<<<<<<<<<//
      var _bene = '0';
      await apiData.getBenefitOfAll();
      if (apiData.BenefitOfAll != null) {
        for (var i = 0; i < apiData.BenefitOfAll['data'].length; i++) {
          var exDate = (apiData.BenefitOfAll['data'][i]).split('|');
          if (exDate[1] == "${widget.year}-${widget.month}") {
            _bene = exDate[2];
            break;
          }
        }
      }
      //<<<<<<<<<<<<//

      _monthTotal = (_num2 - _num1 - int.parse(_bene)) * -1;
      //-------------------------------------------//(e)
    }

    // ///////////////////////////////////////

    ////////////////////////////////////////
    var _date5 = "${widget.year}-${widget.month}-01";
    await apiData.getMonthSummaryOfDate(date: _date5);
    if (apiData.MonthSummaryOfDate != null) {
      for (int i = 0; i < apiData.MonthSummaryOfDate['data'].length; i++) {
        if (apiData.MonthSummaryOfDate['data'][i]['item'] == "食費") {
          _foodExpenses = apiData.MonthSummaryOfDate['data'][i]['sum'];
        }

        if (apiData.MonthSummaryOfDate['data'][i]['item'] == "弁当代") {
          _bentouExpenses = apiData.MonthSummaryOfDate['data'][i]['sum'];
        }
      }
    }

    apiData.MonthSummaryOfDate = {};
    ////////////////////////////////////////

    //----------------------------
    var _date6 = '${widget.year}-${widget.month}-01';
    await apiData.getSeiyuuPurchaseOfDate(date: _date6);
    if (apiData.SeiyuuPurchaseOfDate != null) {
      for (int i = 0; i < apiData.SeiyuuPurchaseOfDate['data'].length; i++) {
        var exDate =
            (apiData.SeiyuuPurchaseOfDate['data'][i]['date']).split('-');
        if (exDate[0] == widget.year && exDate[1] == widget.month) {
          if (RegExp(r'非食品')
              .hasMatch(apiData.SeiyuuPurchaseOfDate['data'][i]['item'])) {
            continue;
          }

          _seiyuPurchase +=
              int.parse(apiData.SeiyuuPurchaseOfDate['data'][i]['price']);
        }
      }
    }
    apiData.SeiyuuPurchaseOfDate = {};
    //----------------------------

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var sum = (_foodExpenses + _seiyuPurchase + _bentouExpenses);
    var ave = (sum / _monthEndDay).floor();

    var engels = (_monthTotal > 0) ? ((sum / _monthTotal) * 100).floor() : 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Food Expenses'),
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
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                ),
                child: Text('${widget.year}-${widget.month}'),
              ),
              const Divider(
                  color: Colors.indigo, indent: 10.0, endIndent: 10.0),
              Container(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text('食費'),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _foodExpenses.toString())),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text('西友購入'),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _seiyuPurchase.toString())),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text('弁当代'),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _bentouExpenses.toString())),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Container(
                      child: Table(
                        children: [
                          TableRow(children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: const Text('計'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                  _utility.makeCurrencyDisplay(sum.toString())),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                  color: Colors.indigo, indent: 10.0, endIndent: 10.0),
              Container(
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                ),
                child: Table(
                  children: [
                    TableRow(children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Text('平均（$_monthEndDay日間）'),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child:
                            Text(_utility.makeCurrencyDisplay(ave.toString())),
                      ),
                    ]),
                    TableRow(children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: const Text('エンゲル係数'),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text('$engels %'),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
