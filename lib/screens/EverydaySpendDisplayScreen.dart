// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../riverpod/everyday_spend/everyday_spend_view_model.dart';
import '../riverpod/view_model/holiday_view_model.dart';
import '../utilities/CustomShapeClipper.dart';
import '../utilities/utility.dart';

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
                                child:
                                    Text('${everydaySpendState[i].step} stp.'),
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
                                child: Text(
                                    '${everydaySpendState[i].distance} m.'),
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
  Widget _dispRecord({required String record, required int daySpend}) {
    List<Widget> _list = [];

    var exRecord = record.split('/');

    var sum = 0;
    for (var i = 0; i < exRecord.length; i++) {
      var exOneRecord = exRecord[i].split('|');

      _list.add(
        Row(
          children: [
            Container(width: 50),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: Text(exOneRecord[0])),
                  Expanded(
                    flex: 2,
                    child: Text(exOneRecord[1]),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Text(_utility.makeCurrencyDisplay(exOneRecord[2])),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      sum += int.parse(exOneRecord[2]);
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
