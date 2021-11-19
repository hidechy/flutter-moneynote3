// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison, avoid_init_to_null

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class MonthlySpendItemScreen extends StatefulWidget {
  String date;
  List monthlyData;
  String yearmonth;

  MonthlySpendItemScreen(
      {Key? key,
        required this.date,
        required this.monthlyData,
        required this.yearmonth})
      : super(key: key);

  @override
  _MonthlySpendItemScreenState createState() => _MonthlySpendItemScreenState();
}

class _MonthlySpendItemScreenState extends State<MonthlySpendItemScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _monthlySpendItemData = [];

  Map<String, dynamic> _holidayList = {};

  bool _loading = false;

  List<Map<dynamic, dynamic>> _monthlySummaryData = [];

  List<Map<dynamic, dynamic>> _creditDateData = [];
  Map<dynamic, List<Map<dynamic, dynamic>>> _creditDateDataMap = {};

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //-------------------------------------//
    await apiData.getListOfMonthlySpendItemDetailData(date: widget.date);
    if (apiData.ListOfMonthlySpendItemDetailData != null) {
      apiData.ListOfMonthlySpendItemDetailData['data'].forEach((key, value) {
        Map _map = {};
        _map['date'] = key;
        _map['data'] = value;
        _monthlySpendItemData.add(_map);
      });
    }
    apiData.ListOfMonthlySpendItemDetailData = {};
    //-------------------------------------//

    ///////////////////////////////////////////////////////
    List _creditDays = [];
    for (var i = 0; i < _monthlySpendItemData.length; i++) {
      for (var j = 0; j < _monthlySpendItemData[i]['data'].length; j++) {
        if (_monthlySpendItemData[i]['data'][j].startsWith('credit')) {
          _creditDays.add(_monthlySpendItemData[i]['date']);
          break;
        }
      }
    }

    for (var i = 0; i < _creditDays.length; i++) {
      await apiData.getListOfCreditDateData(date: _creditDays[i]);
      if (apiData.ListOfCreditDateData != null) {
        _creditDateData = [];
        for (var i = 0; i < apiData.ListOfCreditDateData['data'].length; i++) {
          Map _map = {};
          _map['card'] = apiData.ListOfCreditDateData['data'][i]['card'];
          _map['date'] = apiData.ListOfCreditDateData['data'][i]['date'];
          _map['item'] = apiData.ListOfCreditDateData['data'][i]['item'];
          _map['price'] = apiData.ListOfCreditDateData['data'][i]['price'];
          _creditDateData.add(_map);
        }
        _creditDateDataMap[_creditDays[i]] = _creditDateData;
      }

      apiData.ListOfCreditDateData = {};
    }
    ///////////////////////////////////////////////////////

    //----------------------------//
    await apiData.getHolidayOfAll();
    if (apiData.HolidayOfAll != null) {
      for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
        _holidayList[apiData.HolidayOfAll['data'][i]] = '';
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    //////////////////////////////////////////////
    var date = "${widget.yearmonth}-01";
    await apiData.getMonthSummaryOfDate(date: date);
    if (apiData.MonthSummaryOfDate != null) {
      for (var i = 0; i < apiData.MonthSummaryOfDate['data'].length; i++) {
        Map _map = {};
        _map['item'] = apiData.MonthSummaryOfDate['data'][i]['item'];
        _map['sum'] = apiData.MonthSummaryOfDate['data'][i]['sum'];
        _monthlySummaryData.add(_map);
      }
    }
    apiData.MonthSummaryOfDate = {};
    //////////////////////////////////////////////

    setState(() {
      _loading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.yearmonth),
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
              : Column(
            children: <Widget>[
              _monthlySummaryList(),
              Expanded(
                child: _monthlyItemSpendList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// リスト表示
  Widget _monthlyItemSpendList() {
    return ListView.builder(
      itemCount: widget.monthlyData.length,
      itemBuilder: (context, int position) {
        return _listItem(position: position);
      },
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    _utility.makeYMDYData(
        '${widget.yearmonth}-${widget.monthlyData[position]['date']}', 0);

    return Card(
      color: _utility.getBgColor(
          '${widget.yearmonth}-${widget.monthlyData[position]['date']}',
          _holidayList),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${widget.monthlyData[position]['date']} ${_utility.youbiStr}'),
                  Text('${widget.monthlyData[position]['diff']}'),
                ],
              ),
              _dispSpendItemData(day: widget.monthlyData[position]['date']),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _dispSpendItemData({day}) {
    List<Widget> _list = [];

    var data = _getSpendItemData(day: day);
    for (var i = 0; i < data.length; i++) {
      var exData = (data[i]).split('|');

      _list.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
              border: Border(
                bottom:
                BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
              ),
              color: _getRowLineBgColor(kind: exData[1])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text('${exData[0]}'),
              ),
              Row(
                children: <Widget>[
                  Text('${exData[2]}'),
                  const SizedBox(
                    width: 10,
                  ),
                  (exData[0] == "credit")
                      ? GestureDetector(
                    onTap: () =>
                        _showAlertWindow(day: day, price: exData[2]),
                    child: const Icon(
                      Icons.call_made,
                      color: Colors.greenAccent,
                    ),
                  )
                      : const Icon(
                    Icons.check_box_outline_blank,
                    color: Color(0xFF2e2e2e),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 120),
      child: Column(
        children: _list,
      ),
    );
  }

  ///
  List _getSpendItemData({day}) {
    List _list = [];
    for (var i = 0; i < _monthlySpendItemData.length; i++) {
      if (_monthlySpendItemData[i]['date'] == "${widget.yearmonth}-$day") {
        _list = _monthlySpendItemData[i]['data'];
        break;
      }
    }
    return _list;
  }

  ///
  Color? _getRowLineBgColor({kind}) {
    Color? _color = null;

    switch (kind) {
      case "(daily)":
        _color = Colors.grey.withOpacity(0.3);
        break;

      case "(bank)":
        _color = Colors.orangeAccent.withOpacity(0.3);
        break;

      case "(income)":
        _color = Colors.yellowAccent.withOpacity(0.3);
        break;
    }

    return _color;
  }

  ///
  Widget _monthlySummaryList() {
    List<Widget> _dataList = [];

    var _loopNum = (_monthlySummaryData.length / 2).ceil();
    for (var i = 0; i < _loopNum; i++) {
      var _number = (i * 2);
      _dataList.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 10, color: Colors.grey),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                  ),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${_monthlySummaryData[_number]['item']}'),
                      Text(_utility.makeCurrencyDisplay(
                          _monthlySummaryData[_number]['sum'].toString())),
                    ],
                  ),
                ),
              ),
              (_number + 1 >= _monthlySummaryData.length)
                  ? Expanded(
                child: Row(
                  children: <Widget>[
                    Container(),
                    Container(),
                  ],
                ),
              )
                  : Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${_monthlySummaryData[_number + 1]['item']}'),
                      Text(_utility.makeCurrencyDisplay(
                          _monthlySummaryData[_number + 1]['sum']
                              .toString())),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: ListView(
        children: _dataList,
      ),
    );
  }

  ///

  void _showAlertWindow({day, price}) {
    var date = '${widget.yearmonth}-$day';
    var cardName = _creditDateDataMap[date]![0]['card'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.3),
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${widget.yearmonth}-$day'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('$cardName'),
                  Text('$price'),
                ],
              ),
            ],
          ),
        ),
        content: _creditDateDataColumn(date: date),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("close"),
          ),
        ],
      ),
    );
  }

  ///
  Widget _creditDateDataColumn({required String date}) {
    var data = _creditDateDataMap[date];

    List<Widget> _list = [];

    for (var i = 0; i < data!.length; i++) {
      _list.add(Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          ),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${data[i]['date']}'),
                Text('${data[i]['price']}'),
              ],
            ),
            Text('${data[i]['item']}'),
          ],
        ),
      ));
    }

    return SingleChildScrollView(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 10),
        child: Column(
          children: _list,
        ),
      ),
    );
  }
}
