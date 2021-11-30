// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class YearCreditScreen extends StatefulWidget {
  final String midashi;
  final String year;
  Map<String, dynamic> summary = {};

  YearCreditScreen(
      {Key? key,
      required this.midashi,
      required this.year,
      required this.summary})
      : super(key: key);

  @override
  _YearCreditScreenState createState() => _YearCreditScreenState();
}

class _YearCreditScreenState extends State<YearCreditScreen> {
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
    await apiData.getListOfYearCreditData(year: widget.year);
    _midashiList = apiData.ListOfYearCreditData['data']['midashi'];
    _summaryMap = apiData.ListOfYearCreditData['data']['summary'];
    apiData.ListOfYearCreditData = {};

    setState(() {
      _loading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text('${widget.midashi} [${widget.year}]'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          color: Colors.greenAccent,
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: const <Widget>[],
      ),
      body: Stack(
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
          (_loading == false)
              ? Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: DefaultTextStyle(
                        style: const TextStyle(fontSize: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(widget.midashi),
                            ),
                            Expanded(
                              child: Container(
                                child: _getSummaryMonthItem(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: Colors.white),
                    Expanded(
                      child: _getSummaryCreditItem(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  ///
  Widget _getSummaryMonthItem({midashi}) {
    List<Widget> _list2 = [];

    int _total = 0;

    var roopVal = (midashi == null) ? widget.summary : _summaryMap[midashi];

    roopVal.forEach((key, value) {
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
          padding: const EdgeInsets.only(right: 30),
          child: Text(
            _utility.makeCurrencyDisplay(_total.toString()),
            style: TextStyle(
              color: (_total > 30000) ? Colors.pinkAccent : Colors.yellowAccent,
            ),
          ),
        ),
      ],
    );
  }

  ///
  Widget _getSummaryCreditItem() {
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
}
