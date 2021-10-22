// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison, non_constant_identifier_names, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';
import 'SeiyuuItemListScreen.dart';

class SeiyuuPurchaseListScreen extends StatefulWidget {
  String date;

  SeiyuuPurchaseListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _SeiyuuPurchaseListScreenState createState() =>
      _SeiyuuPurchaseListScreenState();
}

class Seiyuu {
  bool isExpanded;
  String date;
  int pos;
  int price;
  List data;

  Seiyuu(
      {required this.isExpanded,
      required this.date,
      required this.pos,
      required this.price,
      required this.data});
}

class _SeiyuuPurchaseListScreenState extends State<SeiyuuPurchaseListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  int _prevYear = 0;
  int _nextYear = 0;

  var _seiyuuList = <Seiyuu>[];

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

    await apiData.getSeiyuuPurchaseOfDate(date: widget.date);
    if (apiData.SeiyuuPurchaseOfDate != null) {
      var _date = '';
      var _inputedDate = '';
      for (var i = 0; i < apiData.SeiyuuPurchaseOfDate['data'].length; i++) {
        if (apiData.SeiyuuPurchaseOfDate['data'][i]['date'] != _date) {
          if (_inputedDate == apiData.SeiyuuPurchaseOfDate['data'][i]['date']) {
            continue;
          }

          var _summaryMap = _getSummaryMap(
              apiData.SeiyuuPurchaseOfDate['data'][i]['date'],
              apiData.SeiyuuPurchaseOfDate['data']);

          var record = _getSeiyuuRecord(
              apiData.SeiyuuPurchaseOfDate['data'][i]['date'],
              apiData.SeiyuuPurchaseOfDate['data']);

          _seiyuuList.add(
            Seiyuu(
                isExpanded: false,
                date: _summaryMap['date'],
                pos: _summaryMap['pos'],
                price: int.parse(_summaryMap['price']),
                data: record),
          );

          _inputedDate = _summaryMap['date'];
        }
      }
    }
    apiData.SeiyuuPurchaseOfDate = {};

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Seiyuu Purchase'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.format_list_bulleted),
//          onPressed: () => _goSeiyuuItemListScreen(),
          onPressed: () {
            Get.to(() => SeiyuuItemListScreen(date: widget.date));
          },
          color: Colors.greenAccent,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goSeiyuuPurchaseListScreen(),
            color: Colors.greenAccent,
          ),
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
          ListView(
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.black.withOpacity(0.1),
                ),
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    _seiyuuList[index].isExpanded =
                        !_seiyuuList[index].isExpanded;
                    setState(() {});
                  },
                  children: _seiyuuList.map(_createPanel).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  ExpansionPanel _createPanel(Seiyuu __SEIYUU) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(
          color: Colors.black.withOpacity(0.3),
          padding: const EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  __SEIYUU.date,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  _utility.makeCurrencyDisplay(__SEIYUU.price.toString()),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
      //
      body: Container(
        width: double.infinity,
        color: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.all(10),
        child: _getSeiyuuDataColumn(data: __SEIYUU.data),
      ),
      //
      isExpanded: __SEIYUU.isExpanded,
    );
  }

  ///
  Widget _getSeiyuuDataColumn({data}) {
    List<Widget> _list = [];
    for (var i = 0; i < data.length; i++) {
      _list.add(Container(
        margin: const EdgeInsets.only(right: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: Text('${data[i]['item']}')),
            Container(
              width: 60,
              alignment: Alignment.topRight,
              child: Text(_utility.makeCurrencyDisplay(data[i]['tanka'])),
            ),
            Container(
              width: 40,
              alignment: Alignment.topRight,
              child: Text('${data[i]['kosuu']}'),
            ),
            Container(
              width: 60,
              alignment: Alignment.topRight,
              child: Text(_utility.makeCurrencyDisplay(data[i]['price'])),
            ),
          ],
        ),
      ));
    }

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _list,
      ),
    );
  }

  ///
  Map _getSummaryMap(String date, List data) {
    var _pos = 0;
    var _addTotal = 0;
    for (var i = 0; i < data.length; i++) {
      if (data[i]['date'] == date) {
        _pos = data[i]['pos'];
        _addTotal += int.parse(data[i]['price']);
      }
    }

    Map _map = {};
    _map['date'] = date;
    _map['pos'] = _pos;
    _map['price'] = _addTotal.toString();

    return _map;
  }

  ///
  List _getSeiyuuRecord(String date, List data) {
    List _list = [];

    for (var i = 0; i < data.length; i++) {
      if (data[i]['date'] == date) {
        _list.add(data[i]);
      }
    }

    return _list;
  }

  /////////////////////////////////////////
  /// 画面遷移（前年）
  void _goPrevYear({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SeiyuuPurchaseListScreen(date: '$_prevYear-01-01'),
      ),
    );
  }

  /// 画面遷移（翌年）
  void _goNextYear({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SeiyuuPurchaseListScreen(date: '$_nextYear-01-01'),
      ),
    );
  }

  ///
  void _goSeiyuuPurchaseListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SeiyuuPurchaseListScreen(
          date: widget.date,
        ),
      ),
    );
  }

  ///
// _goSeiyuuItemListScreen() {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => SeiyuuItemListScreen(
//         date: widget.date,
//       ),
//     ),
//   );
// }
}
