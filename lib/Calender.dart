// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, unnecessary_null_comparison, prefer_final_fields

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

import 'package:fluttertoast/fluttertoast.dart';

import './utilities/utility.dart';
import './utilities/CustomShapeClipper.dart';

import './data/ApiData.dart';

import './screens/DetailDisplayScreen.dart';
import './screens/MonthlyListScreen.dart';
import './screens/OnedayInputScreen.dart';
import './screens/ScoreListScreen.dart';
import 'screens/DetailScreen.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  DateTime _currentDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  late String year;
  late String month;
  late String day;
  late String youbiStr;

  EventList<Event> _markedDateMap = EventList(events: {});

  late Widget _summaryDataWidget = Container();

  num _total = 0;

  bool _detailScreenCallMode = true;

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
        _utility.makeYMDYData(apiData.HolidayOfAll['data'][i], 0);

        _markedDateMap.add(
          DateTime(int.parse(_utility.year), int.parse(_utility.month),
              int.parse(_utility.day)),
          Event(
            date: DateTime(
              int.parse(_utility.year),
              int.parse(_utility.month),
              int.parse(_utility.day),
            ),
            icon: const Icon(Icons.flag),
          ),
        );
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    _utility.makeYMDYData(_currentMonth.toString(), 0);
    _summaryDataWidget = await _makeSpendSummaryData(
        date: '${_utility.year}-${_utility.month}-01');

    Fluttertoast.showToast(
      msg: "呼び出し完了",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    setState(() {});
  }

  /// 画面描画
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
          CalendarCarousel<Event>(
            minSelectedDate: DateTime(2020, 1, 1),

            markedDatesMap: _markedDateMap,

            locale: 'JA',

            todayBorderColor: Colors.orangeAccent.withOpacity(0.8),
            todayButtonColor: Colors.orangeAccent.withOpacity(0.1),

            selectedDayButtonColor: Colors.greenAccent.withOpacity(0.1),

            thisMonthDayBorderColor: Colors.grey,

            weekendTextStyle:
                const TextStyle(fontSize: 16.0, color: Colors.red),
            weekdayTextStyle: const TextStyle(color: Colors.grey),
            dayButtonColor: Colors.black.withOpacity(0.3),

            onDayPressed: onDayPressed,

            onCalendarChanged: onCalendarChanged,

            weekFormat: false,
            selectedDateTime: _currentDate,
            daysHaveCircularBorder: false,
            customGridViewPhysics: const NeverScrollableScrollPhysics(),
            daysTextStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
            todayTextStyle:
                const TextStyle(fontSize: 16.0, color: Colors.white),

            headerTextStyle: const TextStyle(fontSize: 18.0),

//            selectedDayTextStyle: TextStyle(fontFamily: 'Yomogi'),
//            prevDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),
//            nextDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),

//markedDateCustomTextStyle: TextStyle(fontFamily: 'Yomogi'),
//markedDateMoreCustomTextStyle: TextStyle(fontFamily: 'Yomogi'),

//inactiveDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),
//inactiveWeekendTextStyle: TextStyle(fontFamily: 'Yomogi'),
          ),
          Column(
            children: [
              Expanded(child: Container(width: 1)),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            const Text('2'),
                            Switch(
                              value: _detailScreenCallMode,
                              onChanged: _changeSwitch,
                              activeColor: Colors.white,
                              activeTrackColor: Colors.orangeAccent,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.orangeAccent,
                            ),
                            const Text('1'),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 150,
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(_utility
                                .makeCurrencyDisplay(_total.toString())),
                          ),
                          IconButton(
                            color: Colors.greenAccent,
                            icon: const Icon(Icons.refresh),
                            onPressed: () => _reloadSummaryData(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 170,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: _summaryDataWidget,
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.black,
        backgroundColor: Colors.black38,
        items: const <Widget>[
          Icon(Icons.graphic_eq),
          Icon(Icons.input),
          Icon(Icons.list),
          Icon(
            Icons.close,
            color: Colors.yellowAccent,
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              return _goScoreDisplayScreen(
                context: context,
                date: _currentDate.toString(),
              );
            case 1:
              return _goOnedayInputScreen(
                context: context,
                date: _currentDate.toString(),
              );
            case 2:
              return _goMonthlyScreen(
                context: context,
                date: _currentDate.toString(),
              );
            case 3:
              Navigator.pop(context);
          }
        },
      ),
    );
  }

  ///
  void _changeSwitch(bool e) {
    setState(() {
      _detailScreenCallMode = e;
    });
  }

  /// カレンダー日付クリック
  void onDayPressed(DateTime date, List<Event> events) async {
    setState(() => _currentDate = date);

    //画面遷移
    if (_detailScreenCallMode) {
      _goDetailDisplayScreen(
        context: context,
        date: _currentDate.toString(),
      );
    } else {
      _goDetailScreen(
        context: context,
        date: _currentDate.toString(),
      );
    }
  }

  ///
  void onCalendarChanged(DateTime date) async {
    setState(() => _currentMonth = date);

    _total = 0;
    _summaryDataWidget = Container();

    _utility.makeYMDYData(date.toString(), 0);
    _summaryDataWidget = await _makeSpendSummaryData(
        date: '${_utility.year}-${_utility.month}-01');

    Fluttertoast.showToast(
      msg: "呼び出し完了",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    setState(() {});
  }

  ///
  Future<Widget> _makeSpendSummaryData({String? date}) async {
    await apiData.getMonthSummaryOfDate(date: date);
    if (apiData.MonthSummaryOfDate != null) {
      return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          children: _makeSpendSummaryDataRow(
              data: apiData.MonthSummaryOfDate['data']),
        ),
      );
    } else {
      return Container();
    }
  }

  ///
  List<Widget> _makeSpendSummaryDataRow({List? data}) {
    List<Widget> _dataList = [];

    _total = 0;
    for (var i = 0; i < data!.length; i++) {
      _total += (data[i]['sum'] != null) ? data[i]['sum'] : 0;
    }

    var _loopNum = (data.length / 2).ceil();
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
                      Text('${data[_number]['item']}'),
                      Row(
                        children: [
                          Text(
                            _utility.makeCurrencyDisplay(
                              data[_number]['sum'].toString(),
                            ),
                          ),
                          // SizedBox(width: 5),
                          // GestureDetector(
                          //   onTap: () => _goItemDetailDisplayScreen(
                          //     item: data[_number]['item'],
                          //     sum: data[_number]['sum'],
                          //   ),
                          //   child: Icon(
                          //     Icons.call_made,
                          //     color: Colors.greenAccent.withOpacity(0.3),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              (_number + 1 >= data.length)
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
                            Text('${data[_number + 1]['item']}'),
                            Row(
                              children: [
                                Text(
                                  _utility.makeCurrencyDisplay(
                                    data[_number + 1]['sum'].toString(),
                                  ),
                                ),
                                // SizedBox(width: 5),
                                // GestureDetector(
                                //   onTap: () => _goItemDetailDisplayScreen(
                                //     item: data[_number + 1]['item'],
                                //     sum: data[_number + 1]['sum'],
                                //   ),
                                //   child: Icon(
                                //     Icons.call_made,
                                //     color: Colors.greenAccent.withOpacity(0.3),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    }

    return _dataList;
  }

  ///
  void _reloadSummaryData() async {
    _total = 0;
    _summaryDataWidget = Container();

    _utility.makeYMDYData(_currentMonth.toString(), 0);
    _summaryDataWidget = await _makeSpendSummaryData(
        date: '${_utility.year}-${_utility.month}-01');

    Fluttertoast.showToast(
      msg: "呼び出し完了",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    setState(() {});
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  /// 画面遷移（DetailDisplayScreen）
  void _goDetailDisplayScreen({BuildContext? context, String? date}) async {
    var detailDisplayArgs = await _utility.getDetailDisplayArgs(date!);

    _utility.makeYMDYData(date, 0);

    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => DetailDisplayScreen(
          date: date,
          index: int.parse(_utility.day),
          detailDisplayArgs: detailDisplayArgs,
        ),
      ),
    );
  }

  ///
  void _goDetailScreen({BuildContext? context, String? date}) async {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          date: date!,
        ),
      ),
    );
  }

  /// 画面遷移（OnedayInputScreen）
  void _goOnedayInputScreen({BuildContext? context, String? date}) {
    _utility.makeYMDYData(date!, 0);

    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => OnedayInputScreen(
          date: _utility.year + "-" + _utility.month + "-" + _utility.day,
          closeMethod: 'single',
        ),
      ),
    );
  }

  /// 画面遷移（ScoreListScreen）
  void _goScoreDisplayScreen({BuildContext? context, String? date}) {
    _utility.makeYMDYData(date!, 0);

    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => ScoreListScreen(
          closeMethod: 'single',
        ),
      ),
    );
  }

  /// 画面遷移（MonthlyListScreen）
  void _goMonthlyScreen({BuildContext? context, String? date}) {
    _utility.makeYMDYData(date!, 0);

    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => MonthlyListScreen(
          date: _utility.year + "-" + _utility.month + "-" + _utility.day,
          closeMethod: 'single',
        ),
      ),
    );
  }
}
