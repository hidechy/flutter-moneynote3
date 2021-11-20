// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import '../models/AmazonPurchaseRecord.dart';

class AmazonPurchaseListScreen extends StatefulWidget {
  String date;

  AmazonPurchaseListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _AmazonPurchaseListScreenState createState() =>
      _AmazonPurchaseListScreenState();
}

class _AmazonPurchaseListScreenState extends State<AmazonPurchaseListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<AmazonPurchase> _amazonPurchaseData = [];

  int _total = 0;

  int _prevYear = 0;
  int _nextYear = 0;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(widget.date, 0);
    _prevYear = int.parse(_utility.year) - 1;
    _nextYear = int.parse(_utility.year) + 1;

    await apiData.getAmazonPurchaseOfDate(date: widget.date);
    if (apiData.AmazonPurchaseOfDate != null) {
      for (var i = 0; i < apiData.AmazonPurchaseOfDate.length; i++) {
        _amazonPurchaseData.add(apiData.AmazonPurchaseOfDate[i]);
        _total += int.parse(apiData.AmazonPurchaseOfDate[i].price);
      }
    }
    apiData.AmazonPurchaseOfDate = [];

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('Amazon(${_utility.year})'),
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
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Table(
                  children: [
                    TableRow(children: [
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            tooltip: '前年',
                            onPressed: () => _goPrevYear(context: context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            tooltip: '翌年',
                            onPressed: () => _goNextYear(context: context),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10, right: 20),
                        alignment: Alignment.topRight,
                        child: Text(
                            _utility.makeCurrencyDisplay(_total.toString())),
                      ),
                    ]),
                  ],
                ),
              ),
              Expanded(
                child: _amazonPurchaseList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// リスト表示
  Widget _amazonPurchaseList() {
    return ListView.builder(
      itemCount: _amazonPurchaseData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    var exDate = (_amazonPurchaseData[position].date.toString()).split('-');

    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: _getLeadingBgColor(month: exDate[1]),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(exDate[0]),
              Text(exDate[1]),
            ],
          ),
        ),
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_amazonPurchaseData[position].date}'),
              Text(_amazonPurchaseData[position].item),
              Container(
                alignment: Alignment.topRight,
                child: Text(_utility
                    .makeCurrencyDisplay(_amazonPurchaseData[position].price)),
              ),
              Container(
                alignment: Alignment.topRight,
                child: Text(
                  _amazonPurchaseData[position].orderNumber,
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Color _getLeadingBgColor({required String month}) {
    switch (int.parse(month) % 6) {
      case 0:
        return Colors.orangeAccent.withOpacity(0.3);
      case 1:
        return Colors.blueAccent.withOpacity(0.3);
      case 2:
        return Colors.redAccent.withOpacity(0.3);
      case 3:
        return Colors.purpleAccent.withOpacity(0.3);
      case 4:
        return Colors.greenAccent.withOpacity(0.3);
      case 5:
        return Colors.yellowAccent.withOpacity(0.3);
      default:
        return Colors.black;
    }
  }

  //////////////////////////////////////////////////////

  /// 画面遷移（前年）
  void _goPrevYear({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AmazonPurchaseListScreen(date: '$_prevYear-01-01'),
      ),
    );
  }

  /// 画面遷移（翌年）
  void _goNextYear({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AmazonPurchaseListScreen(date: '$_nextYear-01-01'),
      ),
    );
  }
}
