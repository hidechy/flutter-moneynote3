// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class CreditMonthlyListScreen extends StatefulWidget {
  String date;

  CreditMonthlyListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _CreditMonthlyListScreenState createState() =>
      _CreditMonthlyListScreenState();
}

class _CreditMonthlyListScreenState extends State<CreditMonthlyListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _monthlyCreditData = [];

  bool _loading = false;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    var _ym = _getYm();

    for (var i = 0; i < _ym.length; i++) {
      int _monthTotal = 0;
      int _creditUc = 0;
      int _creditRakuten = 0;
      int _creditSumitomo = 0;

      ///////////////////////
      var _date = '${_ym[i]}-01';
      await apiData.getUcCardSpendOfDate(date: _date);
      if (apiData.UcCardSpendOfDate != null) {
        for (var i = 0; i < apiData.UcCardSpendOfDate['data'].length; i++) {
          _monthTotal +=
              int.parse(apiData.UcCardSpendOfDate['data'][i]['price']);

          if (apiData.UcCardSpendOfDate['data'][i]['kind'] == "uc") {
            _creditUc +=
                int.parse(apiData.UcCardSpendOfDate['data'][i]['price']);
          }

          if (apiData.UcCardSpendOfDate['data'][i]['kind'] == "rakuten") {
            _creditRakuten +=
                int.parse(apiData.UcCardSpendOfDate['data'][i]['price']);
          }

          if (apiData.UcCardSpendOfDate['data'][i]['kind'] == "sumitomo") {
            _creditSumitomo +=
                int.parse(apiData.UcCardSpendOfDate['data'][i]['price']);
          }
        }
      }
      apiData.UcCardSpendOfDate = {};
      ///////////////////////
      Map _map = {};
      _map['date'] = _ym[i];
      _map['monthTotal'] = _monthTotal;
      _map['creditUc'] = _creditUc;
      _map['creditRakuten'] = _creditRakuten;
      _map['creditSumitomo'] = _creditSumitomo;

      _monthlyCreditData.add(_map);
    }

    setState(() {
      _loading = true;
    });
  }

  ///
  List _getYm() {
    List _ym = [];

    final start = DateTime(2020, 1, 1);
    final today = DateTime.now();

    int diffDays = today.difference(start).inDays;

    _utility.makeYMDYData(start.toString(), 0);
    var baseYear = _utility.year;
    var baseMonth = _utility.month;
    var baseDay = _utility.day;

    for (int i = 0; i <= diffDays; i++) {
      var genDate = DateTime(
        int.parse(baseYear),
        int.parse(baseMonth),
        (int.parse(baseDay) + i),
      );
      _utility.makeYMDYData(genDate.toString(), 0);

      if (!_ym.contains(_utility.year + "-" + _utility.month)) {
        _ym.add(_utility.year + "-" + _utility.month);
      }
    }

    return _ym;
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Monthly Credit'),
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
              margin: const EdgeInsets.only(
                top: 5,
                left: 6,
              ),
              color: Colors.yellowAccent.withOpacity(0.2),
              child: Text(
                '■',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
          (_loading == false)
              ? Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : _monthlyCreditList(),
        ],
      ),
    );
  }

  ///
  Widget _monthlyCreditList() {
    return ListView.builder(
      itemCount: _monthlyCreditData.length,
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
//        trailing: _getCreditTrailing(kind: _ucCardSpendData[position]['kind']),
//        onTap: () => _addSelectedAry(position: position),
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${_monthlyCreditData[position]['date']}'),
                  Text(
                    _utility.makeCurrencyDisplay(
                      _monthlyCreditData[position]['monthTotal'].toString(),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 60,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Text(
                                'UC　${_utility.makeCurrencyDisplay(_monthlyCreditData[position]['creditUc'].toString())}'),
                            Text(
                                '楽天　${_utility.makeCurrencyDisplay(_monthlyCreditData[position]['creditRakuten'].toString())}'),
                            Text(
                                '住友　${_utility.makeCurrencyDisplay(_monthlyCreditData[position]['creditSumitomo'].toString())}'),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
