// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, must_be_immutable, prefer_final_fields, unused_field, unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'DetailDisplayScreen.dart';
import 'MonthlyListScreen.dart';

class OnedayInputScreen extends StatefulWidget {
  String date;

  OnedayInputScreen({Key? key, required this.date}) : super(key: key);

  @override
  _OnedayInputScreenState createState() => _OnedayInputScreenState();
}

class _OnedayInputScreenState extends State<OnedayInputScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  String _year = '';
  String _month = '';
  String _day = '';

  String _date = '';

  DateTime _prevDate = DateTime.now();

  String _text = "";

  TextEditingController _teCont10000 = TextEditingController(text: '0');
  TextEditingController _teCont5000 = TextEditingController(text: '0');
  TextEditingController _teCont2000 = TextEditingController(text: '0');
  TextEditingController _teCont1000 = TextEditingController(text: '0');
  TextEditingController _teCont500 = TextEditingController(text: '0');
  TextEditingController _teCont100 = TextEditingController(text: '0');
  TextEditingController _teCont50 = TextEditingController(text: '0');
  TextEditingController _teCont10 = TextEditingController(text: '0');
  TextEditingController _teCont5 = TextEditingController(text: '0');
  TextEditingController _teCont1 = TextEditingController(text: '0');

  TextEditingController _teContBankA = TextEditingController(text: '0');
  TextEditingController _teContBankB = TextEditingController(text: '0');
  TextEditingController _teContBankC = TextEditingController(text: '0');
  TextEditingController _teContBankD = TextEditingController(text: '0');
  TextEditingController _teContBankE = TextEditingController(text: '0');
  TextEditingController _teContBankF = TextEditingController(text: '0');
  TextEditingController _teContBankG = TextEditingController(text: '0');
  TextEditingController _teContBankH = TextEditingController(text: '0');

  TextEditingController _teContPayA = TextEditingController(text: '0');
  TextEditingController _teContPayB = TextEditingController(text: '0');
  TextEditingController _teContPayC = TextEditingController(text: '0');
  TextEditingController _teContPayD = TextEditingController(text: '0');
  TextEditingController _teContPayE = TextEditingController(text: '0');
  TextEditingController _teContPayF = TextEditingController(text: '0');
  TextEditingController _teContPayG = TextEditingController(text: '0');
  TextEditingController _teContPayH = TextEditingController(text: '0');

  int _onedayTotal = 0;
  int _onedaySpend = 0;

  Map<dynamic, dynamic> _bankNames = {};

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
    _day = _utility.day;
    _date = '$_year-$_month-$_day';

    _prevDate =
        DateTime(int.parse(_year), int.parse(_month), int.parse(_day) - 1);

    ////////////////////////////////////////////////////
    await apiData.getMoneyOfDate(date: _date);
    if (apiData.MoneyOfDate != null) {
      if (apiData.MoneyOfDate['data'] != "-") {
        var exData = (apiData.MoneyOfDate['data']).split('|');

        _teCont10000 = TextEditingController(text: exData[0]);
        _teCont5000 = TextEditingController(text: exData[1]);
        _teCont2000 = TextEditingController(text: exData[2]);
        _teCont1000 = TextEditingController(text: exData[3]);
        _teCont500 = TextEditingController(text: exData[4]);
        _teCont100 = TextEditingController(text: exData[5]);
        _teCont50 = TextEditingController(text: exData[6]);
        _teCont10 = TextEditingController(text: exData[7]);
        _teCont5 = TextEditingController(text: exData[8]);
        _teCont1 = TextEditingController(text: exData[9]);

        _teContBankA = TextEditingController(text: exData[10]);
        _teContBankB = TextEditingController(text: exData[11]);
        _teContBankC = TextEditingController(text: exData[12]);
        _teContBankD = TextEditingController(text: exData[13]);
        _teContBankE = TextEditingController(text: exData[14]);

        _teContPayA = TextEditingController(text: exData[15]);
        _teContPayB = TextEditingController(text: exData[16]);
        _teContPayC = TextEditingController(text: exData[17]);
        _teContPayD = TextEditingController(text: exData[18]);
        _teContPayE = TextEditingController(text: exData[19]);
      }
    }

    apiData.MoneyOfDate = {};
    ////////////////////////////////////////////////////

    _bankNames = _utility.getBankName();

    setState(() {});
  }

  /// 画面描画
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      //
      //
      //
      //
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: Text('${_date}(${_youbiStr})'),
      //   centerTitle: true,
      //
      //   //-------------------------//これを消すと「←」が出てくる（消さない）
      //   leading: IconButton(
      //     icon: Icon(Icons.close),
      //     onPressed: () => Navigator.pop(context),
      //     color: Colors.greenAccent,
      //   ),
      //
      //   //-------------------------//これを消すと「←」が出てくる（消さない）
      //
      //   actions: <Widget>[
      //     IconButton(
      //       icon: const Icon(Icons.skip_previous),
      //       tooltip: '前日',
      //       onPressed: () => _goPrevDate(context: context),
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.skip_next),
      //       tooltip: '翌日',
      //       onPressed: () => _goNextDate(context: context),
      //     ),
      //   ],
      // ),
      //
      //
      //
      //
      //
      //
      //

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
          SingleChildScrollView(
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
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            _getTextField(yen: '10000', con: _teCont10000),
                            _getTextField(yen: '5000', con: _teCont5000),
                            _getTextField(yen: '2000', con: _teCont2000),
                            _getTextField(yen: '1000', con: _teCont1000),
                          ]),
                          TableRow(children: [
                            _getTextField(yen: '500', con: _teCont500),
                            _getTextField(yen: '100', con: _teCont100),
                            _getTextField(yen: '50', con: _teCont50),
                            const Align(),
                          ]),
                          TableRow(children: [
                            _getTextField(yen: '10', con: _teCont10),
                            _getTextField(yen: '5', con: _teCont5),
                            _getTextField(yen: '1', con: _teCont1),
                            const Align(),
                          ]),
                        ],
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            _getTextField(yen: 'bank_a', con: _teContBankA),
                            _getTextField(yen: 'bank_b', con: _teContBankB),
                            _getTextField(yen: 'bank_c', con: _teContBankC),
                            _getTextField(yen: 'bank_d', con: _teContBankD),
                          ]),
                          TableRow(children: [
                            _getTextField(yen: 'bank_e', con: _teContBankE),
                            _getTextField(yen: 'bank_f', con: _teContBankF),
                            _getTextField(yen: 'bank_g', con: _teContBankG),
                            _getTextField(yen: 'bank_h', con: _teContBankH),
                          ]),
                        ],
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Table(
                        children: [
                          TableRow(children: [
                            _getTextField(yen: 'pay_a', con: _teContPayA),
                            _getTextField(yen: 'pay_b', con: _teContPayB),
                            _getTextField(yen: 'pay_c', con: _teContPayC),
                            _getTextField(yen: 'pay_d', con: _teContPayD),
                          ]),
                          TableRow(children: [
                            _getTextField(yen: 'pay_e', con: _teContPayE),
                            _getTextField(yen: 'pay_f', con: _teContPayF),
                            _getTextField(yen: 'pay_g', con: _teContPayG),
                            _getTextField(yen: 'pay_h', con: _teContPayH),
                          ]),
                        ],
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.content_copy),
                            tooltip: 'copy',
                            onPressed: () => _dataCopy(),
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.list),
                            tooltip: 'list',
                            onPressed: () => _goMonthlyListScreen(
                                context: context, date: _date),
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.details),
                            tooltip: 'detail',
                            onPressed: () => _goDetailDisplayScreen(
                                context: context, date: _date),
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            tooltip: 'jump',
                            onPressed: () => _showDatepicker(context: context),
                            color: Colors.blueAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_box),
                            tooltip: 'total',
                            onPressed: () => _displayTotal(),
                            color: Colors.greenAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.input),
                            tooltip: 'input',
                            onPressed: () => _insertRecord(context: context),
                            color: Colors.greenAccent,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.indigo,
                        height: 20.0,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 11,
                        ),
                        child: Table(
                          children: [
                            TableRow(children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('onedayTotal'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    _utility.makeCurrencyDisplay(
                                        _onedayTotal.toString()),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('onedaySpend'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    _utility.makeCurrencyDisplay(
                                        _onedaySpend.toString()),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height / 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// テキストフィールド部分表示
  Widget _getTextField(
      {required String yen, required TextEditingController con}) {
    var dispYen = yen;
    if (_bankNames[yen] != "" && _bankNames[yen] != null) {
      dispYen = _bankNames[yen];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: con,
        textAlign: TextAlign.end,
        decoration: InputDecoration(
          labelText: dispYen,
        ),
        style: const TextStyle(
          fontSize: 13.0,
        ),
        onChanged: (value) {
          setState(
            () {
              _text = value;
            },
          );
        },
      ),
    );
  }

  /// 前日データのコピー
  void _dataCopy() async {
    _utility.makeYMDYData(_prevDate.toString(), 0);
    var _zenjitsu = "${_utility.year}-${_utility.month}-${_utility.day}";

    ////////////////////////////////////////////////////
    await apiData.getMoneyOfDate(date: _zenjitsu);
    if (apiData.MoneyOfDate != null) {
      if (apiData.MoneyOfDate['data'] != "-") {
        var exData = (apiData.MoneyOfDate['data']).split('|');

        _teCont10000 = TextEditingController(text: exData[0]);
        _teCont5000 = TextEditingController(text: exData[1]);
        _teCont2000 = TextEditingController(text: exData[2]);
        _teCont1000 = TextEditingController(text: exData[3]);
        _teCont500 = TextEditingController(text: exData[4]);
        _teCont100 = TextEditingController(text: exData[5]);
        _teCont50 = TextEditingController(text: exData[6]);
        _teCont10 = TextEditingController(text: exData[7]);
        _teCont5 = TextEditingController(text: exData[8]);
        _teCont1 = TextEditingController(text: exData[9]);

        _teContBankA = TextEditingController(text: exData[10]);
        _teContBankB = TextEditingController(text: exData[11]);
        _teContBankC = TextEditingController(text: exData[12]);
        _teContBankD = TextEditingController(text: exData[13]);
        _teContBankE = TextEditingController(text: exData[14]);

        _teContPayA = TextEditingController(text: exData[15]);
        _teContPayB = TextEditingController(text: exData[16]);
        _teContPayC = TextEditingController(text: exData[17]);
        _teContPayD = TextEditingController(text: exData[18]);
        _teContPayE = TextEditingController(text: exData[19]);
      }
    }
    apiData.MoneyOfDate = {};

    ////////////////////////////////////////////////////

    setState(() {});
  }

  /// デートピッカー表示
  void _showDatepicker({required BuildContext context}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 6),
      locale: const Locale('ja'),
      builder: (BuildContext? context, Widget? child) {
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
      _goAnotherDate(context: context, date: selectedDate.toString());
    }
  }

  /// データ作成/更新
  void _insertRecord({required BuildContext context}) async {
    Map<String, dynamic> _uploadData = {};

    _uploadData['date'] = _date;

    _uploadData['yen_10000'] =
        _teCont10000.text != "" ? _teCont10000.text : '0';
    _uploadData['yen_5000'] = _teCont5000.text != "" ? _teCont5000.text : '0';
    _uploadData['yen_2000'] = _teCont2000.text != "" ? _teCont2000.text : '0';
    _uploadData['yen_1000'] = _teCont1000.text != "" ? _teCont1000.text : '0';
    _uploadData['yen_500'] = _teCont500.text != "" ? _teCont500.text : '0';
    _uploadData['yen_100'] = _teCont100.text != "" ? _teCont100.text : '0';
    _uploadData['yen_50'] = _teCont50.text != "" ? _teCont50.text : '0';
    _uploadData['yen_10'] = _teCont10.text != "" ? _teCont10.text : '0';
    _uploadData['yen_5'] = _teCont5.text != "" ? _teCont5.text : '0';
    _uploadData['yen_1'] = _teCont1.text != "" ? _teCont1.text : '0';
    //
    _uploadData['bank_a'] = _teContBankA.text != "" ? _teContBankA.text : '0';
    _uploadData['bank_b'] = _teContBankB.text != "" ? _teContBankB.text : '0';
    _uploadData['bank_c'] = _teContBankC.text != "" ? _teContBankC.text : '0';
    _uploadData['bank_d'] = _teContBankD.text != "" ? _teContBankD.text : '0';
    _uploadData['bank_e'] = _teContBankE.text != "" ? _teContBankE.text : '0';
    //
    _uploadData['pay_a'] = _teContPayA.text != "" ? _teContPayA.text : '0';
    _uploadData['pay_b'] = _teContPayB.text != "" ? _teContPayB.text : '0';
    _uploadData['pay_c'] = _teContPayC.text != "" ? _teContPayC.text : '0';
    _uploadData['pay_d'] = _teContPayD.text != "" ? _teContPayD.text : '0';
    _uploadData['pay_e'] = _teContPayE.text != "" ? _teContPayE.text : '0';

    //TODO
    String url = "http://toyohide.work/BrainLog/api/moneyinsert";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode(_uploadData);
    await post(Uri.parse(url), headers: headers, body: body);

    Fluttertoast.showToast(
      msg: "登録が完了しました",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    _makeDefaultDisplayData();
  }

  /// 合計金額表示
  void _displayTotal() async {
    //-------------------------------//現在の合計値
    _onedayTotal = 0;

    List<List<String>> _totalValue = [];
    _totalValue.add(['10000', _teCont10000.text]);
    _totalValue.add(['5000', _teCont5000.text]);
    _totalValue.add(['2000', _teCont2000.text]);
    _totalValue.add(['1000', _teCont1000.text]);
    _totalValue.add(['500', _teCont500.text]);
    _totalValue.add(['100', _teCont100.text]);
    _totalValue.add(['50', _teCont50.text]);
    _totalValue.add(['10', _teCont10.text]);
    _totalValue.add(['5', _teCont5.text]);
    _totalValue.add(['1', _teCont1.text]);

    _totalValue.add(['1', _teContBankA.text]);
    _totalValue.add(['1', _teContBankB.text]);
    _totalValue.add(['1', _teContBankC.text]);
    _totalValue.add(['1', _teContBankD.text]);
    _totalValue.add(['1', _teContBankE.text]);
    _totalValue.add(['1', _teContBankF.text]);
    _totalValue.add(['1', _teContBankG.text]);
    _totalValue.add(['1', _teContBankH.text]);

    _totalValue.add(['1', _teContPayA.text]);
    _totalValue.add(['1', _teContPayB.text]);
    _totalValue.add(['1', _teContPayC.text]);
    _totalValue.add(['1', _teContPayD.text]);
    _totalValue.add(['1', _teContPayE.text]);
    _totalValue.add(['1', _teContPayF.text]);
    _totalValue.add(['1', _teContPayG.text]);
    _totalValue.add(['1', _teContPayH.text]);

    for (int i = 0; i < _totalValue.length; i++) {
      _onedayTotal +=
          (int.parse(_totalValue[i][0]) * int.parse(_totalValue[i][1]));
    }
    //-------------------------------//現在の合計値

    //-------------------------------//前日の合計値
    _utility.makeYMDYData(_prevDate.toString(), 0);
    var _zenjitsu = "${_utility.year}-${_utility.month}-${_utility.day}";

    await apiData.getMoneyOfDate(date: _zenjitsu);
    if (apiData.MoneyOfDate != null) {
      if (apiData.MoneyOfDate['data'] != "-") {
        _utility.makeTotal(apiData.MoneyOfDate['data']);
        var _prevDayTotal = _utility.total;
        _onedaySpend = (_prevDayTotal - _onedayTotal);
      }
    }

    apiData.MoneyOfDate = {};
    //-------------------------------//前日の合計値

    setState(() {});
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /// 画面遷移（指定日）
  void _goAnotherDate({required BuildContext context, required String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: date,
        ),
      ),
    );
  }

  /// 画面遷移（MonthlyListScreen）
  void _goMonthlyListScreen(
      {required BuildContext context, required String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: date,
        ),
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
}
