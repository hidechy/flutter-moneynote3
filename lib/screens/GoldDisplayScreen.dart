// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../controllers/InvestmentDataController.dart';
import '../controllers/HolidayDataController.dart';

class GoldDisplayScreen extends StatelessWidget {
  InvestmentDataController investmentDataController = Get.put(
    InvestmentDataController(),
  );

  HolidayDataController holidayDataController = Get.put(
    HolidayDataController(),
  );

  final Utility _utility = Utility();

  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int maxNo = 0;

  GoldDisplayScreen({Key? key}) : super(key: key);

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    investmentDataController.loadData(kind: 'AllGoldData');
    holidayDataController.loadData(kind: 'AllHolidayData');

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
          Obx(
            () {
              if (investmentDataController.loading.value ||
                  holidayDataController.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _goldList(
                data10: investmentDataController.data,
                data20: holidayDataController.data,
              );
            },
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
  Widget _goldList({data10, data20}) {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index, data10: data10, data20: data20);
      },
      itemCount: data10.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  ///
  Widget _listItem(
      {required int position, required List data10, required List data20}) {
    var data = _makeData(data: data10);
    var _holidayList = _makeHolidayList(data: data20);

    var date =
        '${data[position]['year']}-${data[position]['month']}-${data[position]['day']}';
    _utility.makeYMDYData(date, 0);

    return (data[position]['gold_value'] == "-")
        ? Row(
            children: <Widget>[
              Container(
                width: 100,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _utility.getBgColor(date, _holidayList),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
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
                                            '1g　${_utility.makeCurrencyDisplay(data[position]['gold_tanka'])}'),
                                        Text('${data[position]['diff']}'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: _getUpDownMark(
                                        updown: data[position]['up_down']),
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
                              Text(
                                _utility.makeCurrencyDisplay(
                                  data[position]['gold_value'].toString(),
                                ),
                              ),
                              Text(
                                _utility.makeCurrencyDisplay(
                                  data[position]['pay_price'].toString(),
                                ),
                              ),
                              Text(
                                _utility.makeCurrencyDisplay((data[position]
                                            ['gold_value'] -
                                        data[position]['pay_price'])
                                    .toString()),
                                style: (data[position]['gold_value'] -
                                            data[position]['pay_price'] >
                                        0)
                                    ? const TextStyle(
                                        color: Colors.yellowAccent)
                                    : const TextStyle(color: Colors.redAccent),
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
                            Text(
                              _utility.makeCurrencyDisplay(
                                  data[position]['gold_price']),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text('${data[position]['gram_num']}g'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text('${data[position]['total_gram']}g'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //----------------------------------
                  ],
                ),
              ),
            ),
          );
  }

  ///
  List _makeData({data}) {
    List<Map<dynamic, dynamic>> _goldData = [];

    for (var i = 0; i < data.length; i++) {
      _goldData.add(data[i]);
    }

    maxNo = _goldData.length;

    return _goldData;
  }

  ///
  Map _makeHolidayList({data}) {
    Map<String, dynamic> _holidayList = {};

    for (var i = 0; i < data.length; i++) {
      _holidayList[data[i]] = '';
    }

    return _holidayList;
  }

  ///
  Widget _getUpDownMark({updown}) {
    switch (updown) {
      case 0:
        return const Icon(
          Icons.arrow_downward,
          color: Colors.redAccent,
        );
      case 1:
        return const Icon(
          Icons.arrow_upward,
          color: Colors.greenAccent,
        );
      case 9:
        return const Icon(
          Icons.crop_square,
          color: Colors.black,
        );
    }
    return Container();
  }
}
