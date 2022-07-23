import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/ApiData.dart';

class Utility {
  /// 背景取得
  Widget getBackGround({context}) {
    return Image.asset(
      'assets/image/bg.png',
      fit: BoxFit.fitHeight,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }

  /// 日付データ作成
  late String year;
  late String month;
  late String day;
  late String youbi;
  late String youbiStr;
  late int youbiNo;

  void makeYMDYData(String date, int noneDay) {
    List explodedDate = date.split(' ');
    List explodedSelectedDate = explodedDate[0].split('-');
    year = explodedSelectedDate[0];
    month = explodedSelectedDate[1];

    if (noneDay == 1) {
      var f = NumberFormat("00");
      day = f.format(1);
    } else {
      day = explodedSelectedDate[2];
    }

    DateTime youbiDate =
        DateTime(int.parse(year), int.parse(month), int.parse(day));
    youbi = DateFormat('EEEE').format(youbiDate);
    switch (youbi) {
      case "Sunday":
        youbiStr = "日";
        youbiNo = 0;
        break;
      case "Monday":
        youbiStr = "月";
        youbiNo = 1;
        break;
      case "Tuesday":
        youbiStr = "火";
        youbiNo = 2;
        break;
      case "Wednesday":
        youbiStr = "水";
        youbiNo = 3;
        break;
      case "Thursday":
        youbiStr = "木";
        youbiNo = 4;
        break;
      case "Friday":
        youbiStr = "金";
        youbiNo = 5;
        break;
      case "Saturday":
        youbiStr = "土";
        youbiNo = 6;
        break;
    }
  }

  /// 詳細画面表示情報を取得する
  ApiData apiData = ApiData();

  Future<Map> getDetailDisplayArgs(String date) async {
    Map _monieArgs = {};

    makeYMDYData(date, 0);

    var yesterday =
        DateTime(int.parse(year), int.parse(month), int.parse(day) - 1);

    var lastMonthEnd = DateTime(int.parse(year), int.parse(month), 0);

    ////////////////////////////////////////////////////
    // //①　当日データ
    var _today = "$year-$month-$day";
    await apiData.getMoneyOfDate(date: _today);
    _monieArgs['today'] = (apiData.MoneyOfDate['data'] != "-")
        ? apiData.MoneyOfDate['data']
        : null;
    apiData.MoneyOfDate = {};
    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////
    // //②　前日データ
    makeYMDYData(yesterday.toString(), 0);
    var _zenjitsu = "$year-$month-$day";
    await apiData.getMoneyOfDate(date: _zenjitsu);
    _monieArgs['yesterday'] = (apiData.MoneyOfDate['data'] != "-")
        ? apiData.MoneyOfDate['data']
        : null;
    apiData.MoneyOfDate = {};
    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////
    // //③　先月末データ
    makeYMDYData(lastMonthEnd.toString(), 0);
    var _sengetsuLastDate = "$year-$month-$day";
    await apiData.getMoneyOfDate(date: _sengetsuLastDate);
    _monieArgs['lastMonthEnd'] = (apiData.MoneyOfDate['data'] != "-")
        ? apiData.MoneyOfDate['data']
        : null;
    apiData.MoneyOfDate = {};
    ////////////////////////////////////////////////////

    return _monieArgs;
  }

  /// 月末日取得
  late String monthEndDateTime;

  void makeMonthEnd(int year, int month, int day) {
    monthEndDateTime = DateTime(year, month, day).toString();
  }

  /// 合計金額取得
  int total = 0;
  int temochi = 0;
  int undercoin = 0;

  void makeTotal(String data, String flag) {
    var exData = (data).split('|');

    var plusNum = (flag == 'all') ? 2 : 0;

    List<List<int>> _totalValue = [];
    _totalValue.add([10000, int.parse(exData[0 + plusNum])]);
    _totalValue.add([5000, int.parse(exData[1 + plusNum])]);
    _totalValue.add([2000, int.parse(exData[2 + plusNum])]);
    _totalValue.add([1000, int.parse(exData[3 + plusNum])]);
    _totalValue.add([500, int.parse(exData[4 + plusNum])]);
    _totalValue.add([100, int.parse(exData[5 + plusNum])]);
    _totalValue.add([50, int.parse(exData[6 + plusNum])]);
    _totalValue.add([10, int.parse(exData[7 + plusNum])]);
    _totalValue.add([5, int.parse(exData[8 + plusNum])]);
    _totalValue.add([1, int.parse(exData[9 + plusNum])]);

    temochi = 0;
    for (int i = 0; i < _totalValue.length; i++) {
      temochi += (_totalValue[i][0] * _totalValue[i][1]);
    }

    _totalValue.add([1, int.parse(exData[10 + plusNum])]);
    _totalValue.add([1, int.parse(exData[11 + plusNum])]);
    _totalValue.add([1, int.parse(exData[12 + plusNum])]);
    _totalValue.add([1, int.parse(exData[13 + plusNum])]);
    _totalValue.add([1, int.parse(exData[14 + plusNum])]);

    _totalValue.add([1, int.parse(exData[15 + plusNum])]);
    _totalValue.add([1, int.parse(exData[16 + plusNum])]);
    _totalValue.add([1, int.parse(exData[17 + plusNum])]);
    _totalValue.add([1, int.parse(exData[18 + plusNum])]);
    _totalValue.add([1, int.parse(exData[19 + plusNum])]);

    total = 0;
    for (int i = 0; i < _totalValue.length; i++) {
      total += (_totalValue[i][0] * _totalValue[i][1]);
    }
    undercoin = 0;
    List<List<int>> _uc = [];
    _uc.add([10, int.parse(exData[7 + plusNum])]);
    _uc.add([5, int.parse(exData[8 + plusNum])]);
    _uc.add([1, int.parse(exData[9 + plusNum])]);
    for (int i = 0; i < _uc.length; i++) {
      undercoin += (_uc[i][0] * _uc[i][1]);
    }
  }

  /// 金額を3桁区切りで表示する
  final formatter = NumberFormat("#,###");

  String makeCurrencyDisplay(String text) {
    return formatter.format(int.parse(text));
  }

  /// 背景色取得
  Color getBgColor(String date, Map _holidayList) {
    makeYMDYData(date, 0);

    Color? _color;

    switch (youbiNo) {
      case 0:
        _color = Colors.redAccent[700]!.withOpacity(0.3);
        break;

      case 6:
        _color = Colors.blueAccent[700]!.withOpacity(0.3);
        break;

      default:
        _color = Colors.black.withOpacity(0.3);
        break;
    }

    if (_holidayList[date] != null) {
      _color = Colors.greenAccent[700]!.withOpacity(0.3);
    }

    return _color;
  }

  /// 銀行名取得
  Map getBankName() {
    Map<String, String> bankNames = {};

    bankNames['bank_a'] = 'みずほ';
    bankNames['bank_b'] = '住友547';
    bankNames['bank_c'] = '住友259';
    bankNames['bank_d'] = 'UFJ';
    bankNames['bank_e'] = '楽天';

    bankNames['pay_a'] = 'Suica1';
    bankNames['pay_b'] = 'PayPay';
    bankNames['pay_c'] = 'PASUMO';
    bankNames['pay_d'] = 'Suica2';
    bankNames['pay_e'] = 'メルカリ';

    return bankNames;
  }

  ///
  Color getLeadingBgColor({required String month}) {
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

  ///
  List<Color> getTwelveColor() {
    return [
      const Color(0xffdb2f20),
      const Color(0xffefa43a),
      const Color(0xfffdf551),
      const Color(0xffa6c63d),
      const Color(0xff439638),
      const Color(0xff469c9e),
      const Color(0xff48a0e1),
      const Color(0xff3070b1),
      const Color(0xff020c75),
      const Color(0xff931c7a),
      const Color(0xffdc2f81),
      const Color(0xffdb2f5c),
    ];
  }
}
