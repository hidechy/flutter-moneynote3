// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison, deprecated_member_use, avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:moneynote5/screens/SamedayListScreen.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bubble/bubble.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'GoldDisplayScreen.dart';
import 'SpendDetailPagingScreen.dart';
import 'AlldayListScreen.dart';
import 'MonthlyListScreen.dart';
import 'OnedayInputScreen.dart';
import 'ScoreListScreen.dart';
import 'InvestmentTabScreen.dart';
import 'BankInputScreen.dart';

class DetailDisplayScreen extends StatefulWidget {
  String date;
  int index;
  Map detailDisplayArgs;

  DetailDisplayScreen(
      {Key? key,
      required this.date,
      required this.index,
      required this.detailDisplayArgs})
      : super(key: key);

  @override
  _DetailDisplayScreenState createState() => _DetailDisplayScreenState();
}

class _DetailDisplayScreenState extends State<DetailDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  String _displayYear = '';
  String _displayMonth = '';

  String _youbiStr = '';

  String _displayDate = '';

  DateTime _prevDate = DateTime.now();
  DateTime _nextDate = DateTime.now();

  List<List<dynamic>> _monthDays = [];

  AutoScrollController _controller = AutoScrollController();

  String _yen10000 = '0';
  String _yen5000 = '0';
  String _yen2000 = '0';
  String _yen1000 = '0';
  String _yen500 = '0';
  String _yen100 = '0';
  String _yen50 = '0';
  String _yen10 = '0';
  String _yen5 = '0';
  String _yen1 = '0';

  String _bankA = '0';
  String _bankB = '0';
  String _bankC = '0';
  String _bankD = '0';
  String _bankE = '0';
  String _bankF = '0';
  String _bankG = '0';
  String _bankH = '0';

  String _payA = '0';
  String _payB = '0';
  String _payC = '0';
  String _payD = '0';
  String _payE = '0';
  String _payF = '0';
  String _payG = '0';
  String _payH = '0';

  int _total = 0;
  int _temochi = 0;

  int _spend = 0;
  var _lastMonthTotal = 0;
  int _monthSpend = 0;
  int _lastSpend = 0;

  Map<dynamic, dynamic> _bankNames = {};

  Map<String, dynamic> _holidayList = {};

  Map golddata = {};
  int _goldValue = 0;
  String _goldDate = '-';
  int _payPrice = 0;

  int _depositTotal = 0;
  int _eMoneyTotal = 0;

  Map _stockData = {};
  Map _shintakuData = {};

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(widget.date, 0);

    _displayYear = _utility.year;
    _displayMonth = _utility.month;

    _youbiStr = _utility.youbiStr;

    _displayDate =
        '${_utility.year}-${_utility.month}-${_utility.day.padLeft(2, '0')}';

    _prevDate = DateTime(int.parse(_utility.year), int.parse(_utility.month),
        int.parse(_utility.day) - 1);
    _nextDate = DateTime(int.parse(_utility.year), int.parse(_utility.month),
        int.parse(_utility.day) + 1);

    ////////////////////////////////////////////////
    _utility.makeMonthEnd(
        int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
    _utility.makeYMDYData(_utility.monthEndDateTime, 0);

    for (int i = 0; i <= int.parse(_utility.day); i++) {
      _monthDays.add([
        i,
        i.toString().padLeft(2, '0'),
      ]);
    }
    ////////////////////////////////////////////////

    /////////////////////////////////////////////////////
    _controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(
        0,
        0,
        0,
        MediaQuery.of(context).padding.bottom,
      ),
      axis: Axis.vertical,
    );

    await _controller.scrollToIndex(widget.index,
        preferPosition: AutoScrollPosition.begin);

    /////////////////////////////////////////////////////
    if (widget.detailDisplayArgs['today'] != null) {
      var exTodayData = (widget.detailDisplayArgs['today']).split('|');

      _yen10000 = exTodayData[0];
      _yen5000 = exTodayData[1];
      _yen2000 = exTodayData[2];
      _yen1000 = exTodayData[3];
      _yen500 = exTodayData[4];
      _yen100 = exTodayData[5];
      _yen50 = exTodayData[6];
      _yen10 = exTodayData[7];
      _yen5 = exTodayData[8];
      _yen1 = exTodayData[9];

      _bankA = exTodayData[10];
      _bankB = exTodayData[11];
      _bankC = exTodayData[12];
      _bankD = exTodayData[13];
      _bankE = exTodayData[14];

      _payA = exTodayData[15];
      _payB = exTodayData[16];
      _payC = exTodayData[17];
      _payD = exTodayData[18];
      _payE = exTodayData[19];

      _utility.makeTotal(widget.detailDisplayArgs['today']);
      _total = _utility.total;
      _temochi = _utility.temochi;
    }
    /////////////////////////////////////////////////////

    var _yesterdayTotal = 0;
    if (widget.detailDisplayArgs['yesterday'] != null) {
      _utility.makeTotal(widget.detailDisplayArgs['yesterday']);
      _yesterdayTotal = _utility.total;
      _spend = (_yesterdayTotal - _total);
    }

    if (widget.detailDisplayArgs['lastMonthEnd'] != null) {
      _utility.makeTotal(widget.detailDisplayArgs['lastMonthEnd']);
      _lastMonthTotal = _utility.total;
    }

    _monthSpend = (_lastMonthTotal - _total);
    _lastSpend = (_lastMonthTotal - _yesterdayTotal);

    _bankNames = _utility.getBankName();

    //----------------------------//
    await apiData.getHolidayOfAll();
    if (apiData.HolidayOfAll != null) {
      for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
        _holidayList[apiData.HolidayOfAll['data'][i]] = '';
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    //----------------------------//
    await apiData.getListOfGoldData();
    if (apiData.ListOfGoldData != null) {
      for (var i = 0; i < apiData.ListOfGoldData['data'].length; i++) {
        if (apiData.ListOfGoldData['data'][i]['gold_value'] != '-') {
          _goldValue = apiData.ListOfGoldData['data'][i]['gold_value'];

          _payPrice = apiData.ListOfGoldData['data'][i]['pay_price'];

          _goldDate =
              '${apiData.ListOfGoldData['data'][i]['year']}-${apiData.ListOfGoldData['data'][i]['month']}-${apiData.ListOfGoldData['data'][i]['day']}';
        }
      }
    }

    apiData.ListOfGoldData = {};
    //----------------------------//

    //>>>>>>>>>>>>>>>>>>>>>>>>
    await apiData.getListOfStockData();
    if (apiData.ListOfStockData != null) {
      _stockData['cost'] = apiData.ListOfStockData['data']['cost'];
      _stockData['price'] = apiData.ListOfStockData['data']['price'];
      _stockData['date'] = apiData.ListOfStockData['data']['date'];
    }
    apiData.ListOfStockData = {};
    //>>>>>>>>>>>>>>>>>>>>>>>>

    //>>>>>>>>>>>>>>>>>>>>>>>>
    await apiData.getListOfShintakuData();
    if (apiData.ListOfShintakuData != null) {
      _shintakuData['cost'] = apiData.ListOfShintakuData['data']['cost'];
      _shintakuData['price'] = apiData.ListOfShintakuData['data']['price'];
      _shintakuData['date'] = apiData.ListOfShintakuData['data']['date'];
    }
    apiData.ListOfShintakuData = {};
    //>>>>>>>>>>>>>>>>>>>>>>>>

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
          _detailDisplayBox(context),
        ],
      ),
    );
  }

  ///
  Widget _detailDisplayBox(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                color: Colors.black.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            tooltip: '前日',
                            onPressed: () => _goPrevDate(context: context),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 10),
                            child: DefaultTextStyle(
                              style: const TextStyle(fontSize: 14),
                              child: Text('$_displayDate（$_youbiStr）'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            tooltip: '翌日',
                            onPressed: () => _goNextDate(context: context),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.indigo),
                      _dispTotal(),
                      const Divider(color: Colors.indigo),
                      _dispCurrency(),
                      const SizedBox(height: 10),
                      _dispDeposit(),
                      const SizedBox(height: 10),
                      _dispEMoney(),
                      const Divider(color: Colors.indigo),
                      _dispToushiData(),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: ElevatedButton(
                    //color: Colors.black.withOpacity(0.3),

                    style: ElevatedButton.styleFrom(
                      primary: Colors.black.withOpacity(0.5),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),

                    onPressed: () => _showUnderMenu(),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.greenAccent,
                    ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(20.0),
                    // ),
                  ),
                ),
              ),
              //------------------------------------------------------------------------//
            ],
          ),
        ),
        ///////////////////////////////
        SizedBox(
          width: 60,
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(top: 5),
                color: Colors.black.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: Colors.greenAccent,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _goDetailDisplayScreen(
                        context: context,
                        date: _displayDate,
                        index: widget.index,
                      ),
                      color: Colors.greenAccent,
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _showDatepicker(context: context),
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: Colors.black.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(_displayYear),
                      Text(_displayMonth),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _monthDaysList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispTotal() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 14),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text('month start'),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(_utility.makeCurrencyDisplay(
                                _lastMonthTotal.toString())),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text('month spend'),
                        ),
                        Container(
                          width: 60,
                          alignment: Alignment.topRight,
                          child: Icon(
                            FontAwesomeIcons.caretRight,
                            color: Colors.greenAccent.withOpacity(0.6),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.greenAccent.withOpacity(0.3),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(_utility
                                .makeCurrencyDisplay(_monthSpend.toString())),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'total',
                                style: TextStyle(color: Colors.yellowAccent),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text.rich(
                                TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: '①②③　',
                                      style:
                                          TextStyle(color: Colors.greenAccent),
                                    ),
                                    TextSpan(
                                      text: _utility.makeCurrencyDisplay(
                                          _total.toString()),
                                      style: const TextStyle(
                                          color: Colors.yellowAccent),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Bubble(
                      nip: BubbleNip.rightTop,
                      color: Colors.greenAccent.withOpacity(0.2),
                      nipWidth: 20,
                      child: DefaultTextStyle(
                        style: const TextStyle(fontSize: 12),
                        child: Column(
                          children: <Widget>[
                            Table(
                              children: [
                                TableRow(children: [
                                  const Text('today spend'),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(_utility.makeCurrencyDisplay(
                                        _spend.toString())),
                                  ),
                                ]),
                              ],
                            ),
                            Table(
                              children: [
                                TableRow(children: [
                                  const Text('last spend'),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(_utility.makeCurrencyDisplay(
                                        _lastSpend.toString())),
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: IconButton(
                  color: Colors.greenAccent,
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    Get.to(() => SpendDetailPagingScreen(date: _displayDate));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispCurrency() {
    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900]!.withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('currency'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(
                      alignment: Alignment.topRight,
                      child: const Text('①',
                          style: TextStyle(color: Colors.greenAccent)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.greenAccent.withOpacity(0.3),
                              width: 1),
                        ),
                      ),
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        _utility.makeCurrencyDisplay(_temochi.toString()),
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ]),
                ],
              ),
              ___dispCurrencyData(),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispDeposit() {
    List<String> _tot = [];
    _tot.add(_bankA);
    _tot.add(_bankB);
    _tot.add(_bankC);
    _tot.add(_bankD);
    _tot.add(_bankE);
    _tot.add(_bankF);
    _tot.add(_bankG);
    _tot.add(_bankH);

    _depositTotal = 0;
    for (var i = 0; i < _tot.length; i++) {
      _depositTotal += int.parse(_tot[i]);
    }

    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900]!.withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('deposit'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(
                      alignment: Alignment.topRight,
                      child: const Text('②',
                          style: TextStyle(color: Colors.greenAccent)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.greenAccent.withOpacity(0.3),
                              width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 5),
                      alignment: Alignment.topRight,
                      child: Text(
                        _utility.makeCurrencyDisplay(_depositTotal.toString()),
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ]),
                ],
              ),
              ___dispDepositData(),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispEMoney() {
    List<String> _tot = [];
    _tot.add(_payA);
    _tot.add(_payB);
    _tot.add(_payC);
    _tot.add(_payD);
    _tot.add(_payE);
    _tot.add(_payF);
    _tot.add(_payG);
    _tot.add(_payH);

    _eMoneyTotal = 0;
    for (var i = 0; i < _tot.length; i++) {
      _eMoneyTotal += int.parse(_tot[i]);
    }

    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900]!.withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('e-money'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(
                      alignment: Alignment.topRight,
                      child: const Text('③',
                          style: TextStyle(color: Colors.greenAccent)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.greenAccent.withOpacity(0.3),
                              width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 5),
                      alignment: Alignment.topRight,
                      child: Text(
                        _utility.makeCurrencyDisplay(_eMoneyTotal.toString()),
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ]),
                ],
              ),
              ___dispEMoneyData(),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispToushiData() {
    if (_stockData['date'] == null) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.yellowAccent.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Column(
              children: <Widget>[
                Table(
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.green[900]!.withOpacity(0.5),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            child: Text('investment'),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Text(
                          '(IN)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Text(
                          '(OUT)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => GoldDisplayScreen());
                            },
                            child: const Icon(
                              Icons.label,
                              color: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => InvestmentTabScreen());
                            },
                            child: const Icon(
                              Icons.comment,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 70,
                              child: Text('GOLD'),
                            ),
                            Container(
                              width: 60,
                              alignment: Alignment.topRight,
                              child: Text(_utility
                                  .makeCurrencyDisplay(_payPrice.toString())),
                            ),
                            Container(
                              width: 60,
                              alignment: Alignment.topRight,
                              child: Text(_utility
                                  .makeCurrencyDisplay(_goldValue.toString())),
                            ),
                            Container(
                              width: 80,
                              alignment: Alignment.topRight,
                              child: Text(_goldDate),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 70,
                              child: Text('STOCK'),
                            ),
                            Container(
                              width: 60,
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _stockData['cost'].toString())),
                            ),
                            Container(
                              width: 60,
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _stockData['price'].toString())),
                            ),
                            Container(
                              width: 80,
                              alignment: Alignment.topRight,
                              child: Text('${_stockData['date']}'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 70,
                              child: Text('ETF'),
                            ),
                            Container(
                              width: 60,
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _shintakuData['cost'].toString())),
                            ),
                            Container(
                              width: 60,
                              alignment: Alignment.topRight,
                              child: Text(_utility.makeCurrencyDisplay(
                                  _shintakuData['price'].toString())),
                            ),
                            Container(
                              width: 80,
                              alignment: Alignment.topRight,
                              child: Text('${_shintakuData['date']}'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 下部メニュー表示
  Future<dynamic> _showUnderMenu() {
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
                ListTile(
                  leading: const Icon(Icons.input),
                  title: const Text(
                    'Oneday Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() => OnedayInputScreen(date: _displayDate));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text(
                    'Bank Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() => BankInputScreen(date: _displayDate));
                  },
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text(
                      'Monthly List',
                      style: TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      Get.to(() => MonthlyListScreen(date: _displayDate));
                    }),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text(
                    'Score List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() => ScoreListScreen(date: _displayDate));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.all_out),
                  title: const Text(
                    'AllDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  // onTap: () =>
                  //     _goAlldayListScreen(context: context, date: _displayDate),
                  onTap: () {
                    Get.to(() => AlldayListScreen(date: _displayDate));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.animation),
                  title: const Text(
                    'AllDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() => SamedayListScreen(date: _displayDate));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// デートピッカー表示
  void _showDatepicker({required BuildContext context}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 6),
      locale: const Locale('ja'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            backgroundColor: Colors.black.withOpacity(0.1),
            scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
            canvasColor: Colors.black.withOpacity(0.1),
            cardColor: Colors.black.withOpacity(0.1),
            cursorColor: Colors.white,
            buttonColor: Colors.black.withOpacity(0.1),
            bottomAppBarColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            accentColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            textSelectionColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
            selectedRowColor: Colors.black.withOpacity(0.1),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      _goDetailDisplayScreen(
          context: context, date: selectedDate.toString(), index: 1);
    }
  }

  /// リスト表示
  Widget _monthDaysList() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        scrollDirection: Axis.vertical,
        controller: _controller,
        children: _monthDays.map<Widget>((data) {
          var _bgColor = _utility.getBgColor(
              '$_displayYear-$_displayMonth-${data[1]}', _holidayList);

          var exDisplayDate = (_displayDate).split('-');
          if (data[1] == exDisplayDate[2]) {
            _bgColor = Colors.yellowAccent.withOpacity(0.3);
          }

          return (data[0] == 0)
              ? Container()
              : Card(
                  color: _bgColor,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    onTap: () =>
                        _goMonthDay(context: context, position: data[0]),
                    title: AutoScrollTag(
                      index: data[0],
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${data[1]}',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      key: ValueKey(data[0]),
                      controller: _controller,
                    ),
                  ),
                );
        }).toList(),
      ),
    );
  }

  ///
  Widget ___dispCurrencyData() {
    List<String> _list = [];
    _list.add('10000:$_yen10000');
    _list.add('5000:$_yen5000');
    _list.add('2000:$_yen2000');
    _list.add('1000:$_yen1000');
    _list.add('500:$_yen500');
    _list.add('100:$_yen100');
    _list.add('50:$_yen50');
    _list.add('10:$_yen10');
    _list.add('5:$_yen5');
    _list.add('1:$_yen1');

    return ____dispEachData('currency', _list);
  }

  ///
  Widget ____dispEachData(String type, List<String> list) {
    List<Widget> _list = [];

    var _roopNum = ((list.length) / 2).round();

    for (var i = 0; i < _roopNum; i++) {
      var exData = (list[i]).split(':');
      var exData2 = (list[i + _roopNum]).split(':');

      var name1 = null;
      var money1 = null;
      var name2 = null;
      var money2 = null;

      switch (type) {
        case "currency":
          name1 = Text(exData[0]);
          money1 = Text(exData[1]);
          name2 = Text(exData2[0]);
          money2 = Text(exData2[1]);
          break;
        case "deposit":
          if (int.parse(exData[1]) > 0) {
            name1 = Text('${_bankNames[exData[0]]}');
            money1 = Text(_utility.makeCurrencyDisplay(exData[1]));
          } else {
            name1 = Text(exData[0], style: const TextStyle(color: Colors.grey));
            money1 = Text(_utility.makeCurrencyDisplay(exData[1]),
                style: const TextStyle(color: Colors.grey));
          }
          if (int.parse(exData2[1]) > 0) {
            name2 = Text('${_bankNames[exData2[0]]}');
            money2 = Text(_utility.makeCurrencyDisplay(exData2[1]));
          } else {
            name2 =
                Text(exData2[0], style: const TextStyle(color: Colors.grey));
            money2 = Text(_utility.makeCurrencyDisplay(exData2[1]),
                style: const TextStyle(color: Colors.grey));
          }
          break;
        case "e-money":
          if (int.parse(exData[1]) > 0) {
            name1 = Text('${_bankNames[exData[0]]}');
            money1 = Text(_utility.makeCurrencyDisplay(exData[1]));
          } else {
            name1 = Text(exData[0], style: const TextStyle(color: Colors.grey));
            money1 = Text(_utility.makeCurrencyDisplay(exData[1]),
                style: const TextStyle(color: Colors.grey));
          }
          if (int.parse(exData2[1]) > 0) {
            name2 = Text('${_bankNames[exData2[0]]}');
            money2 = Text(_utility.makeCurrencyDisplay(exData2[1]));
          } else {
            name2 =
                Text(exData2[0], style: const TextStyle(color: Colors.grey));
            money2 = Text(_utility.makeCurrencyDisplay(exData2[1]),
                style: const TextStyle(color: Colors.grey));
          }
          break;
      }

      _list.add(Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  name1,
                  Container(
                    alignment: Alignment.topRight,
                    child: money1,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  name2,
                  Container(
                    alignment: Alignment.topRight,
                    child: money2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
    }

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: _list,
        ),
      ),
    );
  }

  ///
  Widget ___dispDepositData() {
    List<String> _list = [];
    _list.add('bank_a:$_bankA');
    _list.add('bank_b:$_bankB');
    _list.add('bank_c:$_bankC');
    _list.add('bank_d:$_bankD');
    _list.add('bank_e:$_bankE');
    _list.add('bank_f:$_bankF');
    _list.add('bank_g:$_bankG');
    _list.add('bank_h:$_bankH');

    return ____dispEachData('deposit', _list);
  }

  ///
  Widget ___dispEMoneyData() {
    List<String> _list = [];
    _list.add('pay_a:$_payA');
    _list.add('pay_b:$_payB');
    _list.add('pay_c:$_payC');
    _list.add('pay_d:$_payD');
    _list.add('pay_e:$_payE');
    _list.add('pay_f:$_payF');
    _list.add('pay_g:$_payG');
    _list.add('pay_h:$_payH');

    return ____dispEachData('e-money', _list);
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移
  /// 画面遷移（前日）
  void _goPrevDate({required BuildContext context}) {
    _utility.makeYMDYData(_prevDate.toString(), 0);

    _goDetailDisplayScreen(
      context: context,
      date: _prevDate.toString(),
      index: int.parse(_utility.day),
    );
  }

  /// 画面遷移（翌日）
  void _goNextDate({required BuildContext context}) {
    _utility.makeYMDYData(_nextDate.toString(), 0);

    _goDetailDisplayScreen(
      context: context,
      date: _nextDate.toString(),
      index: int.parse(_utility.day),
    );
  }

  /// 画面遷移（月内指定日）
  void _goMonthDay({required BuildContext context, required int position}) {
    _goDetailDisplayScreen(
        context: context,
        date:
            '$_displayYear-$_displayMonth-${_monthDays[position][0].toString().padLeft(2, '0')}',
        index: position);
  }

  /// 画面遷移（DetailDisplayScreen）
  void _goDetailDisplayScreen(
      {required BuildContext context,
      required String date,
      required int index}) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: index,
          detailDisplayArgs: detailDisplayArgs,
        ),
      ),
    );
  }
}
