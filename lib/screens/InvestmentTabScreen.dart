// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../riverpod/investment/investment_shintaku_view_model.dart';
import '../riverpod/investment/investment_stock_view_model.dart';

import '../utilities/utility.dart';

import 'InvestmentStockListScreen.dart';
import 'InvestmentShintakuListScreen.dart';

class InvestmentTabScreen extends StatelessWidget {
  InvestmentTabScreen({Key? key}) : super(key: key);

  List<TabInfo> _tabs = [
    TabInfo("Stock", InvestmentStockListScreen()),
    TabInfo("Shintaku", InvestmentShintakuListScreen())
  ];

  int selectedIndex = 0;

  ///
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Investment'),
          centerTitle: true,

          //-------------------------//これを消すと「←」が出てくる（消さない）
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
          //-------------------------//これを消すと「←」が出てくる（消さない）

          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.graphic_eq),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return InvestmentGraphScreen(
                      selectedIndex: selectedIndex,
                    );
                  },
                );
              },
              color: Colors.greenAccent,
            ),
          ],

          bottom: TabBar(
            onTap: (int index) {
              selectedIndex = index;
            },
            tabs: _tabs.map((TabInfo tab) {
              return Tab(text: tab.label);
            }).toList(),
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class InvestmentGraphScreen extends ConsumerWidget {
  InvestmentGraphScreen({Key? key, required this.selectedIndex})
      : super(key: key);

  final int selectedIndex;

  late List<List<Map<String, String>>> graphData;

  late WidgetRef _ref;

  List<String> graphLegend = [];

  final Utility _utility = Utility();

  final ScrollController _controller = ScrollController();

  ///
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    getGraphData();

    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        child: Container(
          width: size.width * 10,
          height: size.height - 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          child: Column(
            children: [
              (selectedIndex == 0) ? _makeGraphStock() : _makeGraphShintaku(),
            ],
          ),
        ),
      ),
    );
  }

  ///
  void getGraphData() {
    var graphDefaultData = [];
    switch (selectedIndex) {
      case 0:
        graphDefaultData = _ref.watch(investmentStockProvider);
        break;
      case 1:
        graphDefaultData = _ref.watch(investmentShintakuProvider);
        break;
    }

    graphData = [];

    for (var i = 0; i < graphDefaultData.length; i++) {
      var exGDD = graphDefaultData[i].toString().split(';');
      graphLegend.add(exGDD[0]);

      var _data = exGDD[exGDD.length - 1].split('/');

      List<Map<String, String>> _data2 = [];
      for (var j = 0; j < _data.length; j++) {
        var exData = _data[j].split('|');
        if (exData[2] == '-') {
          continue;
        }

        var value =
            exData[exData.length - 1].replaceAll(',', '').replaceAll('+', '');

        Map<String, String> map = {};
        map['date'] = exData[0];
        map['value'] = value;

        _data2.add(map);
      }

      List<Map<String, String>> _data3 = [];
      for (var j = (_data2.length - 30); j < _data2.length; j++) {
        _data3.add(_data2[j]);
      }

      graphData.add(_data3);
    }
  }

  ///
  Widget _makeGraphStock() {
    List<ChartDataStock> _list = [];

    for (var i = 0; i < graphData[0].length; i++) {
      _list.add(
        ChartDataStock(
          date: DateTime.parse(graphData[0][i]['date']!),
          value01: num.parse(graphData[0][i]['value']!),
          value02: num.parse(graphData[1][i]['value']!),
          value03: num.parse(graphData[2][i]['value']!),
        ),
      );
    }

    var twelveColor = _utility.getTwelveColor();

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              legend: Legend(isVisible: true),
              series: <ChartSeries>[
                LineSeries<ChartDataStock, DateTime>(
                  name: graphLegend[0],
                  color: twelveColor[0],
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartDataStock data, _) => data.date,
                  yValueMapper: (ChartDataStock data, _) => data.value01,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                LineSeries<ChartDataStock, DateTime>(
                  name: graphLegend[1],
                  color: twelveColor[1],
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartDataStock data, _) => data.date,
                  yValueMapper: (ChartDataStock data, _) => data.value02,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                LineSeries<ChartDataStock, DateTime>(
                  name: graphLegend[2],
                  color: twelveColor[2],
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartDataStock data, _) => data.date,
                  yValueMapper: (ChartDataStock data, _) => data.value03,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
              primaryXAxis: DateTimeAxis(
                majorGridLines: const MajorGridLines(
                  width: 1,
                  color: Colors.white30,
                ),
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

  ///
  Widget _makeGraphShintaku() {
    List<ChartDataShintaku> _list = [];

    for (var i = 0; i < graphData[0].length; i++) {
      _list.add(
        ChartDataShintaku(
          date: DateTime.parse(graphData[0][i]['date']!),
          value01: num.parse(graphData[0][i]['value']!),
          value02: num.parse(graphData[1][i]['value']!),
          value03: num.parse(graphData[2][i]['value']!),
          value04: num.parse(graphData[3][i]['value']!),
        ),
      );
    }

    var twelveColor = _utility.getTwelveColor();

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SfCartesianChart(
              legend: Legend(isVisible: true),
              series: <ChartSeries>[
                LineSeries<ChartDataShintaku, DateTime>(
                  name: graphLegend[0],
                  color: twelveColor[0],
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartDataShintaku data, _) => data.date,
                  yValueMapper: (ChartDataShintaku data, _) => data.value01,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                LineSeries<ChartDataShintaku, DateTime>(
                  name: graphLegend[1],
                  color: twelveColor[1],
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartDataShintaku data, _) => data.date,
                  yValueMapper: (ChartDataShintaku data, _) => data.value02,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                LineSeries<ChartDataShintaku, DateTime>(
                  name: graphLegend[2],
                  color: twelveColor[2],
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartDataShintaku data, _) => data.date,
                  yValueMapper: (ChartDataShintaku data, _) => data.value03,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                LineSeries<ChartDataShintaku, DateTime>(
                  name: graphLegend[3],
                  color: twelveColor[3],
                  width: 3,
                  dataSource: _list,
                  xValueMapper: (ChartDataShintaku data, _) => data.date,
                  yValueMapper: (ChartDataShintaku data, _) => data.value04,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
              primaryXAxis: DateTimeAxis(
                majorGridLines: const MajorGridLines(
                  width: 1,
                  color: Colors.white30,
                ),
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

class TabInfo {
  String label;
  Widget widget;

  TabInfo(this.label, this.widget);
}

/////////////////////////////////////////////////////////////

class ChartDataStock {
  final DateTime date;
  final num value01;
  final num value02;
  final num value03;

  ChartDataStock(
      {required this.date,
      required this.value01,
      required this.value02,
      required this.value03});
}

/////////////////////////////////////////////////////////////

class ChartDataShintaku {
  final DateTime date;
  final num value01;
  final num value02;
  final num value03;
  final num value04;

  ChartDataShintaku(
      {required this.date,
      required this.value01,
      required this.value02,
      required this.value03,
      required this.value04});
}
