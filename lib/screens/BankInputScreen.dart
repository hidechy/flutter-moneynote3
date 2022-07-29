// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moneynote5/riverpod/bank_update/bank_update_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uuid/uuid.dart';

import '../riverpod/bank_input/bank_input_state.dart';
import '../riverpod/bank_input/bank_input_view_model.dart';
import '../riverpod/bank_update/bank_update_view_model.dart';
import '../riverpod/view_model/holiday_view_model.dart';

import '../utilities/CustomShapeClipper.dart';
import '../utilities/utility.dart';

class BankInputScreen extends ConsumerWidget {
  BankInputScreen({Key? key, required this.date}) : super(key: key);

  final String date;

  final List<String> _banks = [
    'bank_a',
    'bank_b',
    'bank_c',
    'bank_d',
    'bank_e',
    'pay_a',
    'pay_b',
    'pay_c',
    'pay_d',
    'pay_e',
  ];

  final Utility _utility = Utility();

  late WidgetRef _ref;

  final ScrollController _controller = ScrollController();

  var uuid = const Uuid();

  final TextEditingController updatePriceTextController =
      TextEditingController();

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;
    _context = context;

    var bankState = ref.watch(bankProvider);
    if (bankState == "") bankState = 'bank_a';

    final bankInputState = ref.watch(bankInputProvider(bankState));

    var lastBankInputState = (bankInputState.isNotEmpty)
        ? bankInputState[bankInputState.length - 1]
        : const BankInputState(
            date: '',
            price: 0,
            diff: 0,
            changeFlag: false,
            upFlag: false,
            lastChangeDate: '',
          );

    final bankNames = _utility.getBankName();

    Size size = MediaQuery.of(context).size;

    var bankUpdateState = ref.watch(bankUpdateProvider);
    if (bankUpdateState == "") bankUpdateState = '-';

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
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(bankNames[bankState]),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(lastBankInputState.lastChangeDate),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          _utility.makeCurrencyDisplay(
                              lastBankInputState.price.toString()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          border: Border.all(
                            color: Colors.greenAccent.withOpacity(0.5),
                            width: 2,
                          )),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showDatepicker(context: context),
                                child: const Icon(Icons.calendar_today),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 100,
                                child: Text(bankUpdateState),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(bankState),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(fontSize: 13),
                                  controller: updatePriceTextController,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              const SizedBox(width: 30),
                              IconButton(
                                onPressed: () => _bankMoneyUpdate(),
                                icon: const Icon(
                                  Icons.cloud_upload,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return BankInputGraphScreen(
                                  data: bankInputState,
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.graphic_eq),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _bankNameList(bank: bankState, bankNames: bankNames),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void _bankMoneyUpdate() async {
    var bankUpdateState = _ref.watch(bankUpdateProvider);
    var price = updatePriceTextController.text;

    if (bankUpdateState == "" || price == "") {
      Fluttertoast.showToast(
        msg: "日付、または金額が未入力",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    }

    var bankState = _ref.watch(bankProvider);
    if (bankState == "") bankState = 'bank_a';

    _ref.watch(
      bankMoneyUpdateProvider(
        BankUpdateState(
          date: bankUpdateState,
          bank: bankState,
          price: int.parse(price),
        ),
      ),
    );

    Navigator.pop(_context);
    Navigator.pop(_context);
  }

  ///
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
            bottomAppBarColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
            selectedRowColor: Colors.black.withOpacity(0.1),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      final exSelectedDate = selectedDate.toString().split(' ');
      _ref.watch(bankUpdateProvider.notifier).setDate(date: exSelectedDate[0]);
    }
  }

  ///
  Widget _bankNameList(
      {required String bank, required Map<dynamic, dynamic> bankNames}) {
    final bankState = _ref.watch(bankProvider);

    return Expanded(
      child: Row(
        children: [
          Expanded(child: _bankList(bank: bank)),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: const Duration(seconds: 5),
                          curve: Curves.bounceIn,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        child: const Icon(Icons.arrow_downward),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _controller.animateTo(
                          _controller.position.minScrollExtent,
                          duration: const Duration(seconds: 5),
                          curve: Curves.bounceIn,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        child: const Icon(Icons.arrow_upward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.white, thickness: 2),
                const SizedBox(height: 10),
                Column(
                  children: _banks.map(
                    (bank) {
                      return GestureDetector(
                        onTap: () {
                          _ref.watch(bankProvider.notifier).setBank(bank: bank);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: (bankState == bank)
                                    ? Colors.yellowAccent.withOpacity(0.3)
                                    : Colors.greenAccent.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(bottom: 10),
                              alignment: Alignment.center,
                              child: Text(
                                bankNames[bank],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            if (bank == 'bank_e')
                              Column(
                                children: const [
                                  SizedBox(height: 10),
                                  Divider(color: Colors.white, thickness: 2),
                                  SizedBox(height: 10),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _bankList({required String bank}) {
    final bankInputState = _ref.watch(bankInputProvider(bank));

    //----------------//
    final holidayState = _ref.watch(holidayProvider);
    Map<String, dynamic> _holidayList = {};
    for (var i = 0; i < holidayState.length; i++) {
      _holidayList[holidayState[i]] = '';
    }
    //----------------//

    List<Widget> _list = [];

    for (final data in bankInputState) {
      var exOneDate = data.date.split('-');

      _list.add(
        Card(
          color: _utility.getBgColor(data.date, _holidayList),
          child: ListTile(
            leading: _getLeading(mark: data.changeFlag),
            trailing: _getTrailing(mark: data.upFlag),
            title: Row(
              children: [
                Expanded(
                    child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exOneDate[0]),
                      Text('${exOneDate[1]}-${exOneDate[2]}'),
                    ],
                  ),
                )),
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_utility
                            .makeCurrencyDisplay(data.price.toString())),
                        Text(
                            _utility.makeCurrencyDisplay(data.diff.toString())),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: _controller,
      key: PageStorageKey(uuid.v1()),
      child: Column(children: _list),
    );
  }

  /// リーディングマーク取得
  Widget _getLeading({required bool mark}) {
    if (mark) {
      return const Icon(
        Icons.refresh,
        color: Colors.greenAccent,
      );
    } else {
      return const Icon(
        Icons.check_box_outline_blank,
        color: Color(0xFF2e2e2e),
      );
    }
  }

  ///
  Widget _getTrailing({required bool mark}) {
    if (mark) {
      return const Icon(
        FontAwesomeIcons.caretSquareUp,
        color: Colors.greenAccent,
      );
    } else {
      return const Icon(
        Icons.check_box_outline_blank,
        color: Color(0xFF2e2e2e),
      );
    }
  }
}

/////////////////////////////////////////////////////////////

class BankInputGraphScreen extends StatelessWidget {
  BankInputGraphScreen({Key? key, required this.data}) : super(key: key);

  final List<BankInputState> data;

  final Utility _utility = Utility();

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        child: Container(
          width: size.width * 3,
          height: size.height - 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          child: Column(
            children: [_makeGraph()],
          ),
        ),
      ),
    );
  }

  ///
  Widget _makeGraph() {
    List<ChartData> _list = [];

    for (var i = 0; i < data.length; i++) {
      _utility.makeYMDYData(data[i].date, 0);

      _list.add(
        ChartData(
          x: DateTime(
            int.parse(_utility.year),
            int.parse(_utility.month),
            int.parse(_utility.day),
          ),
          val: data[i].price,
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              series: <ChartSeries>[
                LineSeries<ChartData, DateTime>(
                  color: Colors.yellowAccent,
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.val,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
              primaryXAxis: DateTimeAxis(
                majorGridLines: const MajorGridLines(width: 0),
                dateFormat: DateFormat.yMMM(),
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(
                  width: 2,
                  color: Colors.white30,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white)),
              color: Colors.white.withOpacity(0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent.withOpacity(0.3),
                  ),
                  onPressed: () {
                    _controller.jumpTo(_controller.position.maxScrollExtent);
                  },
                  child: Text('jump'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent.withOpacity(0.3),
                  ),
                  onPressed: () {
                    _controller.jumpTo(_controller.position.minScrollExtent);
                  },
                  child: Text('back'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class ChartData {
  final DateTime x;
  final num val;

  ChartData({required this.x, required this.val});
}
