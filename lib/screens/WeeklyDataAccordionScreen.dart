// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison, prefer_is_empty

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class WeeklyDataAccordionScreen extends StatefulWidget {
  String date;

  WeeklyDataAccordionScreen({Key? key, required this.date}) : super(key: key);

  @override
  _WeeklyDataAccordionScreenState createState() =>
      _WeeklyDataAccordionScreenState();
}

class _WeeklyDataAccordionScreenState extends State<WeeklyDataAccordionScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  bool _loading = false;

  String _year = '';
  String _month = '';

  int _weeknum = 0;

  List<String> _weekday = [];

  List<WeekDay> _weekDayList = <WeekDay>[];

  late String _benefitDate = "";
  late String _benefit = "";

  List _holidayList = [];

  DateTime _prevDate = DateTime.now();
  DateTime _nextDate = DateTime.now();

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //----------------------------//
    await apiData.getHolidayOfAll();
    if (apiData.HolidayOfAll != null) {
      for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
        _holidayList.add(apiData.HolidayOfAll['data'][i]);
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    _utility.makeYMDYData(widget.date, 0);
    _year = _utility.year;
    _month = _utility.month;

    ///////////////////////////////////////////
    var _date2 = '${_utility.year}-${_utility.month}-${_utility.day}';
    await apiData.getWeekNumOfDate(date: _date2);
    if (apiData.WeekNumOfDate != null) {
      _weeknum = apiData.WeekNumOfDate['data'][0];
    }
    apiData.WeekNumOfDate = {};
    ///////////////////////////////////////////

    //---------------------------------
    var _date3 = '${_utility.year}-${_utility.month}-${_utility.day}';
    await apiData.getWeeklySpendItemOfDate(date: _date3);
    if (apiData.WeeklySpendItemOfDate != null) {
      for (var i = 0; i < apiData.WeeklySpendItemOfDate['data'].length; i++) {
        _weekday
            .add(apiData.WeeklySpendItemOfDate['data'][i]['date'].toString());
      }

      _weekday = _weekday.toSet().toList();
    }
    //---------------------------------

    //---------------------------------
    Map timeplaceweekly = {};
    var _date4 = '${_utility.year}-${_utility.month}-${_utility.day}';
    await apiData.getWeeklyTimePlaceOfDate(date: _date4);
    if (apiData.WeeklyTimePlaceOfDate != null) {
      timeplaceweekly = apiData.WeeklyTimePlaceOfDate;
    }
    //---------------------------------

    int j = 0;
    var _yesterdayTotal = 0;

    //-----------------//
    int _prevWeekEndTotal = 0;

    var exWeekday0 = _weekday[0].split('-');
    _prevDate = DateTime(int.parse(exWeekday0[0]), int.parse(exWeekday0[1]),
        int.parse(exWeekday0[2]) - 1);

    var exWeekday6 = _weekday[6].split('-');
    _nextDate = DateTime(int.parse(exWeekday6[0]), int.parse(exWeekday6[1]),
        int.parse(exWeekday6[2]) + 1);

    _utility.makeYMDYData(_prevDate.toString(), 0);

    var _date = '${_utility.year}-${_utility.month}-${_utility.day}';
    await apiData.getMoneyOfDate(date: _date);
    if (apiData.MoneyOfDate != null) {
      if (apiData.MoneyOfDate['data'] != "-") {
        _utility.makeTotal(apiData.MoneyOfDate['data'], 'one');
        _prevWeekEndTotal = _utility.total;
      }
    }
    //-----------------//

    //<<<<<<<<<<<<<<<<<<<<<<<<<//
    for (var i = 0; i < _weekday.length; i++) {
      Map _map = {};
      _map['date'] = _weekday[i];

      _map["strYen10000"] = 0;
      _map["strYen5000"] = 0;
      _map["strYen2000"] = 0;
      _map["strYen1000"] = 0;
      _map["strYen500"] = 0;
      _map["strYen100"] = 0;
      _map["strYen50"] = 0;
      _map["strYen10"] = 0;
      _map["strYen5"] = 0;
      _map["strYen1"] = 0;

      _map["strBankA"] = 0;
      _map["strBankB"] = 0;
      _map["strBankC"] = 0;
      _map["strBankD"] = 0;
      _map["strBankE"] = 0;
      _map["strBankF"] = 0;
      _map["strBankG"] = 0;
      _map["strBankH"] = 0;

      _map["strPayA"] = 0;
      _map["strPayB"] = 0;
      _map["strPayC"] = 0;
      _map["strPayD"] = 0;
      _map["strPayE"] = 0;
      _map["strPayF"] = 0;
      _map["strPayG"] = 0;
      _map["strPayH"] = 0;

      _map['total'] = 0;

      await apiData.getMoneyOfDate(date: _weekday[i]);
      if (apiData.MoneyOfDate != null) {
        if (apiData.MoneyOfDate['data'] != "-") {
          var exData = (apiData.MoneyOfDate['data']).split('|');

          _map["strYen10000"] = exData[0];
          _map["strYen5000"] = exData[1];
          _map["strYen2000"] = exData[2];
          _map["strYen1000"] = exData[3];
          _map["strYen500"] = exData[4];
          _map["strYen100"] = exData[5];
          _map["strYen50"] = exData[6];
          _map["strYen10"] = exData[7];
          _map["strYen5"] = exData[8];
          _map["strYen1"] = exData[9];

          _map["strBankA"] = exData[10];
          _map["strBankB"] = exData[11];
          _map["strBankC"] = exData[12];
          _map["strBankD"] = exData[13];
          _map["strBankE"] = exData[14];

          _map["strPayA"] = exData[15];
          _map["strPayB"] = exData[16];
          _map["strPayC"] = exData[17];
          _map["strPayD"] = exData[18];
          _map["strPayE"] = exData[19];

          _utility.makeTotal(apiData.MoneyOfDate['data'], 'one');
          _map['total'] = _utility.total;
        }
      }
      apiData.MoneyOfDate = {};

      if (j == 0) {
        _map['diff'] = (_prevWeekEndTotal - _utility.total);
      } else {
        _map['diff'] = (_yesterdayTotal - _utility.total);
      }

      _map['spend'] = _getSpendData(
        date: _weekday[i],
        spenditem: apiData.WeeklySpendItemOfDate['data'],
      );

      _map['timeplace'] = _getTimeplaceData(
        date: _weekday[i],
        timeplace: timeplaceweekly['data'],
      );

      _utility.makeYMDYData(_weekday[i], 0);

      var holidayFlag =
          _getHolidayFlag(date: _weekday[i], holiday: _holidayList);

      _weekDayList.add(
        WeekDay(
          isExpanded: false,
          date: _weekday[i],
          youbi: _utility.youbiStr,
          data: _map,
          youbiNo: _utility.youbiNo,
          holidayFlag: holidayFlag,
        ),
      );

      _yesterdayTotal = _utility.total;

      j++;
    }
    //<<<<<<<<<<<<<<<<<<<<<<<<<//

    _setBenefitData(yearmonth: '$_year-$_month');

    setState(() {
      _loading = true;
    });
  }

  ///
  List _getSpendData({required String date, required List spenditem}) {
    List _list = [];
    for (var i = 0; i < spenditem.length; i++) {
      if (spenditem[i]['date'] == date) {
        _list.add(spenditem[i]);
      }
    }
    return _list;
  }

  ///
  List _getTimeplaceData({required String date, required List timeplace}) {
    List _list = [];
    for (var i = 0; i < timeplace.length; i++) {
      if (timeplace[i]['date'] == date) {
        _list.add(timeplace[i]);
      }
    }
    return _list;
  }

  ///
  @override
  Widget build(BuildContext context) {
    var _headerTitle =
        (_weekDayList.length > 0) ? '$_year-$_month [${_weeknum}wks]' : '';

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text(_headerTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          color: Colors.greenAccent,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.skip_previous),
            tooltip: '前日',
            onPressed: () => _goPrevWeek(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌日',
            onPressed: () => _goNextWeek(context: context),
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
              : _dispPageContent(context),
        ],
      ),
    );
  }

  ///
  Widget _dispPageContent(BuildContext context) {
    return ListView(
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(
            cardColor: Colors.black.withOpacity(0.1),
          ),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              _weekDayList[index].isExpanded = !_weekDayList[index].isExpanded;
              setState(() {});
            },
            children: _weekDayList.map(_createPanel).toList(),
          ),
        ),
      ],
    );
  }

  ///
  ExpansionPanel _createPanel(WeekDay wday) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(
          color: _getBGColor(value: wday),
          padding: const EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Row(
              children: <Widget>[
                Text(
                  '${wday.date}（${wday.youbi}）',
                  style: const TextStyle(fontSize: 12),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Text(_utility
                        .makeCurrencyDisplay(wday.data['total'].toString())),
                  ),
                ),
                Container(
                  width: 80,
                  alignment: Alignment.topRight,
                  child: Text(_utility
                      .makeCurrencyDisplay(wday.data['diff'].toString())),
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
        child: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(
                  children: [
                    _getDisplayContainer(
                        name: '10000',
                        value: wday.data['strYen10000'].toString()),
                    _getDisplayContainer(
                        name: '5000',
                        value: wday.data['strYen5000'].toString()),
                    _getDisplayContainer(
                        name: '2000',
                        value: wday.data['strYen2000'].toString()),
                    _getDisplayContainer(
                        name: '1000',
                        value: wday.data['strYen1000'].toString()),
                    _getDisplayContainer(
                        name: '500', value: wday.data['strYen500'].toString()),
                    _getDisplayContainer(
                        name: '100', value: wday.data['strYen100'].toString()),
                    _getDisplayContainer(
                        name: '50', value: wday.data['strYen50'].toString()),
                    _getDisplayContainer(
                        name: '10', value: wday.data['strYen10'].toString()),
                    _getDisplayContainer(
                        name: '5', value: wday.data['strYen5'].toString()),
                    _getDisplayContainer(
                        name: '1', value: wday.data['strYen1'].toString())
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.indigo,
              height: 20.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            //
            (wday.data['strBankA'] == '0')
                ? Container()
                : Table(
                    children: [
                      TableRow(
                        children: [
                          _getDisplayContainer(
                              name: 'BankA',
                              value: wday.data['strBankA'].toString()),
                          _getDisplayContainer(
                              name: 'BankB',
                              value: wday.data['strBankB'].toString()),
                          _getDisplayContainer(
                              name: 'BankC',
                              value: wday.data['strBankC'].toString()),
                          _getDisplayContainer(
                              name: 'BankD',
                              value: wday.data['strBankD'].toString()),
                        ],
                      ),
                    ],
                  ),
            (wday.data['strBankE'] == '0')
                ? Container()
                : Table(
                    children: [
                      TableRow(
                        children: [
                          _getDisplayContainer(
                              name: 'BankE',
                              value: wday.data['strBankE'].toString()),
                          _getDisplayContainer(
                              name: 'BankF',
                              value: wday.data['strBankF'].toString()),
                          _getDisplayContainer(
                              name: 'BankG',
                              value: wday.data['strBankG'].toString()),
                          _getDisplayContainer(
                              name: 'BankH',
                              value: wday.data['strBankH'].toString()),
                        ],
                      ),
                    ],
                  ),
            const Divider(
              color: Colors.indigo,
              height: 20.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            //
            (wday.data['strPayA'] == '0')
                ? Container()
                : Table(
                    children: [
                      TableRow(
                        children: [
                          _getDisplayContainer(
                              name: 'PayA',
                              value: wday.data['strPayA'].toString()),
                          _getDisplayContainer(
                              name: 'PayB',
                              value: wday.data['strPayB'].toString()),
                          _getDisplayContainer(
                              name: 'PayC',
                              value: wday.data['strPayC'].toString()),
                          _getDisplayContainer(
                              name: 'PayD',
                              value: wday.data['strPayD'].toString()),
                        ],
                      ),
                    ],
                  ),
            (wday.data['strPayE'] == '0')
                ? Container()
                : Table(
                    children: [
                      TableRow(
                        children: [
                          _getDisplayContainer(
                              name: 'PayE',
                              value: wday.data['strPayE'].toString()),
                          _getDisplayContainer(
                              name: 'PayF',
                              value: wday.data['strPayF'].toString()),
                          _getDisplayContainer(
                              name: 'PayG',
                              value: wday.data['strPayG'].toString()),
                          _getDisplayContainer(
                              name: 'PayH',
                              value: wday.data['strPayH'].toString()),
                        ],
                      ),
                    ],
                  ),
            const Divider(
              color: Colors.indigo,
              height: 20.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            //
            _spendItemDisplay(value: wday.data),
            const Divider(
              color: Colors.indigo,
              height: 20.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            //

            _timeplaceDisplay(value: wday.data),
          ],
        ),
      ),
      //
      isExpanded: wday.isExpanded,
    );
  }

  ///
  Color _getBGColor({required WeekDay value}) {
    if (value.holidayFlag == 1) {
      return Colors.greenAccent[700]!.withOpacity(0.3);
    }

    switch (value.youbiNo) {
      case 0:
        return Colors.redAccent[700]!.withOpacity(0.3);
      case 6:
        return Colors.blueAccent[700]!.withOpacity(0.3);
      default:
        return Colors.black.withOpacity(0.1);
    }
  }

  ///
  Widget _getDisplayContainer({name, value}) {
    return Container(
      alignment: Alignment.topRight,
      child: Text(
        _utility.makeCurrencyDisplay(value),
        style: TextStyle(color: _getTextColor(name: name), fontSize: 12),
      ),
    );
  }

  ///
  Color _getTextColor({name}) {
    switch (name) {
      case '10000':
      case '5000':
      case '2000':
      case '1000':
        return Colors.greenAccent;
      case '10':
      case '5':
      case '1':
        return Colors.yellowAccent;
      default:
        return Colors.white;
    }
  }

  ///
  Widget _spendItemDisplay({value}) {
    if (value['spend'][0]['koumoku'] == '') {
      return Container();
    }

    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topRight,
          child: Text(
            _utility.makeCurrencyDisplay(value['diff'].toString()),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.greenAccent,
            ),
          ),
        ),
        _getSpendItemList(value: value['spend']),
      ],
    );
  }

  ///
  bool benefitAdd = false;

  Widget _getSpendItemList({value}) {
    if (benefitAdd == false) {
      if ('${value[0]['date']}' == _benefitDate) {
        Map _map = {};
        _map['koumoku'] = '収入';
        _map['price'] = _benefit;
        value.add(_map);

        benefitAdd = true;
      }
    }

    List<Widget> _list = [];
    for (var i = 0; i < value.length; i++) {
      _list.add(
        Table(
          children: [
            TableRow(
              children: [
                const Text(''),
                const Text(''),
                Text(
                  '${value[i]['koumoku']}',
                  strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                  style: (value[i]['koumoku'] == '収入')
                      ? const TextStyle(color: Colors.yellowAccent)
                      : null,
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    _utility.makeCurrencyDisplay(value[i]['price'].toString()),
                    strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                    style: (value[i]['koumoku'] == '収入')
                        ? const TextStyle(color: Colors.yellowAccent)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        children: _list,
      ),
    );
  }

  ///
  void _setBenefitData({required String yearmonth}) async {
    await apiData.getBenefitOfAll();
    if (apiData.BenefitOfAll != null) {
      for (var i = 0; i < apiData.BenefitOfAll['data'].length; i++) {
        var exData = (apiData.BenefitOfAll['data'][i]).split('|');
        if ('${exData[1]}' == yearmonth) {
          _benefitDate = exData[1];
          _benefit = exData[2];
          break;
        }
      }
    }
    apiData.BenefitOfAll = {};
  }

  ///
  Widget _timeplaceDisplay({required Map value}) {
    if (value['timeplace'].length == 0) {
      return Container();
    }

    return Row(
      children: <Widget>[
        Container(
          width: 90,
        ),
        Expanded(
          child: _getTimeplaceList(value: value['timeplace']),
        ),
      ],
    );
  }

  ///
  Widget _getTimeplaceList({value}) {
    List<Widget> _list = [];
    for (var i = 0; i < value.length; i++) {
      _list.add(
        Container(
          color: (value[i]['place'] == '移動中')
              ? Colors.green[900]!.withOpacity(0.5)
              : null,
          child: Table(
            children: [
              TableRow(
                children: [
                  Text(
                    '${value[i]['time']}',
                    strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                  ),
                  Text(
                    '${value[i]['place']}',
                    strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      _utility
                          .makeCurrencyDisplay(value[i]['price'].toString()),
                      strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                    ),
                  ),
                ],
              )
            ],
          ),
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

  ///
  int _getHolidayFlag({required String date, required List holiday}) {
    int ret = 0;

    for (var i = 0; i < holiday.length; i++) {
      if (date == holiday[i]) {
        ret = 1;
        break;
      }
    }

    return ret;
  }

  /////////////////////////////////////////////////

  ///
  _goPrevWeek({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WeeklyDataAccordionScreen(date: _prevDate.toString()),
      ),
    );
  }

  ///
  _goNextWeek({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WeeklyDataAccordionScreen(date: _nextDate.toString()),
      ),
    );
  }
}

class WeekDay {
  bool isExpanded;
  String date;
  String youbi;
  Map data;
  int youbiNo;
  int holidayFlag;

  WeekDay({
    required this.isExpanded,
    required this.date,
    required this.youbi,
    required this.data,
    required this.youbiNo,
    required this.holidayFlag,
  });
}
