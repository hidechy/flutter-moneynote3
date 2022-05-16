// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison, non_constant_identifier_names, unrelated_type_equality_checks, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moneynote5/screens/YearHomeFixScreen.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'BalancesheetDataDisplayScreen.dart';
import 'DutyDataDisplayScreen.dart';
import 'FundDataDisplayScreen.dart';
import 'GoldDisplayScreen.dart';
import 'MercariDataDisplayScreen.dart';
import 'MonthlyTrendDisplayScreen.dart';
import 'SpendSummaryDisplayScreen.dart';
import 'TrainDataDisplayScreen.dart';
import 'WeeklyDataAccordionScreen.dart';
import 'WellsDataDisplayScreen.dart';

class SpendDetailPagingScreen extends StatefulWidget {
  String date;

  SpendDetailPagingScreen({Key? key, required this.date}) : super(key: key);

  @override
  _SpendDetailPagingScreenState createState() =>
      _SpendDetailPagingScreenState();
}

class _SpendDetailPagingScreenState extends State<SpendDetailPagingScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _monthlyData = [];

  String _year = '';
  String _month = '';

  String _prevMonthEndDateTime = '';
  String _prevMonthEndDate = '';

  PageController pageController = PageController();

  // ページインデックス
  int currentPage = 0;

  int _monthend = 0;

  bool _arrowDisp = false;

  late String _benefitDate = "";
  late String _benefit = "";

  Map<String, dynamic> _holidayList = {};

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
        _holidayList[apiData.HolidayOfAll['data'][i]] = '';
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    _utility.makeYMDYData(widget.date, 0);
    _year = _utility.year;
    _month = _utility.month;

    //))))))))))))))))))))
    _utility.makeMonthEnd(
        int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
    _utility.makeYMDYData(_utility.monthEndDateTime, 0);
    _monthend = int.parse(_utility.day);
    //))))))))))))))))))))

    ///////////////////////////
    _utility.makeMonthEnd(int.parse(_year), int.parse(_month), 0);
    _prevMonthEndDateTime = _utility.monthEndDateTime;

    _utility.makeYMDYData(_prevMonthEndDateTime, 0);
    _prevMonthEndDate = '${_utility.year}-${_utility.month}-${_utility.day}';

    int _prevMonthEndTotal = 0;
    await apiData.getMoneyOfDate(date: _prevMonthEndDate);
    if (apiData.MoneyOfDate != null) {
      if (apiData.MoneyOfDate['data'] != "-") {
        _utility.makeTotal(apiData.MoneyOfDate['data'], 'one');
        _prevMonthEndTotal = _utility.total;
      }
    }

    apiData.MoneyOfDate = {};
    ///////////////////////////

    //----------------------------//
    Map monthlyspenditem = {};
    await apiData.getMonthlySpendItemOfDate(date: widget.date);
    if (apiData.MonthlySpendItemOfDate != null) {
      monthlyspenditem = apiData.MonthlySpendItemOfDate;
    }
    apiData.MonthlySpendItemOfDate = {};
    //----------------------------//

    //----------------------------//
    Map monthlytraindata = {};
    await apiData.getMonthlyTrainDataOfDate(date: widget.date);
    if (apiData.MonthlyTrainDataOfDate != null) {
      monthlytraindata = apiData.MonthlyTrainDataOfDate;
    }
    apiData.MonthlyTrainDataOfDate = {};
    //----------------------------//

    //----------------------------//
    Map monthlytimeplace = {};
    await apiData.getMonthlyTimePlaceDataOfDate(date: widget.date);
    if (apiData.MonthlyTimePlaceDataOfDate != null) {
      monthlytimeplace = apiData.MonthlyTimePlaceDataOfDate;
    }
    apiData.MonthlyTimePlaceDataOfDate = {};
    //----------------------------//

    //////////////////////////////////////////
    await apiData.getMoneyOfAll();
    if (apiData.MoneyOfAll != null) {
      int j = 0;
      var _yesterdayTotal = 0;

      for (var i = 0; i < apiData.MoneyOfAll['data'].length; i++) {
        var exData = (apiData.MoneyOfAll['data'][i]).split('|');

        if ('$_year-$_month' == exData[1]) {
          _utility.makeYMDYData(exData[0], 0);

          var _map = {};
          _map["date"] = _utility.day;
          _map['youbiNo'] = _utility.youbiNo;

          var holiday_flag = 0;
          switch (_utility.youbiNo) {
            case 0:
            case 6:
              holiday_flag = 1;
              break;
          }
          if (holiday_flag == 0) {
            if (_holidayList['$_year-$_month-${_utility.day}'] != null) {
              holiday_flag = 1;
            }
          }
          _map['holiday_flag'] = holiday_flag;

          _map["strYen10000"] = exData[2];
          _map["strYen5000"] = exData[3];
          _map["strYen2000"] = exData[4];
          _map["strYen1000"] = exData[5];
          _map["strYen500"] = exData[6];
          _map["strYen100"] = exData[7];
          _map["strYen50"] = exData[8];
          _map["strYen10"] = exData[9];
          _map["strYen5"] = exData[10];
          _map["strYen1"] = exData[11];

          _map["strBankA"] = exData[12];
          _map["strBankB"] = exData[13];
          _map["strBankC"] = exData[14];
          _map["strBankD"] = exData[15];
          _map["strBankE"] = exData[16];

          _map["strPayA"] = exData[17];
          _map["strPayB"] = exData[18];
          _map["strPayC"] = exData[19];
          _map["strPayD"] = exData[20];
          _map["strPayE"] = exData[21];

          //-------------------------------------//
          List _list = [];
          for (var l = 2; l <= 21; l++) {
            _list.add(exData[l]);
          }
          _utility.makeTotal(_list.join('|'), 'one');
          _map['total'] = _utility.total;
          //-------------------------------------//

          if (j == 0) {
            _map['diff'] = (_prevMonthEndTotal - _utility.total);
          } else {
            _map['diff'] = (_yesterdayTotal - _utility.total);
          }

          /////////////////////////////////////////
          var _monthdate = '${_utility.year}-${_utility.month}-${_utility.day}';

          _map['spenditem'] = null;
          if (monthlyspenditem['data'].length > 0) {
            if (monthlyspenditem['data'][_monthdate] != null) {
              _map['spenditem'] = monthlyspenditem['data'][_monthdate];
            }
          }

          _map['traindata'] = null;
          if (monthlytraindata['data'].length > 0) {
            if (monthlytraindata['data'][_monthdate] != null) {
              _map['traindata'] = monthlytraindata['data'][_monthdate];
            }
          }

          _map['timeplace'] = null;
          if (monthlytimeplace['data'].length > 0) {
            if (monthlytimeplace['data'][_monthdate] != null) {
              _map['timeplace'] = monthlytimeplace['data'][_monthdate];
            }
          }
          /////////////////////////////////////////

          _monthlyData.add(_map);

          _yesterdayTotal = _utility.total;

          j++;
        }
      }
    }
    apiData.MoneyOfAll = {};
    //////////////////////////////////////////

    //初期ページ設定
    var ex_date = (widget.date).split('-');
    pageController.jumpToPage(int.parse(ex_date[2]));

    /////////////////////////////////
    // ページコントローラのページ遷移を監視しページ数を丸める
    pageController.addListener(() {
      int next = pageController.page!.round();
      if (pageController != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    /////////////////////////////////

    await apiData.getBenefitOfAll();
    if (apiData.BenefitOfAll != null) {
      _setBenefitData(
          yearmonth: '$_year-$_month', benefit: apiData.BenefitOfAll['data']);
    }

    setState(() {});
  }

  ///
  void _setBenefitData({required String yearmonth, required List benefit}) {
    for (var i = 0; i < benefit.length; i++) {
      var ex_data = (benefit[i]).split('|');
      if (ex_data[1] == yearmonth) {
        _benefitDate = ex_data[0];
        _benefit = ex_data[2];
      }
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('$_year-$_month'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      drawer: dispDrawer(),
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
          PageView.builder(
            controller: pageController,
            itemCount: _monthlyData.length,
            itemBuilder: (context, index) {
              //--------------------------------------// リセット
              bool active = (index == currentPage);
              if (active == false) {
                _arrowDisp = true;
              }
              //--------------------------------------//

              return Card(
                color: Colors.black.withOpacity(0.3),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: _dispMonthlyDetail(index),
                ),
              );
            },
          ),
          _dispMonthMoveArrow(context),
        ],
      ),
    );
  }

  ///
  Widget dispDrawer() {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.black.withOpacity(0.3),
      ),
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.yellowAccent.withOpacity(0.3),
                width: 10,
              ),
            ),
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 60,
                child: DrawerHeader(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: const Text(
                      'MENU',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              //

              ListTile(
                leading: const Icon(FontAwesomeIcons.home, color: Colors.white),
                title: const Text(
                  "Year Home Fix",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => const YearHomeFixScreen());
                },
              ),

              ListTile(
                leading:
                    const Icon(FontAwesomeIcons.biohazard, color: Colors.white),
                title: const Text(
                  "Year Duty Fix",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => const DutyDataDisplayScreen());
                },
              ),

              const Divider(
                  color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),

              ListTile(
                leading:
                    const Icon(Icons.center_focus_strong, color: Colors.white),
                title: const Text(
                  "History Data",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => MonthlyTrendDisplayScreen());
                },
              ),

              const Divider(
                  color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),

              ListTile(
                leading: const Icon(Icons.train, color: Colors.white),
                title: const Text(
                  "Train History",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => TrainDataDisplayScreen());
                },
              ),

              //

              ListTile(
                leading: const Icon(Icons.label, color: Colors.white),
                title: const Text(
                  "Gold History",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => GoldDisplayScreen());
                },
              ),

              //

              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.white),
                title: const Text(
                  "Fund History",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => FundDataDisplayScreen());
                },
              ),

              //

              ListTile(
                leading:
                    const Icon(FontAwesomeIcons.handshake, color: Colors.white),
                title: const Text(
                  "Mercari History",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => MercariDataDisplayScreen());
                },
              ),

              //

              ListTile(
                leading:
                    const Icon(FontAwesomeIcons.pagelines, color: Colors.white),
                title: const Text(
                  "Wells Reserve",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => WellsDataDisplayScreen());
                },
              ),

              //

              ListTile(
                leading: const Icon(FontAwesomeIcons.balanceScale,
                    color: Colors.white),
                title: const Text(
                  "BalanceSheet",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                onTap: () {
                  Get.to(() => BalancesheetDataDisplayScreen());
                },
              ),

              //
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _dispMonthlyDetail(int index) {
    Size size = MediaQuery.of(context).size;
    var oneHeight = ((size.height - 340) / 3);

    _utility.makeYMDYData('$_year-$_month-${_monthlyData[index]['date']}', 0);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _dateLineDisplay(index: index),
          const Divider(
              color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),
          _makeDisplayMoneyItem(index: index),
          const Divider(
              color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),
          _spendItemDisplay(index: index, oneHeight: oneHeight),
          const Divider(
              color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),
          _timePlaceDisplay(index: index, oneHeight: oneHeight),
          const Divider(
              color: Colors.greenAccent, indent: 10.0, endIndent: 10.0),
          _trainDataDisplay(index: index, oneHeight: oneHeight),
        ],
      ),
    );
  }

  ///
  Widget _dispMonthMoveArrow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            '■',
            style: TextStyle(color: Colors.white.withOpacity(0.1)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _dispPrevArrow(),
            _dispNextArrow(),
          ],
        ),
      ],
    );
  }

  ///
  Widget _dateLineDisplay({required int index}) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Text('${_utility.day}（${_utility.youbiStr}）'),
            color: (_monthlyData[index]['holiday_flag'] == 1)
                ? _getBGColor(youbiNo: _monthlyData[index]['youbiNo'])
                : null,
          ),
        ),
        Row(
          children: <Widget>[
            Text(_utility
                .makeCurrencyDisplay(_monthlyData[index]['total'].toString())),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => SpendSummaryDisplayScreen(
                      date: '$_year-$_month-${_monthlyData[index]['date']}'));
                },
                child: const Icon(
                  Icons.comment,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => WeeklyDataAccordionScreen(
                      date: '$_year-$_month-${_monthlyData[index]['date']}'));
                },
                child: const Icon(
                  FontAwesomeIcons.calendarWeek,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// アップロードデータ表示
  Widget _makeDisplayMoneyItem({required int index}) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.3),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 10.0),
              child: Column(
                children: <Widget>[
                  Table(
                    children: [
                      TableRow(children: [
                        _getDisplayContainer(
                            name: '10000',
                            value: _monthlyData[index]['strYen10000']),
                        _getDisplayContainer(
                            name: '5000',
                            value: _monthlyData[index]['strYen5000']),
                        _getDisplayContainer(
                            name: '2000',
                            value: _monthlyData[index]['strYen2000']),
                        _getDisplayContainer(
                            name: '1000',
                            value: _monthlyData[index]['strYen1000']),
                        _getDisplayContainer(
                            name: '500',
                            value: _monthlyData[index]['strYen500']),
                        _getDisplayContainer(
                            name: '100',
                            value: _monthlyData[index]['strYen100']),
                        _getDisplayContainer(
                            name: '50', value: _monthlyData[index]['strYen50']),
                        _getDisplayContainer(
                            name: '10', value: _monthlyData[index]['strYen10']),
                        _getDisplayContainer(
                            name: '5', value: _monthlyData[index]['strYen5']),
                        _getDisplayContainer(
                            name: '1', value: _monthlyData[index]['strYen1'])
                      ])
                    ],
                  ),
                  const Divider(
                    color: Colors.indigo,
                    height: 20.0,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  (int.parse(_monthlyData[index]['strBankA']) == 0)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(children: [
                              _getDisplayContainer(
                                  name: 'bankA',
                                  value: _monthlyData[index]['strBankA']),
                              _getDisplayContainer(
                                  name: 'bankB',
                                  value: _monthlyData[index]['strBankB']),
                              _getDisplayContainer(
                                  name: 'bankC',
                                  value: _monthlyData[index]['strBankC']),
                              _getDisplayContainer(
                                  name: 'bankD',
                                  value: _monthlyData[index]['strBankD'])
                            ])
                          ],
                        ),
                  (int.parse(_monthlyData[index]['strBankE']) == 0)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(children: [
                              _getDisplayContainer(
                                  name: 'bankE',
                                  value: _monthlyData[index]['strBankE']),
                              _getDisplayContainer(
                                  name: 'bankF',
                                  value: _monthlyData[index]['strBankF']),
                              _getDisplayContainer(
                                  name: 'bankG',
                                  value: _monthlyData[index]['strBankG']),
                              _getDisplayContainer(
                                  name: 'bankH',
                                  value: _monthlyData[index]['strBankH'])
                            ])
                          ],
                        ),
                  const Divider(
                    color: Colors.indigo,
                    height: 20.0,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  (int.parse(_monthlyData[index]['strPayA']) == 0)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(children: [
                              _getDisplayContainer(
                                  name: 'payA',
                                  value: _monthlyData[index]['strPayA']),
                              _getDisplayContainer(
                                  name: 'payB',
                                  value: _monthlyData[index]['strPayB']),
                              _getDisplayContainer(
                                  name: 'payC',
                                  value: _monthlyData[index]['strPayC']),
                              _getDisplayContainer(
                                  name: 'payD',
                                  value: _monthlyData[index]['strPayD'])
                            ])
                          ],
                        ),
                  (int.parse(_monthlyData[index]['strPayE']) == 0)
                      ? Container()
                      : Table(
                          children: [
                            TableRow(children: [
                              _getDisplayContainer(
                                  name: 'payE',
                                  value: _monthlyData[index]['strPayE']),
                              _getDisplayContainer(
                                  name: 'payF',
                                  value: _monthlyData[index]['strPayF']),
                              _getDisplayContainer(
                                  name: 'payG',
                                  value: _monthlyData[index]['strPayG']),
                              _getDisplayContainer(
                                  name: 'payH',
                                  value: _monthlyData[index]['strPayH'])
                            ])
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///
  Widget _spendItemDisplay({required int index, oneHeight}) {
    var value = _monthlyData[index]['spenditem'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Text(
              _utility
                  .makeCurrencyDisplay(_monthlyData[index]['diff'].toString()),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.greenAccent,
              ),
            ),
          ),
          SizedBox(
            height: oneHeight,
            child: _getSpendItemList(
              value: value,
              index: index,
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _timePlaceDisplay({required int index, oneHeight}) {
    var value = _monthlyData[index]['timeplace'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: oneHeight,
            child: _getTimePlaceList(value: value),
          ),
        ],
      ),
    );
  }

  ///
  Widget _getTimePlaceList({value}) {
    if (value == null) {
      return Container();
    }

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
  Widget _trainDataDisplay({required int index, oneHeight}) {
    var value = _monthlyData[index]['traindata'];

    return (value == null)
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: oneHeight,
                  child: Text(
                    '${value[0]}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
  }

  ///
  Widget _dispPrevArrow() {
    if (_arrowDisp == false) {
      return Container();
    }

    return (currentPage == 0)
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 20,
            ),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_left),
              color: Colors.greenAccent,
              onPressed: () => _goPrevDate(context: context),
            ),
          )
        : Container();
  }

  ///
  Widget _dispNextArrow() {
    if (_arrowDisp == false) {
      return Container();
    }

    return (currentPage == (_monthend - 1))
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 20,
            ),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_right),
              color: Colors.greenAccent,
              onPressed: () => _goNextDate(context: context),
            ),
          )
        : Container();
  }

  ///
  Color _getBGColor({youbiNo}) {
    switch (youbiNo) {
      case 0:
        return Colors.redAccent[700]!.withOpacity(0.3);
      case 6:
        return Colors.blueAccent[700]!.withOpacity(0.3);
      default:
        return Colors.greenAccent[700]!.withOpacity(0.3);
    }
  }

  ///
  Widget _getDisplayContainer({name, value}) {
    if (value == null) {
      value = '0';
    }

    return Container(
      alignment: Alignment.topRight,
      child: Text(
        _utility.makeCurrencyDisplay(value),
        style: TextStyle(
          color: _getTextColor(name: name),
        ),
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
  bool benefitAdd = false;

  Widget _getSpendItemList({value, index}) {
    if (value == null) {
      return Container();
    }

    if (benefitAdd == false) {
      if ('$_year-$_month-${_monthlyData[index]['date']}' == _benefitDate) {
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
                Text(
                  '${value[i]['koumoku']}',
                  strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                  style: _getSpendItemStyle(val: value[i]),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    _utility.makeCurrencyDisplay(value[i]['price'].toString()),
                    strutStyle: const StrutStyle(fontSize: 12.0, height: 1.3),
                    style: _getSpendItemStyle(val: value[i]),
                  ),
                ),
              ],
            )
          ],
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
  TextStyle _getSpendItemStyle({val}) {
    if (val['koumoku'] == '収入') {
      return const TextStyle(color: Colors.yellowAccent);
    } else if (val['bank'] == 1) {
      return const TextStyle(color: Colors.lightBlueAccent);
    } else {
      return const TextStyle();
    }
  }

  /////////////////////////////////////////////////////

  /// 画面遷移（前日）
  void _goPrevDate({required BuildContext context}) {
    _utility.makeYMDYData(widget.date, 0);
    var _prevDate =
        DateTime(int.parse(_utility.year), int.parse(_utility.month), 0);
    _utility.makeYMDYData(_prevDate.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpendDetailPagingScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }

  /// 画面遷移（翌日）
  void _goNextDate({required BuildContext context}) {
    _utility.makeYMDYData(widget.date, 0);
    var _nextDate = DateTime(
        int.parse(_utility.year), int.parse(_utility.month), _monthend + 1);
    _utility.makeYMDYData(_nextDate.toString(), 0);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SpendDetailPagingScreen(
            date: '${_utility.year}-${_utility.month}-${_utility.day}'),
      ),
    );
  }
}
