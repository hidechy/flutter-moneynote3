// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:get/get.dart';

import '../riverpod/investment/investment_gold_view_model.dart';
import '../riverpod/investment/investment_shintaku_view_model.dart';
import '../riverpod/investment/investment_stock_view_model.dart';
import '../riverpod/view_model/holiday_view_model.dart';
import '../riverpod/view_model/money_view_model.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import 'AlldayListScreen.dart';
import 'BankInputScreen.dart';
import 'BenefitInputScreen.dart';
import 'GoldDisplayScreen.dart';
import 'InvestmentTabScreen.dart';
import 'MonthlyListScreen.dart';
import 'OnedayInputScreen.dart';
import 'SamedayListScreen.dart';
import 'ScoreListScreen.dart';
import 'SpendDetailPagingScreen.dart';

class DetailScreen extends ConsumerWidget {
  DetailScreen({Key? key, required this.date}) : super(key: key);

  final String date;

  final Utility _utility = Utility();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
          Row(
            children: <Widget>[
              DetailLeft(date: date),
              DetailRight(date: date),
            ],
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////

class DetailLeft extends ConsumerWidget {
  DetailLeft({Key? key, required this.date}) : super(key: key);

  final String date;

  late BuildContext _context;
  late WidgetRef _ref;

  final Utility _utility = Utility();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    final exDate = date.split(' ');
    final exOneDay = exDate[0].split('-');

    var prevDate = DateTime(int.parse(exOneDay[0]), int.parse(exOneDay[1]),
        int.parse(exOneDay[2]) - 1);

    var nextDate = DateTime(int.parse(exOneDay[0]), int.parse(exOneDay[1]),
        int.parse(exOneDay[2]) + 1);

    _utility.makeYMDYData(date, 0);

    return Expanded(
      child: Column(
        children: <Widget>[
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            color: Colors.black.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        tooltip: '前日',
                        onPressed: () {
                          _goDetailScreen(
                              monthDate: prevDate.toString().split(' ')[0]);
                        },
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 10),
                        child: DefaultTextStyle(
                          style: const TextStyle(fontSize: 14),
                          child: Text(
                              '${date.toString().split(' ')[0]}（${_utility.youbiStr}）'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        tooltip: '翌日',
                        onPressed: () {
                          _goDetailScreen(
                              monthDate: nextDate.toString().split(' ')[0]);
                        },
                      ),
                    ],
                  ),
                  _dispTotal(),
                  const Divider(color: Colors.indigo),
                  _dispCurrency(),
                  const SizedBox(height: 10),
                  _dispDeposit(),
                  const SizedBox(height: 10),
                  _dispEMoney(),
                  const Divider(color: Colors.indigo),
                  _dispToushiData(),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              width: double.infinity,
              child: ElevatedButton(
                //color: Colors.black.withOpacity(0.3),

                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {
                  _showUnderMenu();
                },

                child: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.greenAccent,
                ),
              ),
            ),
          ),
          //------------------------------------------------------------------------//
        ],
      ),
    );
  }

  /// 下部メニュー表示
  Future<dynamic> _showUnderMenu() {
    return showModalBottomSheet(
      backgroundColor: Colors.black.withOpacity(0.1),
      context: _context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border(
                top: BorderSide(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  width: 10,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.input),
                  title: const Text(
                    'Oneday Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() {
                      return OnedayInputScreen(
                        date: date,
                        closeMethod: 'double',
                      );
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text(
                    'Bank Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() {
                      return BankInputScreen(date: date);
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: const Text(
                    'Benefit Input',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() {
                      return BenefitInputScreen();
                    });
                  },
                ),
                const Divider(
                  color: Colors.indigo,
                  height: 20.0,
                  indent: 20.0,
                  endIndent: 20.0,
                ),
                ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text(
                      'Monthly List',
                      style: TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      Get.to(() {
                        return MonthlyListScreen(
                          date: date,
                          closeMethod: 'double',
                        );
                      });
                    }),
                ListTile(
                  leading: const Icon(Icons.trending_up),
                  title: const Text(
                    'Score List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() {
                      return ScoreListScreen(closeMethod: 'double');
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.all_out),
                  title: const Text(
                    'AllDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() {
                      return AlldayListScreen(date: date);
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.animation),
                  title: const Text(
                    'SameDay List',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    Get.to(() {
                      return SamedayListScreen(date: date);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///
  Widget _dispTotal() {
    final exDate = date.split(' ');
    final exOneDay = exDate[0].split('-');

    //---------------------------------// MoneyData
    final yesterday = DateTime(
      int.parse(exOneDay[0]),
      int.parse(exOneDay[1]),
      int.parse(exOneDay[2]) - 1,
    );

    final prevMonthLastDate = DateTime(
      int.parse(exOneDay[0]),
      int.parse(exOneDay[1]),
      0,
    );

    //-----

    final moneyState = _ref.watch(moneyProvider(exDate[0]));

    final yesterdayMoneyState = _ref.watch(
      moneyProvider(
        yesterday.toString().split(' ')[0],
      ),
    );

    final pmldMoneyState = _ref.watch(
      moneyProvider(
        prevMonthLastDate.toString().split(' ')[0],
      ),
    );

    //-----

    final monthStart = pmldMoneyState.total;
    final todaySpend = (yesterdayMoneyState.total - moneyState.total);
    final lastSpend = (pmldMoneyState.total - yesterdayMoneyState.total);
    final todaySpendSum = (lastSpend + todaySpend);
    //---------------------------------// MoneyData

    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 14),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text('month start'),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              _utility.makeCurrencyDisplay(
                                monthStart.toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text('month spend'),
                        ),
                        Container(
                          width: 60,
                          alignment: Alignment.topRight,
                          child: Icon(
                            FontAwesomeIcons.caretRight,
                            color: Colors.greenAccent.withOpacity(0.6),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.greenAccent.withOpacity(0.3),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Text(
                              _utility.makeCurrencyDisplay(
                                todaySpendSum.toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'total',
                                style: TextStyle(color: Colors.yellowAccent),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text.rich(
                                TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: '①②③　',
                                      style: TextStyle(
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _utility.makeCurrencyDisplay(
                                        moneyState.total.toString(),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.yellowAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Bubble(
                      nip: BubbleNip.rightTop,
                      color: Colors.greenAccent.withOpacity(0.2),
                      nipWidth: 20,
                      child: DefaultTextStyle(
                        style: const TextStyle(fontSize: 12),
                        child: Column(
                          children: <Widget>[
                            Table(
                              children: [
                                TableRow(children: [
                                  const Text('today spend'),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      _utility.makeCurrencyDisplay(
                                        todaySpend.toString(),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                            Table(
                              children: [
                                TableRow(children: [
                                  const Text('last spend'),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      _utility.makeCurrencyDisplay(
                                        lastSpend.toString(),
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: IconButton(
                  color: Colors.greenAccent,
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    Get.to(() {
                      return SpendDetailPagingScreen(date: date);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispCurrency() {
    final exDate = date.split(' ');
    final moneyState = _ref.watch(moneyProvider(exDate[0]));

    var moneyList = [];
    moneyList.add(moneyState.yen_10000);
    moneyList.add(moneyState.yen_5000);
    moneyList.add(moneyState.yen_2000);
    moneyList.add(moneyState.yen_1000);
    moneyList.add(moneyState.yen_500);
    moneyList.add(moneyState.yen_100);
    moneyList.add(moneyState.yen_50);
    moneyList.add(moneyState.yen_10);
    moneyList.add(moneyState.yen_5);
    moneyList.add(moneyState.yen_1);

    moneyList.add(moneyState.bankA);
    moneyList.add(moneyState.bankB);
    moneyList.add(moneyState.bankC);
    moneyList.add(moneyState.bankD);
    moneyList.add(moneyState.bankE);

    moneyList.add(moneyState.peyA);
    moneyList.add(moneyState.peyB);
    moneyList.add(moneyState.peyC);
    moneyList.add(moneyState.peyD);
    moneyList.add(moneyState.peyE);

    _utility.makeTotal(moneyList.join('|'), 'one');

    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900]!.withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('currency'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(
                      alignment: Alignment.topRight,
                      child: const Text('①',
                          style: TextStyle(color: Colors.greenAccent)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.greenAccent.withOpacity(0.3),
                              width: 1),
                        ),
                      ),
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        _utility.makeCurrencyDisplay(
                          _utility.temochi.toString(),
                        ),
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ]),
                ],
              ),
              ___dispCurrencyData(),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget ___dispCurrencyData() {
    final exDate = date.split(' ');
    final moneyState = _ref.watch(moneyProvider(exDate[0]));

    List<String> _list = [];
    _list.add('10000:${moneyState.yen_10000}');
    _list.add('5000:${moneyState.yen_5000}');
    _list.add('2000:${moneyState.yen_2000}');
    _list.add('1000:${moneyState.yen_1000}');
    _list.add('500:${moneyState.yen_500}');
    _list.add('100:${moneyState.yen_100}');
    _list.add('50:${moneyState.yen_50}');
    _list.add('10:${moneyState.yen_10}');
    _list.add('5:${moneyState.yen_5}');
    _list.add('1:${moneyState.yen_1}');

    return ____dispEachData('currency', _list);
  }

  ///
  Widget ____dispEachData(String type, List<String> list) {
    var _bankNames = _utility.getBankName();

    List<Widget> _list = [];

    var _roopNum = ((list.length) / 2).round();

    for (var i = 0; i < _roopNum; i++) {
      var exData = (list[i]).split(':');
      var exData2 = (list[i + _roopNum]).split(':');

      var name1;
      var money1;
      var name2;
      var money2;

      switch (type) {
        case "currency":
          name1 = Text(exData[0]);
          money1 = Text(exData[1]);
          name2 = Text(exData2[0]);
          money2 = Text(exData2[1]);
          break;
        case "deposit":
          if (int.parse(exData[1]) > 0) {
            name1 = Text('${_bankNames[exData[0]]}');
            money1 = Text(_utility.makeCurrencyDisplay(exData[1]));
          } else {
            name1 = Text(exData[0], style: const TextStyle(color: Colors.grey));
            money1 = Text(_utility.makeCurrencyDisplay(exData[1]),
                style: const TextStyle(color: Colors.grey));
          }
          if (int.parse(exData2[1]) > 0) {
            name2 = Text('${_bankNames[exData2[0]]}');
            money2 = Text(_utility.makeCurrencyDisplay(exData2[1]));
          } else {
            name2 =
                Text(exData2[0], style: const TextStyle(color: Colors.grey));
            money2 = Text(_utility.makeCurrencyDisplay(exData2[1]),
                style: const TextStyle(color: Colors.grey));
          }
          break;
        case "e-money":
          if (int.parse(exData[1]) > 0) {
            name1 = Text('${_bankNames[exData[0]]}');
            money1 = Text(_utility.makeCurrencyDisplay(exData[1]));
          } else {
            name1 = Text(exData[0], style: const TextStyle(color: Colors.grey));
            money1 = Text(_utility.makeCurrencyDisplay(exData[1]),
                style: const TextStyle(color: Colors.grey));
          }
          if (int.parse(exData2[1]) > 0) {
            name2 = Text('${_bankNames[exData2[0]]}');
            money2 = Text(_utility.makeCurrencyDisplay(exData2[1]));
          } else {
            name2 =
                Text(exData2[0], style: const TextStyle(color: Colors.grey));
            money2 = Text(_utility.makeCurrencyDisplay(exData2[1]),
                style: const TextStyle(color: Colors.grey));
          }
          break;
      }

      _list.add(Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  name1,
                  Container(
                    alignment: Alignment.topRight,
                    child: money1,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  name2,
                  Container(
                    alignment: Alignment.topRight,
                    child: money2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
    }

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: _list,
        ),
      ),
    );
  }

  ///
  Widget _dispDeposit() {
    final exDate = date.split(' ');
    final moneyState = _ref.watch(moneyProvider(exDate[0]));

    List<String> _tot = [];
    _tot.add(moneyState.bankA.toString());
    _tot.add(moneyState.bankB.toString());
    _tot.add(moneyState.bankC.toString());
    _tot.add(moneyState.bankD.toString());
    _tot.add(moneyState.bankE.toString());

    var _depositTotal = 0;
    for (var i = 0; i < _tot.length; i++) {
      _depositTotal += int.parse(_tot[i]);
    }

    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900]!.withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('deposit'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(
                      alignment: Alignment.topRight,
                      child: const Text('②',
                          style: TextStyle(color: Colors.greenAccent)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.greenAccent.withOpacity(0.3),
                              width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 5),
                      alignment: Alignment.topRight,
                      child: Text(
                        _utility.makeCurrencyDisplay(_depositTotal.toString()),
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ]),
                ],
              ),
              ___dispDepositData(),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget ___dispDepositData() {
    final exDate = date.split(' ');
    final moneyState = _ref.watch(moneyProvider(exDate[0]));

    List<String> _list = [];
    _list.add('bank_a:${moneyState.bankA}');
    _list.add('bank_b:${moneyState.bankB}');
    _list.add('bank_c:${moneyState.bankC}');
    _list.add('bank_d:${moneyState.bankD}');
    _list.add('bank_e:${moneyState.bankE}');
    _list.add('bank_f:0');
    _list.add('bank_g:0');
    _list.add('bank_h:0');

    return ____dispEachData('deposit', _list);
  }

  ///
  Widget _dispEMoney() {
    final exDate = date.split(' ');
    final moneyState = _ref.watch(moneyProvider(exDate[0]));

    List<String> _tot = [];
    _tot.add(moneyState.peyA.toString());
    _tot.add(moneyState.peyB.toString());
    _tot.add(moneyState.peyC.toString());
    _tot.add(moneyState.peyD.toString());
    _tot.add(moneyState.peyE.toString());

    var _eMoneyTotal = 0;
    for (var i = 0; i < _tot.length; i++) {
      _eMoneyTotal += int.parse(_tot[i]);
    }

    return Column(
      children: <Widget>[
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            children: <Widget>[
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.green[900]!.withOpacity(0.5),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                          ),
                          child: Text('e-money'),
                        ),
                      ),
                    ),
                    Container(),
                    Container(
                      alignment: Alignment.topRight,
                      child: const Text('③',
                          style: TextStyle(color: Colors.greenAccent)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.greenAccent.withOpacity(0.3),
                              width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 5),
                      alignment: Alignment.topRight,
                      child: Text(
                        _utility.makeCurrencyDisplay(_eMoneyTotal.toString()),
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ]),
                ],
              ),
              ___dispEMoneyData(),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget ___dispEMoneyData() {
    final exDate = date.split(' ');
    final moneyState = _ref.watch(moneyProvider(exDate[0]));

    List<String> _list = [];
    _list.add('pay_a:${moneyState.peyA}');
    _list.add('pay_b:${moneyState.peyB}');
    _list.add('pay_c:${moneyState.peyC}');
    _list.add('pay_d:${moneyState.peyD}');
    _list.add('pay_e:${moneyState.peyE}');
    _list.add('pay_f:0');
    _list.add('pay_g:0');
    _list.add('pay_h:0');

    return ____dispEachData('e-money', _list);
  }

  ///
  Widget _dispToushiData() {
    final exDate = date.split(' ');

    //---------------------------------// GoldData
    final investmentGoldState = _ref.watch(investmentGoldProvider);

    final goldMap = {};
    goldMap['date'] = '';
    goldMap['pay'] = 0;
    goldMap['price'] = 0;
    goldMap['gain'] = 0;

    var dateList = [];

    for (var i = 0; i < investmentGoldState.length; i++) {
      if (investmentGoldState[i].goldTanka == '-') {
        continue;
      }

      dateList = [];
      dateList.add(investmentGoldState[i].year);
      dateList.add(investmentGoldState[i].month);
      dateList.add(investmentGoldState[i].day);

      goldMap['pay'] = investmentGoldState[i].payPrice ?? 0;
      goldMap['price'] = investmentGoldState[i].goldValue ?? 0;
    }
    goldMap['gain'] = (goldMap['price'] - goldMap['pay']);
    goldMap['date'] = dateList.join('-');
    //---------------------------------// GoldData

    //---------------------------------// StockData
    final investmentStockState = _ref.watch(investmentStockProvider);

    final stockMap = {};
    stockMap['date'] = '';
    stockMap['pay'] = 0;
    stockMap['price'] = 0;
    stockMap['gain'] = 0;

    for (var i = 0; i < investmentStockState.length; i++) {
      var exData = investmentStockState[i].toString().split(';');
      stockMap['date'] = exData[1];
      stockMap['pay'] += int.parse(exData[3].replaceAll(',', ''));
      stockMap['price'] += int.parse(exData[4].replaceAll(',', ''));
      stockMap['gain'] += int.parse(exData[5].replaceAll(',', ''));
    }
    //---------------------------------// StockData

    //---------------------------------// ShintakuData
    final investmentShintakuState = _ref.watch(investmentShintakuProvider);

    final shintakuMap = {};
    shintakuMap['date'] = '';
    shintakuMap['pay'] = 0;
    shintakuMap['price'] = 0;
    shintakuMap['gain'] = 0;

    for (var i = 0; i < investmentShintakuState.length; i++) {
      var exData = investmentShintakuState[i].toString().split(';');
      shintakuMap['date'] = exData[1];
      shintakuMap['pay'] += int.parse(exData[3].replaceAll(',', ''));
      shintakuMap['price'] += int.parse(exData[4].replaceAll(',', ''));
    }
    shintakuMap['gain'] = (shintakuMap['price'] - shintakuMap['pay']);
    //---------------------------------// ShintakuData

    return Container(
      decoration: BoxDecoration(
        color: Colors.yellowAccent.withOpacity(0.2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Column(
              children: <Widget>[
                Table(
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.green[900]!.withOpacity(0.5),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            child: Text('investment'),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Text(
                          '(IN)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        child: const Text(
                          '(OUT)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() {
                                return GoldDisplayScreen(
                                  closeMethod: 'single',
                                );
                              });
                            },
                            child: const Icon(
                              Icons.label,
                              color: Colors.greenAccent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Get.to(() {
                                return InvestmentTabScreen();
                              });
                            },
                            child: const Icon(
                              Icons.comment,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 50,
                              child: Text('GOLD'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.topRight,
                              child: Text(goldMap['pay'].toString()),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.topRight,
                              child: Text(goldMap['price'].toString()),
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.topRight,
                              child: Text(goldMap['gain'].toString()),
                            ),
                            Container(
                              width: 30,
                              alignment: Alignment.topRight,
                              child: Icon(Icons.star,
                                  size: 16,
                                  color: (goldMap['date'] == exDate[0])
                                      ? Colors.yellowAccent
                                      : Colors.grey.withOpacity(0.3)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 50,
                              child: Text('STOCK'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.topRight,
                              child: Text(stockMap['pay'].toString()),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.topRight,
                              child: Text(stockMap['price'].toString()),
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.topRight,
                              child: Text(stockMap['gain'].toString()),
                            ),
                            Container(
                              width: 30,
                              alignment: Alignment.topRight,
                              child: Icon(Icons.star,
                                  size: 16,
                                  color: (stockMap['date'] == exDate[0])
                                      ? Colors.yellowAccent
                                      : Colors.grey.withOpacity(0.3)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 50,
                              child: Text('ETF'),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.topRight,
                              child: Text(shintakuMap['pay'].toString()),
                            ),
                            Container(
                              width: 70,
                              alignment: Alignment.topRight,
                              child: Text(shintakuMap['price'].toString()),
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.topRight,
                              child: Text(shintakuMap['gain'].toString()),
                            ),
                            Container(
                              width: 30,
                              alignment: Alignment.topRight,
                              child: Icon(Icons.star,
                                  size: 16,
                                  color: (shintakuMap['date'] == exDate[0])
                                      ? Colors.yellowAccent
                                      : Colors.grey.withOpacity(0.3)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------// 画面遷移

  /// 画面遷移（DetailScreen）
  void _goDetailScreen({required String monthDate}) async {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (_context) {
          return DetailScreen(date: monthDate);
        },
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////

class DetailRight extends ConsumerWidget {
  DetailRight({Key? key, required this.date}) : super(key: key);

  final String date;

  List<List<dynamic>> _monthDays = [];

  final AutoScrollController _controller = AutoScrollController();

  late BuildContext _context;
  late WidgetRef _ref;

  final Utility _utility = Utility();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    //------------------------------------
    _monthDays = [];

    final exDate = date.split(' ');
    final exOneDate = exDate[0].split('-');

    final monthEnd =
        DateTime(int.parse(exOneDate[0]), int.parse(exOneDate[1]) + 1, 0);

    for (var i = 1;
        i < int.parse(monthEnd.toString().split(' ')[0].split('-')[2]);
        i++) {
      _monthDays.add([
        i,
        i.toString().padLeft(2, '0'),
      ]);
    }

    _controller.scrollToIndex(
      int.parse(exOneDate[2]),
      preferPosition: AutoScrollPosition.begin,
    );
    //------------------------------------

    return SizedBox(
      width: 60,
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.only(top: 5),
            color: Colors.black.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.greenAccent,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _goDetailScreen(monthDate: date);
                  },
                  color: Colors.greenAccent,
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _showDatepicker(context: context);
                  },
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: Colors.black.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(exOneDate[0]),
                  Text(exOneDate[1]),
                ],
              ),
            ),
          ),
          Expanded(
            child: _monthDaysList(date: date),
          ),
        ],
      ),
    );
  }

  /// デートピッカー表示
  void _showDatepicker({required BuildContext context}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 6),
      locale: const Locale('ja'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            backgroundColor: Colors.black.withOpacity(0.1),
            scaffoldBackgroundColor: Colors.black.withOpacity(0.1),
            canvasColor: Colors.black.withOpacity(0.1),
            cardColor: Colors.black.withOpacity(0.1),
            cursorColor: Colors.white,
            buttonColor: Colors.black.withOpacity(0.1),
            bottomAppBarColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            accentColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            textSelectionColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
            selectedRowColor: Colors.black.withOpacity(0.1),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      _goDetailScreen(monthDate: selectedDate.toString());
    }
  }

  /// リスト表示
  Widget _monthDaysList({required String date}) {
    final exDate = date.split(' ');
    final exOneDate = exDate[0].split('-');

    //----------------//
    final holidayState = _ref.watch(holidayProvider);
    Map<String, dynamic> _holidayList = {};
    for (var i = 0; i < holidayState.length; i++) {
      _holidayList[holidayState[i]] = '';
    }
    //----------------//

    return MediaQuery.removePadding(
      removeTop: true,
      context: _context,
      child: ListView(
        scrollDirection: Axis.vertical,
        controller: _controller,
        children: _monthDays.map<Widget>((data) {
          var _bgColor = _utility.getBgColor(
              '${exOneDate[0]}-${exOneDate[1]}-${data[1]}', _holidayList);

          if (data[1] == exOneDate[2]) {
            _bgColor = Colors.yellowAccent.withOpacity(0.3);
          }

          return (data[0] == 0)
              ? Container()
              : Card(
                  color: _bgColor,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    onTap: () {
                      _goMonthDay(position: data[0]);
                    },
                    title: AutoScrollTag(
                      index: data[0],
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${data[1]}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      key: ValueKey(data[0]),
                      controller: _controller,
                    ),
                  ),
                );
        }).toList(),
      ),
    );
  }

  //-----------------------------// 画面遷移

  /// 画面遷移（月内指定日）
  void _goMonthDay({required int position}) {
    final exDate = date.split(' ');
    final exOneDate = exDate[0].split('-');

    var dateList = [];
    dateList.add(exOneDate[0]);
    dateList.add(exOneDate[1]);
    dateList.add(_monthDays[position - 1][0].toString().padLeft(2, '0'));

    _goDetailScreen(monthDate: dateList.join('-'));
  }

  /// 画面遷移（DetailScreen）
  void _goDetailScreen({required String monthDate}) async {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (_context) {
          return DetailScreen(date: monthDate);
        },
      ),
    );
  }
}
