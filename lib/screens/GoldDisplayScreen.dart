// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class GoldDisplayScreen extends StatefulWidget {
  const GoldDisplayScreen({Key? key}) : super(key: key);

  @override
  _GoldDisplayScreenState createState() => _GoldDisplayScreenState();
}

class _GoldDisplayScreenState extends State<GoldDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _goldData = [];

  Map<String, dynamic> _holidayList = {};

  ItemScrollController _itemScrollController = ItemScrollController();

  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  int maxNo = 0;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //----------------------------//
    await apiData.getListOfGoldData();
    if (apiData.ListOfGoldData != null) {
      for (var i = 0; i < apiData.ListOfGoldData['data'].length; i++) {
        _goldData.add(apiData.ListOfGoldData['data'][i]);
      }
    }
    apiData.ListOfGoldData = {};
    //----------------------------//

    //----------------------------//
    await apiData.getHolidayOfAll();
    if (apiData.HolidayOfAll != null) {
      for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
        _holidayList[apiData.HolidayOfAll['data'][i]] = '';
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    maxNo = _goldData.length;

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Gold List'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward),
          color: Colors.greenAccent,
          onPressed: () => _scroll(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goGoldDisplayScreen(),
            color: Colors.greenAccent,
          ),
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
            children: <Widget>[
              Expanded(
                child: _goldList(),
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
  Widget _goldList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index);
      },
      itemCount: _goldData.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  ///
  Widget _listItem({required int position}) {
    var date =
        '${_goldData[position]['year']}-${_goldData[position]['month']}-${_goldData[position]['day']}';
    _utility.makeYMDYData(date, 0);

    return (_goldData[position]['gold_value'] == "-")
        ? Row(
            children: <Widget>[
              Container(
                width: 100,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _utility.getBgColor(date, _holidayList),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  '$date（${_utility.youbiStr}）',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          )
        : Card(
            color: _utility.getBgColor(date, _holidayList),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: DefaultTextStyle(
                  style: const TextStyle(fontSize: 12),
                  child: Column(
                    children: <Widget>[
                      //----------------------------------
                      Container(
                        padding: const EdgeInsets.only(right: 80),
                        child: Table(
                          children: [
                            TableRow(
                              children: [
                                Text('$date（${_utility.youbiStr}）'),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                              '1g　${_utility.makeCurrencyDisplay(_goldData[position]['gold_tanka'])}'),
                                          Text(
                                              '${_goldData[position]['diff']}'),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: _getUpDownMark(
                                          updown: _goldData[position]
                                              ['up_down']),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //----------------------------------

                      const Divider(
                          color: Colors.indigo, indent: 10.0, endIndent: 10.0),
                      //----------------------------------
                      Container(
                        padding: const EdgeInsets.only(left: 30),
                        child: Table(
                          children: [
                            TableRow(
                              children: [
                                Text(_utility.makeCurrencyDisplay(
                                    _goldData[position]['gold_value']
                                        .toString())),
                                Text(_utility.makeCurrencyDisplay(
                                    _goldData[position]['pay_price']
                                        .toString())),
                                Text(
                                  _utility.makeCurrencyDisplay(
                                      (_goldData[position]['gold_value'] -
                                              _goldData[position]['pay_price'])
                                          .toString()),
                                  style: (_goldData[position]['gold_value'] -
                                              _goldData[position]['pay_price'] >
                                          0)
                                      ? const TextStyle(
                                          color: Colors.yellowAccent)
                                      : const TextStyle(
                                          color: Colors.redAccent),
                                ),
                                const Text(''),
                                const Text(''),
                              ],
                            ),
                          ],
                        ),
                      ),
                      //----------------------------------

                      //----------------------------------
                      Table(
                        children: [
                          TableRow(
                            children: [
                              const Text(''),
                              const Text(''),
                              Text(_utility.makeCurrencyDisplay(
                                  _goldData[position]['gold_price'])),
                              Container(
                                alignment: Alignment.topRight,
                                child:
                                    Text('${_goldData[position]['gram_num']}g'),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                    '${_goldData[position]['total_gram']}g'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      //----------------------------------
                    ],
                  )),
            ),
          );
  }

  ///
  Widget _getUpDownMark({updown}) {
    switch (updown) {
      case 0:
        return const Icon(Icons.arrow_downward, color: Colors.redAccent);
      case 1:
        return const Icon(Icons.arrow_upward, color: Colors.greenAccent);
      case 9:
        return const Icon(Icons.crop_square, color: Colors.black);
    }
    return Container();
  }

  ///
  void _goGoldDisplayScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const GoldDisplayScreen(),
      ),
    );
  }
}
