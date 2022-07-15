// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../controllers/TrainDataController.dart';
import '../controllers/HolidayDataController.dart';

class TrainDataDisplayScreen extends StatelessWidget {
  TrainDataController trainDataController = Get.put(
    TrainDataController(),
  );

  HolidayDataController holidayDataController = Get.put(
    HolidayDataController(),
  );

  final Utility _utility = Utility();

  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int maxNo = 0;

  TrainDataDisplayScreen({Key? key}) : super(key: key);

  ///
  @override
  Widget build(BuildContext context) {
    trainDataController.loadData(kind: 'AllTrainData');
    holidayDataController.loadData(kind: 'AllHolidayData');

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Train List'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward),
          color: Colors.greenAccent,
          onPressed: () => _scroll(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
          Obx(
            () {
              if (trainDataController.loading.value ||
                  holidayDataController.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _trainList(
                data10: trainDataController.data2,
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

  /// リスト表示
  Widget _trainList({data10, data20}) {
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
      {required int position, required Map data10, required List data20}) {
    var data = _makeData(data: data10);
    var _holidayList = _makeHolidayList(data: data20);

    _utility.makeYMDYData(data[position]['date'], 0);

    return (data[position]['value'] == '')
        ? Row(
            children: <Widget>[
              Container(
                width: 100,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color:
                      _utility.getBgColor(data[position]['date'], _holidayList),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '${data[position]['date']}（${_utility.youbiStr}）',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          )
        : Card(
            color: _utility.getBgColor(data[position]['date'], _holidayList),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: DefaultTextStyle(
                style: const TextStyle(fontSize: 12),
                child: Table(
                  children: [
                    TableRow(children: [
                      Text(
                          '${_utility.year}-${_utility.month}-${_utility.day}（${_utility.youbiStr}）'),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${data[position]['value']}'),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 80,
                                alignment: Alignment.topCenter,
                                child: (data[position]['oufuku'] == '1')
                                    ? const Text('＜往復＞')
                                    : const Text('＜片道＞'),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    _utility.makeCurrencyDisplay(
                                        data[position]['price']),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          );
  }

  ///
  List _makeData({data}) {
    List<Map<dynamic, dynamic>> _trainData = [];

    data.forEach(
      (key, value) {
        Map _map = {};
        _map['date'] = key;

        if (value == '') {
          _map['value'] = '';
          _map['price'] = '';
          _map['oufuku'] = '';
        } else {
          var exValue = (value).split('|');
          _map['value'] = exValue[0];
          _map['price'] = (exValue[1] != '') ? exValue[1] : '';
          _map['oufuku'] = exValue[2];
        }

        _trainData.add(_map);
      },
    );

    maxNo = _trainData.length;

    return _trainData;
  }

  ///
  Map _makeHolidayList({data}) {
    Map<String, dynamic> _holidayList = {};

    for (var i = 0; i < data.length; i++) {
      _holidayList[data[i]] = '';
    }

    return _holidayList;
  }
}
