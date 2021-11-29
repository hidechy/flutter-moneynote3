// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import '../data/ApiData.dart';

class YearSummaryScreen extends StatefulWidget {
  final String year;

  const YearSummaryScreen({required this.year});

  @override
  _YearSummaryScreenState createState() => _YearSummaryScreenState();
}

class _YearSummaryScreenState extends State<YearSummaryScreen> {
  final Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<dynamic> _midashiList = [];
  Map<String, dynamic> _summaryMap = {};

  bool _loading = false;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    await apiData.getListOfYearSummaryData(year: widget.year);
    _midashiList = apiData.ListOfYearSummaryData['data']['midashi'];
    _summaryMap = apiData.ListOfYearSummaryData['data']['summary'];
    apiData.ListOfYearSummaryData = {};

    setState(() {
      _loading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text(widget.year),
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
            icon: const Icon(Icons.skip_previous),
            tooltip: '前年',
            onPressed: (widget.year == '2020')
                ? null
                : () => _goPrevYear(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: '翌年',
            onPressed: () => _goNextYear(context: context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(context: context),
          (_loading == false)
              ? Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : _summaryList(),
        ],
      ),
    );
  }

  ///
  Widget _summaryList() {
    List<Widget> _list = [];

    for (var i = 0; i < _midashiList.length; i++) {
      _list.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(_midashiList[i]),
              ),
              Expanded(
                child: Container(
                  child: _getSummaryMonthItem(midashi: _midashiList[i]),
                ),
              ),
            ],
          ),
        ),
      );

      _list.add(
        const Divider(
          color: Colors.white,
          height: 10,
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: _list,
      ),
    );
  }

  ///
  Widget _getSummaryMonthItem({midashi}) {
    List<Widget> _list2 = [];

    int _total = 0;

    _summaryMap[midashi].forEach((key, value) {
      _list2.add(
        Container(
          width: 70,
          alignment: Alignment.topRight,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Text(
            _utility.makeCurrencyDisplay(value.toString()),
          ),
        ),
      );

      var _first = value.toString().substring(0, 1);
      if (_first == "-") {
        var atai = value.toString().substring(1);
        _total -= int.parse(atai.toString());
      } else {
        _total += int.parse(value.toString());
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: _list2,
        ),
        Container(
          alignment: Alignment.topRight,
          padding: EdgeInsets.only(right: 30),
          child: Text(
            _utility.makeCurrencyDisplay(_total.toString()),
            style: TextStyle(color: Colors.yellowAccent),
          ),
        ),
      ],
    );
  }

/////////////////////////////////////////

  ///
  void _goPrevYear({required BuildContext context}) {
    var _year = int.parse(widget.year) - 1;
    _goYearSummaryScreen(context: context, year: _year);
  }

  ///
  void _goNextYear({required BuildContext context}) {
    var _year = int.parse(widget.year) + 1;
    _goYearSummaryScreen(context: context, year: _year);
  }

  ///
  void _goYearSummaryScreen(
      {required BuildContext context, required int year}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => YearSummaryScreen(
          year: year.toString(),
        ),
      ),
    );
  }
}
