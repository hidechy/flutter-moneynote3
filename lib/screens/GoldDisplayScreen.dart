// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../controllers/InvestmentDataController.dart';
import '../controllers/HolidayDataController.dart';

import '../models/GoldRecord.dart';

class GoldDisplayScreen extends StatelessWidget {
  GoldDisplayScreen({Key? key, required this.closeMethod}) : super(key: key);

  final String closeMethod;

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

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context) {
    _context = context;

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
            onPressed: () {
              Navigator.pop(context);

              if (closeMethod == "double") {
                Navigator.pop(context);
              }
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
    return Column(
      children: [
        Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: _context,
                builder: (_) {
                  return GoldGraphScreen(
                    data: data10,
                  );
                },
              );
            },
            child: const Icon(Icons.graphic_eq),
          ),
        ),
        Expanded(
          child: ScrollablePositionedList.builder(
            itemBuilder: (context, index) {
              return _listItem(position: index, data10: data10, data20: data20);
            },
            itemCount: data10.length,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
          ),
        ),
      ],
    );
  }

  ///
  Widget _listItem(
      {required int position, required List data10, required List data20}) {
    var data = _makeData(data: data10);
    var _holidayList = _makeHolidayList(data: data20);

    var date =
        '${data[position].year}-${data[position].month}-${data[position].day}';
    _utility.makeYMDYData(date, 0);

    return (data[position].goldValue == "-")
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
                                            '1g　${_utility.makeCurrencyDisplay(data[position].goldTanka)}'),
                                        Text('${data[position].diff}'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: _getUpDownMark(
                                        updown: data[position].upDown),
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
                                  data[position].goldValue.toString(),
                                ),
                              ),
                              Text(
                                _utility.makeCurrencyDisplay(
                                  data[position].payPrice.toString(),
                                ),
                              ),
                              Text(
                                _utility.makeCurrencyDisplay(
                                    (data[position].goldValue -
                                            data[position].payPrice)
                                        .toString()),
                                style: (data[position].goldValue -
                                            data[position].payPrice >
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
                                  data[position].goldPrice),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text('${data[position].gramNum}g'),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text('${data[position].totalGram}g'),
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
    List<Gold> _goldData = [];

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

/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

class GoldGraphScreen extends StatelessWidget {
  GoldGraphScreen({Key? key, required this.data}) : super(key: key);

  final List<Gold> data;

  final Utility _utility = Utility();

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: Container(
          width: size.width * 3,
          height: size.height - 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          child: Column(
            children: [
              _makeGraph(data: data),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _makeGraph({data}) {
    List<ChartData> _list = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i].goldValue == "-") {
        continue;
      }

      var date = '${data[i].year}-${data[i].month}-${data[i].day}';
      _utility.makeYMDYData(date, 0);

      _list.add(
        ChartData(
          x: DateTime(
            int.parse(_utility.year),
            int.parse(_utility.month),
            int.parse(_utility.day),
          ),
          goldValue: data[i].goldValue,
          payPrice: data[i].payPrice,
        ),
      );
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SfCartesianChart(
              series: <ChartSeries>[
                LineSeries<ChartData, DateTime>(
                  color: Colors.yellowAccent,
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.goldValue,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                LineSeries<ChartData, DateTime>(
                  color: Colors.orangeAccent,
                  dataSource: _list,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.payPrice,
                ),
              ],
              primaryXAxis: DateTimeAxis(
                majorGridLines: const MajorGridLines(width: 0),
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
/////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

class ChartData {
  final DateTime x;
  final num goldValue;
  final num payPrice;

  ChartData({required this.x, required this.goldValue, required this.payPrice});
}
