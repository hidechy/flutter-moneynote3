import 'package:flutter/material.dart';

import '../utilities/utility.dart';

import '../data/ApiData.dart';

class YearSummaryScreen extends StatefulWidget {
  final String year;

  YearSummaryScreen({required this.year});

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
    if (apiData.ListOfYearSummaryData != null) {
      _midashiList = apiData.ListOfYearSummaryData['data']['midashi'];
      _summaryMap = apiData.ListOfYearSummaryData['data']['summary'];
    }
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
          style: TextStyle(fontSize: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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

    _summaryMap[midashi].forEach((key, value) {
      _list2.add(
        Container(
          width: 70,
          alignment: Alignment.topRight,
          margin: EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.white.withOpacity(0.3),
          )),
          child: Text(
            _utility.makeCurrencyDisplay(value.toString()),
          ),
        ),
      );
    });

    return Wrap(
      children: _list2,
    );
  }
}
