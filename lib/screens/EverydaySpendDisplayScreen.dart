// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../riverpod/everyday_spend/everyday_spend_view_model.dart';
import '../riverpod/view_model/holiday_view_model.dart';

import '../utilities/CustomShapeClipper.dart';
import '../utilities/utility.dart';

import 'BankMoveInfoSetScreen.dart';

class EverydaySpendDisplayScreen extends ConsumerWidget {
  EverydaySpendDisplayScreen({Key? key, required this.date}) : super(key: key);

  final String date;

  final Utility _utility = Utility();

  late WidgetRef _ref;
  late BuildContext _context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    final exDate = date.split('-');

    DateTime prevMonth =
        DateTime(int.parse(exDate[0]), int.parse(exDate[1]) - 1, 1);
    DateTime nextMonth =
        DateTime(int.parse(exDate[0]), int.parse(exDate[1]) + 1, 1);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(),
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
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2, color: Colors.white),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close),
                    ),
                    Text('${exDate[0]}-${exDate[1]}'),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => (prevMonth.toString() == '2019-12')
                              ? null
                              : _goEverydaySpendDisplayScreen(
                                  date: prevMonth.toString(),
                                ),
                          child: const Icon(Icons.skip_previous),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => _goEverydaySpendDisplayScreen(
                              date: nextMonth.toString()),
                          child: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(child: _everydaySpendList()),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _everydaySpendList() {
    List<Widget> _list = [];

    //----------------//
    final holidayState = _ref.watch(holidayProvider);
    Map<String, dynamic> _holidayList = {};
    for (var i = 0; i < holidayState.length; i++) {
      _holidayList[holidayState[i]] = '';
    }
    //----------------//

    final everydaySpendState = _ref.watch(everydaySpendProvider(date));

    for (var i = 0; i < everydaySpendState.length; i++) {
      var exOneDate = everydaySpendState[i].date.split('-');

      _utility.makeYMDYData(everydaySpendState[i].date, 0);

      _list.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Container(
            decoration: BoxDecoration(
              color:
                  _utility.getBgColor(everydaySpendState[i].date, _holidayList),
            ),
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${exOneDate[2]}（${_utility.youbiStr}）'),
                          Text(
                            _utility.makeCurrencyDisplay(
                                everydaySpendState[i].spend.toString()),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Icon(
                                  FontAwesomeIcons.shoePrints,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 12,
                                ),
                              ),
                              Expanded(
                                child: (everydaySpendState[i].step != '')
                                    ? Text(
                                        '${_utility.makeCurrencyDisplay(everydaySpendState[i].step)} stp.')
                                    : const Text(''),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Icon(
                                  FontAwesomeIcons.road,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 12,
                                ),
                              ),
                              Expanded(
                                child: (everydaySpendState[i].distance != '')
                                    ? Text(
                                        '${_utility.makeCurrencyDisplay(everydaySpendState[i].distance)} m.')
                                    : const Text(''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Colors.white.withOpacity(0.3),
                ),
                _dispRecord(
                  record: everydaySpendState[i].record,
                  daySpend: everydaySpendState[i].spend,
                  date: everydaySpendState[i].date,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _list,
      ),
    );
  }

  ///
  Widget _dispRecord(
      {required String record, required int daySpend, required String date}) {
    List<Widget> _list = [];

    var exRecord = record.split('/');

    var sum = 0;
    for (var i = 0; i < exRecord.length; i++) {
      var exOneRecord = exRecord[i].split('|');

      var match1 = RegExp("rakuten").firstMatch(exOneRecord[1]);
      var match2 = RegExp("uc card").firstMatch(exOneRecord[1]);
      var match3 = RegExp("sumitomo").firstMatch(exOneRecord[1]);
      var match4 = RegExp("amex").firstMatch(exOneRecord[1]);

      _list.add(
        Row(
          children: [
            Container(width: 50),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
                child: (match1 != null ||
                        match2 != null ||
                        match3 != null ||
                        match4 != null)
                    ? DefaultTextStyle(
                        style: const TextStyle(color: Colors.lightBlueAccent),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: Text(exOneRecord[1])),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  _utility.makeCurrencyDisplay(exOneRecord[2]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(child: Text(exOneRecord[0])),
                          (exOneRecord[1] == "Bank_Departure (D)")
                              ? Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(exOneRecord[1]),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => BankMoveInfoSetScreen(
                                              date: DateTime.parse(date),
                                              record: exRecord[i],
                                            ),
                                          );
                                        },
                                        child: const Icon(FontAwesomeIcons.building),
                                      ),
                                    ],
                                  ))
                              : Expanded(
                                  flex: 2,
                                  child: Text(exOneRecord[1]),
                                ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                _utility.makeCurrencyDisplay(exOneRecord[2]),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );

      if (match1 != null ||
          match2 != null ||
          match3 != null ||
          match4 != null) {
      } else {
        sum += int.parse(exOneRecord[2]);
      }
    }

    if (sum != daySpend) {
      var dayDiff = (sum > daySpend)
          ? ((sum - daySpend) * -1).toString()
          : (daySpend - sum).toString();

      _list.add(
        Row(
          children: [
            Container(width: 50),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                ),
                child: Row(
                  children: [
                    const Expanded(child: Text('-')),
                    const Expanded(flex: 2, child: Text('差額')),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(_utility.makeCurrencyDisplay(dayDiff)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(children: _list);
  }

  ///////////////////////////////////////////////////////////////////// 画面遷移

  void _goEverydaySpendDisplayScreen({required String date}) {
    Navigator.pushReplacement(
      _context,
      MaterialPageRoute(
        builder: (context) => EverydaySpendDisplayScreen(
          date: date,
        ),
      ),
    );
  }
}
