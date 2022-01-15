// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'dart:convert';

import '../models/SameSpend.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

class SamedayListScreen extends StatefulWidget {
  String date;

  SamedayListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _SamedayListScreenState createState() => _SamedayListScreenState();
}

class _SamedayListScreenState extends State<SamedayListScreen> {
  final Utility _utility = Utility();

  List<Datum> _sameSpend = [];

  bool _loading = false;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    ////////////////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/getSamedaySpend";
    Map<String, String> headers = {'content-type': 'application/json'};

    String body = json.encode({"date": widget.date});

    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    final sameSpend = sameSpendFromJson(response.body);

    _sameSpend = sameSpend.data;
    ////////////////////////////////////////

    setState(() {
      _loading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var exDate = (widget.date).split('-');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(exDate[2]),

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
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _makeGraph(),
                const SizedBox(height: 10),
                _makePrevNextButton(),
                const SizedBox(height: 10),
                _makeDayButton(),
                const SizedBox(height: 20),
                (_loading == false)
                    ? Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : Expanded(child: _samedayList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  Widget _samedayList() {
    return ListView.separated(
      itemCount: _sameSpend.length,
      itemBuilder: (context, int position) => _listItem(position: position),
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(color: Colors.white);
      },
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_sameSpend[position].ym),
            Text(
              _utility.makeCurrencyDisplay(
                _sameSpend[position].sum.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Widget _makeDayButton() {
    List<Widget> _list = [];

    Size size = MediaQuery.of(context).size;

    for (var i = 1; i <= 31; i++) {
      _list.add(
        GestureDetector(
          onTap: () => _makeDateForGoSamedayListScreen(day: i),
          child: Container(
            margin: const EdgeInsets.all(3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _getButtonBgColor(day: i),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            width: (size.width / 5) - 10,
            child: Text(
              i.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      );
    }

    return Wrap(
      children: _list,
    );
  }

  ///
  Widget _makeGraph() {
    List<ChartData> _list = [];

    for (var element in _sameSpend) {
      var exElement = (element.ym).split('-');

      var _datetime =
          DateTime(int.parse(exElement[0]), int.parse(exElement[1]), 1);

      _list.add(
        ChartData(
          x: _datetime,
          val: element.sum,
        ),
      );
    }

    return SfCartesianChart(
      series: <ChartSeries>[
        ColumnSeries<ChartData, DateTime>(
          color: Colors.yellowAccent,
          dataSource: _list,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.val,
        )
      ],
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(
          width: 2,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getButtonBgColor({required int day}) {
    var exDate = (widget.date).split('-');

    if (day.toString().padLeft(2, '0') == exDate[2]) {
      return Colors.yellowAccent.withOpacity(0.3);
    } else {
      return Colors.black.withOpacity(0.3);
    }
  }

  ///
  Widget _makePrevNextButton() {
    _utility.makeYMDYData(widget.date, 0);

    var _prevDate = DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) - 1);
    var _nextDate = DateTime(int.parse(_utility.year),
        int.parse(_utility.month), int.parse(_utility.day) + 1);

    _utility.makeYMDYData(_prevDate.toString(), 0);
    var pDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    _utility.makeYMDYData(_nextDate.toString(), 0);
    var nDate = "${_utility.year}-${_utility.month}-${_utility.day}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _goSamedayListScreen(date: pDate),
          child: const Icon(
            Icons.skip_previous,
            color: Colors.greenAccent,
          ),
        ),
        GestureDetector(
          onTap: () => _goSamedayListScreen(date: nDate),
          child: const Icon(
            Icons.skip_next,
            color: Colors.greenAccent,
          ),
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////

  ///
  void _makeDateForGoSamedayListScreen({required int day}) {
    var exDate = (widget.date).split('-');
    var date = "${exDate[0]}-${exDate[1]}-${day.toString().padLeft(2, '0')}";
    _goSamedayListScreen(date: date);
  }

  ///
  void _goSamedayListScreen({required String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SamedayListScreen(date: date),
      ),
    );
  }
}

///
class ChartData {
  final DateTime x;
  final num val;

  ChartData({required this.x, required this.val});
}
