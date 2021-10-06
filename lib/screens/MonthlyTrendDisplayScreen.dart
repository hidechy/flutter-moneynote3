// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class MonthlyTrendDisplayScreen extends StatefulWidget {
  @override
  _MonthlyTrendDisplayScreenState createState() =>
      _MonthlyTrendDisplayScreenState();
}

class _MonthlyTrendDisplayScreenState extends State<MonthlyTrendDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _trendData = [];

  ScrollController _controllerX = ScrollController();
  ScrollController _controllerY = ScrollController();

  List<Map<dynamic, dynamic>> _yearStartMoney = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //-----------------------//
    Map salary = {};
    await apiData.getListOfSalaryData();
    if (apiData.ListOfSalaryData != null) {
      salary = apiData.ListOfSalaryData;
    }
    apiData.ListOfSalaryData = {};
    //-----------------------//

    ///////////////////////////////////////////
    await apiData.getMoneyOfMonthStart();
    if (apiData.MoneyOfMonthStart != null) {
      for (var i = 0; i < apiData.MoneyOfMonthStart['data'].length; i++) {
        _makeYearStartMoney(data: apiData.MoneyOfMonthStart['data'][i]);

        Map _map = {};
        _map['year'] = apiData.MoneyOfMonthStart['data'][i]['year'];
        _map['price'] = apiData.MoneyOfMonthStart['data'][i]['price'];
        _map['manen'] = apiData.MoneyOfMonthStart['data'][i]['manen'];
        _map['updown'] = apiData.MoneyOfMonthStart['data'][i]['updown'];
        _map['sagaku'] = apiData.MoneyOfMonthStart['data'][i]['sagaku'];

        _map['salary'] = _getSalary(
          year: apiData.MoneyOfMonthStart['data'][i]['year'],
          salary: salary['data'],
        );

        _trendData.add(_map);
      }
    }
    apiData.MoneyOfMonthStart = {};
    ///////////////////////////////////////////

    setState(() {});
  }

  ///
  _makeYearStartMoney({data}) {
    var exPrice = (data['price']).split('|');
    if (data['year'] > 2014) {
      Map _map = {};
      _map['year'] = data['year'];
      _map['price'] = exPrice[0];
      _yearStartMoney.add(_map);
    }
  }

  ///
  String _getSalary({year, salary}) {
    var answer;
    for (var i = 0; i < salary.length; i++) {
      if (salary[i]["year"] == year) {
        answer = salary[i]["salary"];
        break;
      }
    }
    return answer;
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('History'),
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
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              controller: _controllerY,
              child: SingleChildScrollView(
                controller: _controllerX,
                scrollDirection: Axis.horizontal,
                child: buildPlaid(),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: const SizedBox(
              width: double.infinity,
              height: double.infinity,
            ),
            onPanUpdate: (DragUpdateDetails data) {
              _controllerX.jumpTo(
                _controllerX.offset + (data.delta.dx * -1),
              );
              _controllerY.jumpTo(
                _controllerY.offset + (data.delta.dy * -1),
              );
            },
          ),
        ],
      ),
    );
  }

  ///
  Widget buildPlaid() {
    var _decoration = BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      border: Border.all(
        color: Colors.blueAccent.withOpacity(0.3),
      ),
    );

    var _decoration2 = BoxDecoration(
      color: Colors.blueAccent.withOpacity(0.3),
      border: Border.all(
        color: Colors.blueAccent.withOpacity(0.3),
      ),
    );

    var _cellHeight = 160.0;

    List<Widget> _listColumn = [];
    for (var j = 0; j < _trendData.length; j++) {
      var exManen = (_trendData[j]['manen']).split('|');
      var exUpdown = (_trendData[j]['updown']).split('|');
      var exSagaku = (_trendData[j]['sagaku']).split('|');
      var exSalary = (_trendData[j]['salary']).split('|');

      List<Widget> _listRow = [];
      var exPrice = (_trendData[j]['price']).split('|');
      exPrice.insert(0, _trendData[j]['year'].toString());
      for (var i = 0; i < exPrice.length; i++) {
        ////////////////////////////////////
        _listRow.add(
          (i == 0)
              ? Container(
                  decoration: (i != 0) ? _decoration : _decoration2,
                  margin: const EdgeInsets.all(2),
                  width: 80,
                  height: _cellHeight,
                  child: Text('${exPrice[i]}'),
                )
              : Container(
                  decoration: (i != 0) ? _decoration : _decoration2,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(5),
                  width: 80,
                  height: _cellHeight,
                  alignment: Alignment.topCenter,
                  child: (exPrice[i] == '-')
                      ? const Text(
                          '',
                          style: TextStyle(fontSize: 12),
                        )
                      : _getOneBlockItem(
                          year: _trendData[j]['year'],
                          month: i,
                          cellNo: i,
                          price: exPrice,
                          manen: exManen,
                          updown: exUpdown,
                          sagaku: exSagaku,
                          salary: exSalary,
                        ),
                ),
        );
        ////////////////////////////////////

      }

      _listColumn.add(
        Row(
          children: _listRow,
        ),
      );
    }

    List<Widget> _listRow = [];

    //---------------------------------------//line1 month
    for (var i = 0; i <= 12; i++) {
      _listRow.add(
        Container(
          decoration: (i != 0) ? _decoration2 : null,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.topCenter,
          width: 80,
          child: (i == 0) ? const Text('') : Text('$i'),
        ),
      );
    }

    _listColumn.insert(
      0,
      Row(
        children: _listRow,
      ),
    );
    //---------------------------------------//line1 month

    return Column(
      children: _listColumn,
    );
  }

  ///
  Widget _getOneBlockItem({
    year,
    month,
    cellNo,
    price,
    manen,
    updown,
    sagaku,
    salary,
  }) {
    var ym = '$year-${month.toString().padLeft(2, "0")}';

    return Column(
      children: <Widget>[
        //-----------------------------------//
        //
        Container(
          padding: const EdgeInsets.only(bottom: 3),
          alignment: Alignment.topRight,
          child: Text(
            ym,
            style: const TextStyle(fontSize: 10),
          ),
        ),
        //
        Text(
          _utility.makeCurrencyDisplay(price[cellNo]),
          style: const TextStyle(fontSize: 12),
          strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
        ),
        //
        Text(
          '${manen[cellNo - 1]}',
          style: const TextStyle(fontSize: 12),
          strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
        ),
        //
        (updown[cellNo - 1] == '1')
            ? const Icon(Icons.add, size: 20, color: Colors.greenAccent)
            : const Icon(Icons.remove, size: 20, color: Colors.redAccent),
        //
        Text(
          '${sagaku[cellNo - 1]}',
          style: const TextStyle(fontSize: 12),
          strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
        ),
        //
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 5),
          color: Colors.yellowAccent.withOpacity(0.3),
          width: double.infinity,
          child: Text(
            '${salary[cellNo - 1]}',
            style: const TextStyle(fontSize: 12),
            strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
          ),
        ),
        //
        _getMonthSpend(
            cellNo: cellNo,
            updown: updown,
            salary: salary,
            sagaku: sagaku,
            ym: ym,
            price: price),
        //
        //-----------------------------------//
      ],
    );
  }

  ///
  Widget _getMonthSpend({cellNo, updown, salary, sagaku, ym, price}) {
    var answer = 0;

    if (cellNo > updown.length) {
      return Container();
    } else if (cellNo == updown.length) {
      var _nextYearStart = _getNextYearStart(ym: ym, data: _yearStartMoney);
      var diff = (int.parse(_nextYearStart) - int.parse(price[cellNo]));
      var _sagaku = (diff / 10000).round();

      var _salary = (salary[cellNo - 1]).replaceAll('万円', '');
      if (_salary == '-') {
        _salary = '0';
      }

      if (_sagaku < 0) {
        answer = (int.parse(_salary) + (_sagaku * -1));
      } else {
        answer = (int.parse(_salary) - _sagaku);
      }
    } else {
      var _salary = (salary[cellNo - 1]).replaceAll('万円', '');
      if (_salary == '-') {
        _salary = '0';
      }

      var _sagaku = (sagaku[cellNo]).replaceAll('万円', '');

      switch (updown[cellNo]) {
        case '0':
          answer = (int.parse(_salary) + int.parse(_sagaku));
          break;
        case '1':
          answer = (int.parse(_salary) - int.parse(_sagaku));
          break;
      }
    }

    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.only(top: 5),
      color: Colors.redAccent.withOpacity(0.3),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            '$answer万円',
            style: const TextStyle(fontSize: 12),
            strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
          ),
        ],
      ),
    );
  }

  ///
  String _getNextYearStart({ym, required List<Map> data}) {
    var price;
    var exYm = (ym).split('-');
    for (var i = 0; i < data.length; i++) {
      if ((int.parse(exYm[0]) + 1) == data[i]['year']) {
        price = data[i]['price'];
        break;
      }
    }
    return price;
  }
}
