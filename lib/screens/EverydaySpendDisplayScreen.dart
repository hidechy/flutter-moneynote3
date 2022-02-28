// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'BankMoveInfoSetScreen.dart';
import 'CreditInfoSetScreen.dart';

class EverydaySpendDisplayScreen extends StatefulWidget {
  final String date;

  const EverydaySpendDisplayScreen({Key? key, required this.date})
      : super(key: key);

  @override
  _EverydaySpendDisplayScreenState createState() =>
      _EverydaySpendDisplayScreenState();
}

class _EverydaySpendDisplayScreenState
    extends State<EverydaySpendDisplayScreen> {
  final Utility _utility = Utility();
  ApiData apiData = ApiData();

  List everydaySpendData = [];

  final Map<String, dynamic> _holidayList = {};

  DateTime _prevMonth = DateTime.now();
  DateTime _nextMonth = DateTime.now();

  String dispYM = "";

  final List<String> _selectedList = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    if (widget.date != "") {
      _utility.makeYMDYData(widget.date, 0);
    } else {
      _utility.makeYMDYData(DateTime.now().toString(), 0);
    }

    var getDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    dispYM = "${_utility.year}-${_utility.month}";

    _prevMonth =
        DateTime(int.parse(_utility.year), int.parse(_utility.month) - 1, 1);
    _nextMonth =
        DateTime(int.parse(_utility.year), int.parse(_utility.month) + 1, 1);

    await apiData.getListOfEverydaySpendData(date: getDate);
    everydaySpendData = apiData.ListOfEverydaySpendData;
    apiData.ListOfEverydaySpendData = [];

    ///////////////////////////////////
    for (var i = 0; i < everydaySpendData.length; i++) {
      var exDate = (everydaySpendData[i].date.toString()).split(' ');
      var record = everydaySpendData[i].record;
      var exValue = (record).split('|');
      if (exValue[3] == "o") {
        _selectedList.add("${exDate[0]}|$record");
      }
    }
    ///////////////////////////////////

    //----------------------------//
    await apiData.getHolidayOfAll();
    for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
      _holidayList[apiData.HolidayOfAll['data'][i]] = '';
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
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
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black,
              title: Text(dispYM),
              centerTitle: true,
              pinned: true,
              floating: true,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                color: Colors.greenAccent,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () => _goEverydaySpendDisplayScreen(
                      context: context, date: _prevMonth),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () => _goEverydaySpendDisplayScreen(
                      context: context, date: _nextMonth),
                ),
              ],
              expandedHeight: 90,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 80, left: 20, right: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _pickupKeihiItem(),
                            child: const Icon(Icons.cloud_upload_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _listItem(position: index),
                childCount: everydaySpendData.length,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    _utility.makeYMDYData(everydaySpendData[position].date.toString(), 0);
    var dispDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    return Card(
      color: _utility.getBgColor(dispDate, _holidayList),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$dispDate（${_utility.youbiStr}）'),
                    Text(
                      _utility.makeCurrencyDisplay(
                        everydaySpendData[position].spend.toString(),
                      ),
                    ),
                  ],
                ),
              ),
              Table(
                children: [
                  TableRow(children: [
                    (everydaySpendData[position].step != "")
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                FontAwesomeIcons.shoePrints,
                                color: Colors.white.withOpacity(0.6),
                                size: 12,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  _utility.makeCurrencyDisplay(
                                          everydaySpendData[position].step) +
                                      " step",
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (everydaySpendData[position].distance != "")
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                FontAwesomeIcons.road,
                                color: Colors.white.withOpacity(0.6),
                                size: 12,
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  _utility.makeCurrencyDisplay(
                                          everydaySpendData[position]
                                              .distance) +
                                      " m",
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ]),
                ],
              ),
              Divider(
                thickness: 1,
                color: Colors.white.withOpacity(0.3),
              ),
              _getDataTable(position: position),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _getDataTable({required position}) {
    List<Widget> _list = [];

    var record = everydaySpendData[position].record;
    var diff = everydaySpendData[position].diff;

    _utility.makeYMDYData(everydaySpendData[position].date.toString(), 0);
    var sDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    var exRecord = (record).split('/');
    for (var i = 0; i < exRecord.length; i++) {
      var exValue = (exRecord[i]).split('|');
      _list.add(
        Container(
          padding: const EdgeInsets.all(3),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _pickupLineIcon(selectDate: sDate, value: exRecord[i]);
                },
                child: _getLineIcon(selectDate: sDate, value: exRecord[i]),
              ),
              const SizedBox(width: 10),
              SizedBox(width: 50, child: Text(exValue[0])),
              SizedBox(
                width: 130,
                child: Text(exValue[1]),
              ),
              Container(
                child: _getLinkIcon(
                    position: position, data: exValue[1], index: i),
              ),
              Container(
                width: 60,
                alignment: Alignment.topRight,
                child: Text(_utility.makeCurrencyDisplay(exValue[2])),
              ),
            ],
          ),
        ),
      );
    }

    if (diff != 0) {
      _list.add(
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.yellowAccent.withOpacity(0.3),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_box_outline_blank,
                color: Color(0xFF2e2e2e),
              ),
              const SizedBox(width: 10),
              const SizedBox(width: 50, child: Text('-')),
              const SizedBox(width: 130, child: Text('差額')),
              Container(
                child: _getLinkIcon(
                  position: 0,
                  data: '',
                  index: 0,
                ),
              ),
              Container(
                width: 60,
                alignment: Alignment.topRight,
                child: Text(
                  _utility.makeCurrencyDisplay(diff.toString()),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(),
        Column(children: _list),
      ],
    );
  }

  ///
  Widget _getLinkIcon({required position, required data, required index}) {
    var record = everydaySpendData[position].record;
    var exRecord = (record).split('/');

    switch (data) {
      case "Bank_Departure (D)":
        return Container(
          alignment: Alignment.center,
          width: 20,
          child: GestureDetector(
            onTap: () {
              Get.to(
                () => BankMoveInfoSetScreen(
                  date: everydaySpendData[position].date,
                  record: exRecord[index],
                ),
              );
            },
            child: const Icon(
              Icons.ac_unit,
              size: 12,
              color: Colors.greenAccent,
            ),
          ),
        );

      case "credit":
        return Container(
          alignment: Alignment.center,
          width: 20,
          child: GestureDetector(
            onTap: () {
              Get.to(
                () => CreditInfoSetScreen(
                  date: everydaySpendData[position].date,
                  record: exRecord[index],
                ),
              );
            },
            child: const Icon(
              Icons.credit_card,
              size: 12,
              color: Colors.greenAccent,
            ),
          ),
        );

      default:
        return Container(
          alignment: Alignment.center,
          width: 20,
          child: const Icon(
            Icons.check_box_outline_blank,
            color: Color(0xFF2e2e2e),
          ),
        );
    }
  }

  ///
  Widget _getLineIcon({required selectDate, required value}) {
    var checkKey = "$selectDate|$value";
    if (_selectedList.contains(checkKey)) {
      return const Icon(
        Icons.check,
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
  void _pickupLineIcon({required selectDate, required value}) {
    var checkKey = "$selectDate|$value";
    if (_selectedList.contains(checkKey)) {
      _selectedList.remove(checkKey);
    } else {
      _selectedList.add(checkKey);
    }
    setState(() {});
  }

  ///
  void _pickupKeihiItem() {
    print(_selectedList);
  }

  //////////////////////////////////////////////////

  /// 画面遷移（EverydaySpendDisplayScreen）
  void _goEverydaySpendDisplayScreen(
      {required BuildContext context, required DateTime date}) {
    _utility.makeYMDYData(date.toString(), 0);
    var getDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EverydaySpendDisplayScreen(date: getDate),
      ),
    );
  }
}
