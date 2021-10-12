// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'AllCreditListScreen.dart';
import 'CreditMonthlyListScreen.dart';
import 'AllCreditItemListScreen.dart';
import 'AmazonPurchaseListScreen.dart';
import 'SeiyuuPurchaseListScreen.dart';

class CreditSpendDisplayScreen extends StatefulWidget {
  String date;

  CreditSpendDisplayScreen({Key? key, required this.date}) : super(key: key);

  @override
  _CreditSpendDisplayScreenState createState() =>
      _CreditSpendDisplayScreenState();
}

class _CreditSpendDisplayScreenState extends State<CreditSpendDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _ucCardSpendData = [];

  int _total = 0;

  List<int> _selectedList = [];
  int _selectedTotal = 0;
  int _selectedDiff = 0;

  DateTime _prevDate = DateTime.now();
  DateTime _nextDate = DateTime.now();

  int _sumprice = 0;

  bool _loading = false;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(widget.date, 0);

    _prevDate =
        DateTime(int.parse(_utility.year), int.parse(_utility.month) - 1, 1);
    _nextDate =
        DateTime(int.parse(_utility.year), int.parse(_utility.month) + 1, 1);

    //--------------------------------//
    var date2 = '${_utility.year}-${_utility.month}-${_utility.day}';
    await apiData.getMonthSummaryOfDate(date: date2);
    if (apiData.MonthSummaryOfDate != null) {
      for (var i = 0; i < apiData.MonthSummaryOfDate['data'].length; i++) {
        if (apiData.MonthSummaryOfDate['data'][i]['item'] == 'credit') {
          _sumprice = apiData.MonthSummaryOfDate['data'][i]['sum'];
        }
      }
    }
    apiData.MonthSummaryOfDate = {};
    //--------------------------------//

    ///////////////////////
    await apiData.getUcCardSpendOfDate(date: widget.date);
    if (apiData.UcCardSpendOfDate != null) {
      _total = 0;
      for (var i = 0; i < apiData.UcCardSpendOfDate['data'].length; i++) {
        _ucCardSpendData.add(apiData.UcCardSpendOfDate['data'][i]);
        _total += int.parse(apiData.UcCardSpendOfDate['data'][i]['price']);
      }
    }
    apiData.UcCardSpendOfDate = {};
    ///////////////////////

    _selectedDiff = _total;

    setState(() {
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Credit Card [${_utility.year}-${_utility.month}]'),
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
          (_loading == false)
              ? Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : _spendDisplayBox(),
        ],
      ),
    );
  }

  ///
  Widget _spendDisplayBox() {
    int _diff = (_sumprice - _total) * -1;

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.yellowAccent.withOpacity(0.3),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('今月の支払い'),
                    Text(_utility.makeCurrencyDisplay(_total.toString())),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('支払い済み'),
                            Text(_utility
                                .makeCurrencyDisplay(_sumprice.toString())),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('残金'),
                            Text(
                                _utility.makeCurrencyDisplay(_diff.toString())),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.3),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('selected'),
                      Text(_utility
                          .makeCurrencyDisplay(_selectedTotal.toString())),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
              Expanded(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('rest'),
                      Text(_utility
                          .makeCurrencyDisplay(_selectedDiff.toString())),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  tooltip: '前月',
                  onPressed: () => _goPrevMonth(context: context),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  tooltip: '翌月',
                  onPressed: () => _goNextMonth(context: context),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.all_inbox_rounded),
                  color: Colors.yellowAccent,
                  onPressed: () => _goAllCreditListScreen(),
                ),
                IconButton(
                  icon: const Icon(Icons.integration_instructions_sharp),
                  color: Colors.yellowAccent,
                  onPressed: () => _goAllCreditItemListScreen(),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_view_month_rounded),
                  color: Colors.yellowAccent,
                  onPressed: () => _goMonthlyCreditListScreen(),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.amazon),
                  color: Colors.greenAccent,
                  onPressed: () => _goAmazonPurchaseListScreen(),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.bullseye),
                  color: Colors.greenAccent,
                  onPressed: () => _goSeiyuuPurchaseListScreen(),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: _ucCardSpendList(),
        ),
      ],
    );
  }

  ///
  Widget _ucCardSpendList() {
    return ListView.builder(
      itemCount: _ucCardSpendData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  ///
  Widget _listItem({required int position}) {
    return Card(
      color: _getSelectedBgColor(position: position),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        trailing: _getCreditTrailing(kind: _ucCardSpendData[position]['kind']),
        onTap: () => _addSelectedAry(position: position),
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_ucCardSpendData[position]['date']}'),
              Text('${_ucCardSpendData[position]['item']}'),
              Container(
                width: double.infinity,
                alignment: Alignment.topRight,
                child: Text(_utility
                    .makeCurrencyDisplay(_ucCardSpendData[position]['price'])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void _addSelectedAry({position}) {
    if (_selectedList.contains(position)) {
      _selectedList.remove(position);
      _selectedTotal -= int.parse(_ucCardSpendData[position]['price']);
    } else {
      _selectedList.add(position);
      _selectedTotal += int.parse(_ucCardSpendData[position]['price']);
    }

    _selectedDiff = (_total - _selectedTotal);

    setState(() {});
  }

  ///
  Color _getSelectedBgColor({position}) {
    if (_selectedList.contains(position)) {
      return Colors.greenAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.3);
    }
  }

  ///
  Widget _getCreditTrailing({kind}) {
    switch (kind) {
      case 'uc':
        return Icon(
          Icons.grade,
          color: Colors.purpleAccent.withOpacity(0.3),
        );
      case 'rakuten':
        return Icon(
          Icons.grade,
          color: Colors.deepOrangeAccent.withOpacity(0.3),
        );
      case 'sumitomo':
        return Icon(
          Icons.grade,
          color: Colors.greenAccent.withOpacity(0.3),
        );
      default:
        return Container();
    }
  }

  /////////////////////////////////////////////////////////

  ///
  void _goAllCreditListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllCreditListScreen(
          date: widget.date,
        ),
      ),
    );
  }

  ///
  void _goMonthlyCreditListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreditMonthlyListScreen(
          date: widget.date,
        ),
      ),
    );
  }

  /// 画面遷移（前月）
  void _goPrevMonth({required BuildContext context}) {
    _utility.makeYMDYData(_prevDate.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreditSpendDisplayScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }

  /// 画面遷移（翌月）
  void _goNextMonth({required BuildContext context}) {
    _utility.makeYMDYData(_nextDate.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreditSpendDisplayScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }

  ///
  void _goAllCreditItemListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllCreditItemListScreen(date: widget.date),
      ),
    );
  }

  ///
  void _goAmazonPurchaseListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmazonPurchaseListScreen(date: widget.date),
      ),
    );
  }

  ///
  void _goSeiyuuPurchaseListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeiyuuPurchaseListScreen(date: widget.date),
      ),
    );
  }
}
