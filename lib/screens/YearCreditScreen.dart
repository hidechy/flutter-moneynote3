// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class YearCreditScreen extends StatefulWidget {
  final String year;
  final String month;

  const YearCreditScreen({Key? key, required this.year, required this.month})
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

  Map<String, dynamic> _summaryMap2 = {};

  int _allSpend = 0;

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

    //---------------------------//
    await apiData.getListOfYearSummaryData(year: widget.year);
    _summaryMap2 = apiData.ListOfYearSummaryData['data']['summary'];
    apiData.ListOfYearSummaryData = {};
    //---------------------------//

    setState(() {
      _loading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var dispTitle = (widget.month != '')
        ? 'credit [${widget.year}-${widget.month}]'
        : 'credit [${widget.year}]';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: Text(dispTitle),
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
              : _summaryList(),
        ],
      ),
    );
  }

  ///
  Widget _summaryList() {
    _allSpend = 0;

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => _goYearCreditScreen(
                      context: context,
                      year: widget.year,
                    ),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: _getMonthButtons(context: context),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
          ),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text('credit'),
                ),
                Expanded(
                  child: Container(
                    child: _getCreditMonthItem(),
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
        Container(
          width: double.infinity,
          alignment: Alignment.topRight,
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
            right: 40,
          ),
          decoration: BoxDecoration(
            color: (widget.month != '')
                ? Colors.yellowAccent.withOpacity(0.3)
                : Colors.black.withOpacity(0.3),
          ),
          child: Text(
            _utility.makeCurrencyDisplay(_allSpend.toString()),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  ///
  Widget _getCreditMonthItem({midashi}) {
    List<Widget> _list2 = [];

    int _total = 0;

    var roopVal =
        (midashi == null) ? _summaryMap2['credit'] : _summaryMap[midashi];

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
            color: (widget.month != '')
                ? (widget.month == key)
                    ? Colors.yellowAccent.withOpacity(0.3)
                    : Colors.transparent
                : Colors.transparent,
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

        if (midashi != null) {
          if (widget.month == '') {
            _allSpend -= int.parse(atai.toString());
          } else {
            if (widget.month == key) {
              _allSpend -= int.parse(atai.toString());
            }
          }
        }
      } else {
        _total += int.parse(value.toString());

        if (midashi != null) {
          if (widget.month == '') {
            _allSpend += int.parse(value.toString());
          } else {
            if (widget.month == key) {
              _allSpend += int.parse(value.toString());
            }
          }
        }
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
              color: (midashi == null)
                  ? Colors.white
                  : (_total > 30000)
                      ? Colors.pinkAccent
                      : Colors.yellowAccent,
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
                  child: _getCreditMonthItem(midashi: _midashiList[i]),
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
  Widget _getMonthButtons({context}) {
    List<Widget> _list3 = [];

    for (var i = 1; i <= 12; i++) {
      _list3.add(
        GestureDetector(
          onTap: () => _goYearCreditScreen(
            context: context,
            year: widget.year,
            month: i.toString().padLeft(2, '0'),
          ),
          child: Container(
            width: 70,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 5,
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
                color: (widget.month != '')
                    ? (widget.month == i.toString().padLeft(2, '0'))
                        ? Colors.yellowAccent.withOpacity(0.3)
                        : Colors.transparent
                    : Colors.transparent),
            child: Text(
              i.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      );
    }

    return Wrap(
      children: _list3,
    );
  }

  ////////////////////////////////////////////////////////////

  ///
  void _goPrevYear({required BuildContext context}) {
    var _year = int.parse(widget.year) - 1;
    _goYearCreditScreen(context: context, year: _year.toString());
  }

  ///
  void _goNextYear({required BuildContext context}) {
    var _year = int.parse(widget.year) + 1;
    _goYearCreditScreen(context: context, year: _year.toString());
  }

  ///
  void _goYearCreditScreen(
      {required BuildContext context, required String year, month = ''}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => YearCreditScreen(
          year: year,
          month: month,
        ),
      ),
    );
  }
}
