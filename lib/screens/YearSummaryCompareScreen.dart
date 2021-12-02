// ignore_for_file: file_names, non_constant_identifier_names, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class YearSummaryCompareScreen extends StatefulWidget {
  final String year;

  YearSummaryCompareScreen({Key? key, required this.year}) : super(key: key);

  @override
  _YearSummaryCompareScreenState createState() =>
      _YearSummaryCompareScreenState();
}

class _YearSummaryCompareScreenState extends State<YearSummaryCompareScreen> {
  final Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<dynamic> _midashiList = [];

  bool _loading = false;

  final Map<String, dynamic> _yearSummaryMap = {};

  int _endYear = 0;

  int _allSpend = 0;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _utility.makeYMDYData(DateTime.now().toString(), 0);

    _endYear = int.parse(_utility.year);

    for (var i = 2020; i <= _endYear; i++) {
      await apiData.getListOfYearSummaryData(year: i.toString());
      _midashiList = apiData.ListOfYearSummaryData['data']['midashi'];
      _makeYearSummaryMap(
        year: i.toString(),
        data: apiData.ListOfYearSummaryData['data']['summary'],
      );
      apiData.ListOfYearSummaryData = {};
    }

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
        title: const Text('Year Compare'),
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
            icon: const Icon(Icons.refresh),
            onPressed: () => _goYearSummaryCompareScreen(
              context: context,
              year: '',
            ),
            color: Colors.greenAccent,
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
              : _summaryList(context: context),
        ],
      ),
    );
  }

  ///
  Widget _summaryList({required BuildContext context}) {
    List<Widget> _list = [];

    _allSpend = 0;

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
              ),
              Expanded(
                child: Container(
                  child: _getYearButtons(context: context),
                ),
              ),
            ],
          ),
        ),
        Container(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: _list,
            ),
          ),
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
            color: (widget.year != '')
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
  Widget _getSummaryMonthItem({midashi}) {
    List<Widget> _list2 = [];

    for (var i = 2020; i <= _endYear; i++) {
      var upDown = (i != 2020) ? _makeUpDown(year: i, midashi: midashi) : '';

      _list2.add(
        Container(
          width: 70,
          alignment: Alignment.topRight,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              border: Border.all(
                color: _makeBorderColor(up_down: upDown),
              ),
              color: (i.toString() == widget.year)
                  ? Colors.yellowAccent.withOpacity(0.3)
                  : Colors.transparent),
          child: Text(
            _utility.makeCurrencyDisplay(
                _yearSummaryMap[i.toString()][midashi].toString()),
          ),
        ),
      );

      if (widget.year != '') {
        var _first =
            _yearSummaryMap[i.toString()][midashi].toString().substring(0, 1);
        if (_first == "-") {
          if (widget.year == i.toString()) {
            var atai =
                _yearSummaryMap[i.toString()][midashi].toString().substring(1);
            _allSpend -= int.parse(atai.toString());
          }
        } else {
          if (widget.year == i.toString()) {
            _allSpend +=
                int.parse(_yearSummaryMap[i.toString()][midashi].toString());
          }
        }
      }
    }

    return Wrap(
      children: _list2,
    );
  }

  ///
  String _makeUpDown({required int year, required String midashi}) {
    if (_yearSummaryMap[year.toString()][midashi] >
        _yearSummaryMap[(year - 1).toString()][midashi]) {
      return 'up';
    } else if (_yearSummaryMap[year.toString()][midashi] <
        _yearSummaryMap[(year - 1).toString()][midashi]) {
      return 'down';
    } else {
      return 'equal';
    }
  }

  ///
  Color _makeBorderColor({required String up_down}) {
    switch (up_down) {
      case 'up':
        return Colors.redAccent;
      case 'down':
        return Colors.blueAccent;
      default:
        return Colors.white.withOpacity(0.3);
    }
  }

  ///
  void _makeYearSummaryMap({required String year, data}) {
    Map _map = {};

    data.forEach((key, value) {
      int _total = 0;

      value.forEach((key2, value2) {
        var _first = value2.toString().substring(0, 1);
        if (_first == "-") {
          var atai = value2.toString().substring(1);
          _total -= int.parse(atai.toString());
        } else {
          _total += int.parse(value2.toString());
        }
      });

      _map[key] = _total;
    });

    _yearSummaryMap[year] = _map;
  }

  ///
  Widget _getYearButtons({required BuildContext context}) {
    List<Widget> _list3 = [];

    for (var i = 2020; i <= _endYear; i++) {
      _list3.add(
        GestureDetector(
          onTap: () => _goYearSummaryCompareScreen(
            context: context,
            year: i.toString().padLeft(2, '0'),
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
                color: (widget.year != '')
                    ? (widget.year == i.toString())
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

  ///////////////////////////////////////////////////////

  void _goYearSummaryCompareScreen(
      {required BuildContext context, required String year}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => YearSummaryCompareScreen(
          year: year,
        ),
      ),
    );
  }
}
