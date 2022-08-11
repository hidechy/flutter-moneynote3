// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../controllers/InvestmentDataController.dart';

class FundDataDisplayScreen extends StatelessWidget {
  final InvestmentDataController investmentDataController =
      Get.put(InvestmentDataController());

  final Utility _utility = Utility();

  FundDataDisplayScreen({Key? key}) : super(key: key);

  late BuildContext _context;

  ///
  @override
  Widget build(BuildContext context) {
    _context = context;

    Size size = MediaQuery.of(context).size;

    investmentDataController.loadData(kind: 'AllFundData');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Fund Data'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: const Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

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
                style: TextStyle(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () {
                if (investmentDataController.loading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return _fundList(data: investmentDataController.data);
              },
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _fundList({data}) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int position) =>
          _listItem(position: position, data: data),
    );
  }

  ///
  Widget _listItem({required int position, required List data}) {
    var exFunddata = (data[position]).split(':');

    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                ),
                child: Text('${exFunddata[0]}'),
              ),
              const Divider(color: Colors.indigo),
              Container(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: _context,
                      builder: (_) {
                        return FundGraphScreen(
                          data: exFunddata[1],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.graphic_eq),
                ),
              ),
              _dispFundData(data: exFunddata[1]),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _dispFundData({data}) {
    var exData = (data).split('/');

    List<Widget> _list = [];

    for (var i = 0; i < exData.length; i++) {
      var exLine = (exData[i]).split('|');

      _list.add(
        Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text('${exLine[0]}'),
            ),
            SizedBox(
              width: 50,
              child: Text('${exLine[1]}'),
            ),
            SizedBox(
              width: 100,
              child: Text(
                '${exLine[2]}',
                style: TextStyle(
                    color: (exLine[4] == '1')
                        ? Colors.yellowAccent
                        : Colors.white),
              ),
            ),
            Text('${exLine[3]}'),
          ],
        ),
      );
    }

    return ExpansionTile(
      title: const Text('data'),
      children: _list,
    );
  }
}

/////////////////////////////////////////////////////////////

class FundGraphScreen extends StatelessWidget {
  FundGraphScreen({Key? key, required this.data}) : super(key: key);

  final String data;

  final Utility _utility = Utility();

  final ScrollController _controller = ScrollController();

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
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
  Widget _makeGraph({required data}) {
    List<ChartData> _list = [];

    var exData = (data).split('/');
    for (var i = 0; i < exData.length; i++) {
      var exLine = (exData[i]).split('|');

      if (exLine[1] == '-') {
        continue;
      }

      _utility.makeYMDYData(exLine[0], 0);
      _list.add(ChartData(
          x: DateTime(
            int.parse(_utility.year),
            int.parse(_utility.month),
            int.parse(_utility.day),
          ),
          val: int.parse(exLine[1])));
    }

    return Expanded(
      child: Column(
        children: [
          Expanded(
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
              border: const Border(top: BorderSide(color: Colors.white)),
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
                  child: const Text('jump'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent.withOpacity(0.3),
                  ),
                  onPressed: () {
                    _controller.jumpTo(_controller.position.minScrollExtent);
                  },
                  child: const Text('back'),
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

class ChartData {
  final DateTime x;
  final num val;

  ChartData({required this.x, required this.val});
}
