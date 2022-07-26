// ignore_for_file: unnecessary_null_comparison, file_names, import_of_legacy_library_into_null_safe, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../riverpod/investment/investment_stock_view_model.dart';
import '../riverpod/view_model/holiday_view_model.dart';

import '../utilities/CustomShapeClipper.dart';
import '../utilities/utility.dart';

class InvestmentStockListScreen extends ConsumerWidget {
  InvestmentStockListScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  late WidgetRef _ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _ref = ref;

    final investmentStockState = ref.watch(investmentStockProvider);

    Size size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
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
        ListView.separated(
          itemBuilder: (context, index) {
            var exData = investmentStockState[index].toString().split(';');

            _utility.makeYMDYData(exData[1], 0);

            return DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(exData[0]),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent.withOpacity(0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text('${exData[1]}（${_utility.youbiStr}）'),
                          ),
                          Expanded(child: Text(exData[2])),
                          Expanded(child: Text(exData[3])),
                          Expanded(child: Text(exData[4])),
                          Expanded(child: Text(exData[5])),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return InvestmentStockGraphScreen(
                                data: exData[6],
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.graphic_eq),
                      ),
                    ),
                    ExpansionTile(
                      title: const Text('data'),
                      children: _dispDetailData(data: exData[6]),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Container(),
          itemCount: investmentStockState.length,
        ),
      ],
    );
  }

  ///
  List<Widget> _dispDetailData({required String data}) {
    List<Widget> _list = [];

    var exData = data.split('/');

    for (var i = 0; i < exData.length; i++) {
      var exOneData = exData[i].split('|');

      _utility.makeYMDYData(exOneData[0], 0);

      //----------------//
      final holidayState = _ref.watch(holidayProvider);
      Map<String, dynamic> _holidayList = {};
      for (var i = 0; i < holidayState.length; i++) {
        _holidayList[holidayState[i]] = '';
      }
      //----------------//

      _list.add(
        Container(
          decoration: BoxDecoration(
            color: _utility.getBgColor(exOneData[0], _holidayList),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('${exOneData[0]}（${_utility.youbiStr}）'),
              ),
              Expanded(child: Text(exOneData[2])),
              Expanded(child: Text(exOneData[3])),
              Expanded(child: Text(exOneData[4])),
              Expanded(child: Text(exOneData[5])),
            ],
          ),
        ),
      );
    }

    return _list;
  }
}

/////////////////////////////////////////////////////////////

class InvestmentStockGraphScreen extends StatelessWidget {
  InvestmentStockGraphScreen({Key? key, required this.data}) : super(key: key);

  final String data;

  final Utility _utility = Utility();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
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
  Widget _makeGraph({required String data}) {
    List<ChartData> _list = [];

    var exData = (data).split('/');
    for (var i = 0; i < exData.length; i++) {
      var exValue = (exData[i]).split('|');

      if (exValue[5] == "-") {
        continue;
      }

      _utility.makeYMDYData(exValue[0], 0);

      _list.add(
        ChartData(
          x: DateTime(
            int.parse(_utility.year),
            int.parse(_utility.month),
            int.parse(_utility.day),
          ),
          val: int.parse(exValue[4].replaceAll(',', '')),
          pay: int.parse(exValue[3].replaceAll(',', '')),
        ),
      );
    }

    return Expanded(
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
          LineSeries<ChartData, DateTime>(
            color: Colors.orangeAccent,
            dataSource: _list,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.pay,
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
    );
  }
}

/////////////////////////////////////////////////////////////

class ChartData {
  final DateTime x;
  final num val;
  final num pay;

  ChartData({required this.x, required this.val, required this.pay});
}
