// ignore_for_file: file_names, must_be_immutable, unused_field, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class BankInputScreen extends StatefulWidget {
  String date;

  BankInputScreen({Key? key, required this.date}) : super(key: key);

  @override
  _BankInputScreenState createState() => _BankInputScreenState();
}

class _BankInputScreenState extends State<BankInputScreen> {
  final Utility _utility = Utility();
  ApiData apiData = ApiData();

  String _dialogSelectedDate = "";

  String _text = '';
  final TextEditingController _teContPrice = TextEditingController();

  final Map _dispFlag = {};

  String _chipValue = 'bank_a';

  List<Map<dynamic, dynamic>> _bankData = [];

  String _lastRecordDate = "";

  int maxNo = 0;

  final Map<String, dynamic> _holidayList = {};

  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  String _lastUpdateDate = "";
  int _lastUpdateValue = 0;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(widget.date, 0);

    _dialogSelectedDate = '${_utility.year}-${_utility.month}-01';

    _teContPrice.text = '0';

    _getBankValue();
  }

  /// 表示データ作成
  void _getBankValue() async {
    await apiData.getMoneyOfAll();
    if (apiData.MoneyOfAll != null) {
      int _value = 0;
      int _prevValue = 0;
      var _addFlag = false;

      _bankData = [];

      for (var i = 0; i < apiData.MoneyOfAll['data'].length; i++) {
        var exData = (apiData.MoneyOfAll['data'][i]).split('|');

        switch (_chipValue) {
          case 'bank_a':
            _value = int.parse(exData[12]);
            break;
          case 'bank_b':
            _value = int.parse(exData[13]);
            break;
          case 'bank_c':
            _value = int.parse(exData[14]);
            break;
          case 'bank_d':
            _value = int.parse(exData[15]);
            break;
          case 'bank_e':
            _value = int.parse(exData[16]);
            break;

          case 'pay_a':
            _value = int.parse(exData[17]);
            break;
          case 'pay_b':
            _value = int.parse(exData[18]);
            break;
          case 'pay_c':
            _value = int.parse(exData[19]);
            break;
          case 'pay_d':
            _value = int.parse(exData[20]);
            break;
          case 'pay_e':
            _value = int.parse(exData[21]);
            break;
        }

        _utility.makeYMDYData(exData[0], 0);

        var _diffMark = 0;
        var _diffPrice = 0;
        var _diffShirushi = '0';
        if (_prevValue != _value) {
          _diffMark = 1;
          _diffPrice = (_prevValue - _value) * -1;
          _diffShirushi = (_value > _prevValue) ? '1' : '0';
        }

        if (_diffMark == 1) {
          _lastUpdateDate = exData[0];
          _lastUpdateValue = _value;
        }

        var _map = {};
        _map['date'] = exData[0];
        _map['value'] = _value.toString();
        _map['diffMark'] = _diffMark.toString();
        _map['youbiNo'] = _utility.youbiNo.toString();
        _map['diffPrice'] = _diffPrice.toString();
        _map['diffShirushi'] = _diffShirushi;

        if (_value > 0) {
          _addFlag = true;
        }

        if (_addFlag) {
          _bankData.add(_map);
        }

        _prevValue = _value;

        _lastRecordDate = exData[0];
      }
    }
    apiData.MoneyOfAll = {};

    maxNo = _bankData.length;

    //----------------------------//
    await apiData.getHolidayOfAll();
    if (apiData.HolidayOfAll != null) {
      for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
        _holidayList[apiData.HolidayOfAll['data'][i]] = '';
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('銀行預金'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward),
          color: Colors.greenAccent,
          onPressed: () => _scroll(),
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
          Column(
            children: [
              _dispInputParts(context),
              _dispLastValueBox(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _bankList(),
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        width: 100,
                        child: _makeBankChips(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void _scroll() {
    _itemScrollController.scrollTo(
      index: maxNo,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  ///
  Widget _makeBankChips() {
    var _bankNames = _utility.getBankName();

    var _dividerDisp = false;

    List<Widget> _list = [];
    _bankNames.forEach(
      (key, value) {
        var exKey = (key).split('_');
        if (_dividerDisp == false) {
          if (exKey[0] == "pay") {
            _list.add(
              const Divider(
                color: Colors.white,
                height: 10,
              ),
            );
            _dividerDisp = true;
          }
        }

        _list.add(
          ChoiceChip(
            backgroundColor: Colors.black.withOpacity(0.1),
            selectedColor: Colors.greenAccent.withOpacity(0.5),
            label: Container(
              alignment: Alignment.center,
              width: 60,
              child: Text(
                '$value',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
            selected: _chipValue == key,
            onSelected: (bool isSelected) {
              _chipValue = key;
              _getBankValue();
            },
          ),
        );
      },
    );

    return Column(
      children: _list,
    );
  }

  ///
  Widget _bankList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: const SlidableDrawerActionPane(),
          child: _listItem(position: index),
          secondaryActions: <Widget>[
            IconSlideAction(
              color: _getBgColor(_bankData[index]['date']),
              foregroundColor: Colors.blueAccent,
              icon: Icons.date_range,
              onTap: () => _changeSelectedDate(date: _bankData[index]['date']),
            ),
          ],
        );
      },
      itemCount: _bankData.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    return Card(
      color: _getBgColor(_bankData[position]['date']),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: _getLeading(mark: _bankData[position]['diffMark']),
        trailing: _getTrailing(mark: _bankData[position]['diffShirushi']),
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Table(
            children: [
              TableRow(
                children: [
                  Text('${_bankData[position]['date']}'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_utility
                          .makeCurrencyDisplay(_bankData[position]['value'])),
                      Text(_utility.makeCurrencyDisplay(
                          _bankData[position]['diffPrice'])),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// リーディングマーク取得
  Widget _getLeading({required String mark}) {
    if (int.parse(mark) == 1) {
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
  Widget _getTrailing({mark}) {
    if (int.parse(mark) == 1) {
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

  /// 背景色取得
  Color _getBgColor(String date) {
    _utility.makeYMDYData(date, 0);

    Color _color = Colors.black.withOpacity(0.3);

    switch (_utility.youbiNo) {
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

  ///
  void _changeSelectedDate({required String date}) {
    _dialogSelectedDate = date;
    setState(() {});
  }

  ///
  Widget _dispInputParts(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.black.withOpacity(0.3),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  tooltip: 'jump',
                  onPressed: () => _showDatepicker(context: context),
                  color: Colors.blueAccent,
                ),
                Text(_dialogSelectedDate),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(fontSize: 13),
                controller: _teContPrice,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                onChanged: (value) {
                  setState(
                    () {
                      _text = value;
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.input),
              tooltip: 'input',
              onPressed: () => _updateRecord(context: context),
              color: Colors.greenAccent,
            ),
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
            // ignore: deprecated_member_use
            cursorColor: Colors.white,
            bottomAppBarColor: Colors.black.withOpacity(0.1),
            dividerColor: Colors.indigo,
            primaryColor: Colors.black.withOpacity(0.1),
            secondaryHeaderColor: Colors.black.withOpacity(0.1),
            dialogBackgroundColor: Colors.black.withOpacity(0.1),
            primaryColorDark: Colors.black.withOpacity(0.1),
            // ignore: deprecated_member_use
            textSelectionColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.1),
            selectedRowColor: Colors.black.withOpacity(0.1),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.black.withOpacity(0.1)),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      _utility.makeYMDYData(selectedDate.toString(), 0);
      _dialogSelectedDate =
          '${_utility.year}-${_utility.month}-${_utility.day}';
      setState(() {});
    }
  }

  void _updateRecord({required BuildContext context}) {
    /*
    print(_dialogSelectedDate);
    print(_chipValue);
    print(_text);

    I/flutter (10656): 2021-10-15
    I/flutter (10656): bank_e
    I/flutter (10656): 100000

      _text = '';
  _teContPrice.text = '';

    */
  }

  ///
  Widget _dispLastValueBox() {
    var _bankNames = _utility.getBankName();

    return Container(
      decoration: BoxDecoration(color: Colors.yellowAccent.withOpacity(0.3)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      child: Table(
        children: [
          TableRow(children: [
            Text('${_bankNames[_chipValue]}'),
            Container(
              alignment: Alignment.topRight,
              child: Text(
                  _utility.makeCurrencyDisplay(_lastUpdateValue.toString())),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text(_lastUpdateDate),
            ),
          ]),
        ],
      ),
    );
  }
}
