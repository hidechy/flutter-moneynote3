// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class CreditInfoSetScreen extends StatefulWidget {
  final DateTime date;
  final String record;

  const CreditInfoSetScreen(
      {Key? key, required this.date, required this.record})
      : super(key: key);

  @override
  _CreditInfoSetScreenState createState() => _CreditInfoSetScreenState();
}

class _CreditInfoSetScreenState extends State<CreditInfoSetScreen> {
  final Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<dynamic> _creditDateData = [];
  String _dispPrice = "";
  String _dispCard = "";

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(widget.date.toString(), 0);
    var getDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    //----------------------------------------//
    var exRecord = (widget.record).split('|');
    _dispPrice = exRecord[2];

    await apiData.getListOfCreditDateData(
      date: getDate,
      price: int.parse(_dispPrice),
    );
    _creditDateData = apiData.ListOfCreditDateData['data'];
    apiData.ListOfCreditDateData = {};
    //----------------------------------------//

    _dispCard = _creditDateData[0]['card'];

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date.toString(), 0);
    var dispDate = "${_utility.year}-${_utility.month}-${_utility.day}";

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: 150,
                child: Column(
                  children: [
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
                    Text(_dispCard),
                    const Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _dispCreditList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _dispCreditList() {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView.separated(
        itemBuilder: (context, index) => _listItem(index: index),
        separatorBuilder: (context, index) => const SizedBox(height: 0),
        itemCount: _creditDateData.length,
      ),
    );
  }

  ///
  Widget _listItem({required int index}) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      child: ListTile(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.check_box_outline_blank,
                color: Color(0xFF2e2e2e),
              ),
            ),
            Expanded(
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_creditDateData[index]['date']),
                    Text(_creditDateData[index]['item']),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(_utility.makeCurrencyDisplay(
                          _creditDateData[index]['price'])),
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
}
