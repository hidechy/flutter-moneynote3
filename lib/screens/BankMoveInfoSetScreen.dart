// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

class BankMoveInfoSetScreen extends StatefulWidget {
  final DateTime date;
  final String record;

  const BankMoveInfoSetScreen(
      {Key? key, required this.date, required this.record})
      : super(key: key);

  @override
  _BankMoveInfoSetScreenState createState() => _BankMoveInfoSetScreenState();
}

///
class _BankMoveInfoSetScreenState extends State<BankMoveInfoSetScreen> {
  final Utility _utility = Utility();

  String _dialogSelectedDate = "";
  String _dispPrice = "";
  String _chipValue = 'bank_a';

  String _pickupDate = "";

  ///
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date.toString(), 0);
    var dispDate = "${_utility.year}-${_utility.month}-${_utility.day}";
    _pickupDate = dispDate;

    var exRecord = (widget.record).split('|');
    _dispPrice = exRecord[2];

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
          Card(
            color: Colors.black.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.greenAccent,
                  ),
                ),
                Text(dispDate),
                Text(
                  _utility.makeCurrencyDisplay(_dispPrice),
                  style: const TextStyle(fontSize: 30),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _showDatepicker(context: context),
                            color: Colors.blueAccent,
                          ),
                          Text(_dialogSelectedDate),
                        ],
                      ),
                      _makeBankChips(),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      _setBankMoveInfo();
                    },
                    child: const Text('click'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
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
      _utility.makeYMDYData(selectedDate.toString(), 0);
      _dialogSelectedDate =
          '${_utility.year}-${_utility.month}-${_utility.day}';
      setState(() {});
    }
  }

  ///
  Widget _makeBankChips() {
    var _bankNames = _utility.getBankName();

    List<Widget> _list = [];
    _bankNames.forEach(
      (key, value) {
        var exKey = (key).split('_');

        if (exKey[0] != "pay") {
          _list.add(
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.greenAccent.withOpacity(0.3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  (key == "bank_d")
                      ? ChoiceChip(
                          label: Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Text(
                              key,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          selected: _chipValue == key,
                        )
                      : ChoiceChip(
                          backgroundColor: Colors.black.withOpacity(0.1),
                          selectedColor: Colors.greenAccent.withOpacity(0.5),
                          label: Container(
                            alignment: Alignment.center,
                            width: 60,
                            child: Text(
                              key,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          selected: _chipValue == key,
                          onSelected: (bool isSelected) {
                            _chipValue = key;
                            setState(() {});
                          },
                        ),
                  const SizedBox(width: 30),
                  Text(value),
                ],
              ),
            ),
          );
        }
      },
    );

    return Column(
      children: _list,
    );
  }

  ///
  void _setBankMoveInfo() async {
    Map<String, dynamic> _uploadData = {};
    _uploadData['price'] = _dispPrice;
    _uploadData['from_bank'] = "bank_d";
    _uploadData['from_date'] = _pickupDate;
    _uploadData['to_bank'] = _chipValue;
    _uploadData['to_date'] = _dialogSelectedDate;

    String url = "http://toyohide.work/BrainLog/api/setBankMove";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode(_uploadData);
    await post(Uri.parse(url), headers: headers, body: body);

    Fluttertoast.showToast(
      msg: "登録が完了しました",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );

    Vibration.vibrate(pattern: [500, 1000, 500, 2000]);

    Navigator.pop(context);
  }
}
