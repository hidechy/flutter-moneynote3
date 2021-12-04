// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class YearCreditCompareScreen extends StatefulWidget {
  const YearCreditCompareScreen({Key? key}) : super(key: key);

  @override
  _YearCreditCompareScreenState createState() =>
      _YearCreditCompareScreenState();
}

class _YearCreditCompareScreenState extends State<YearCreditCompareScreen> {
  final Utility _utility = Utility();
  ApiData apiData = ApiData();

  int _endYear = 0;

  List<dynamic> _midashiList = [];
  final Map<String, dynamic> _notCommonMidashi = {};

  final Map<String, dynamic> _yearSummaryMap = {};

  bool _loading = false;

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

    await apiData.getListOfYearCreditCommonItemData();
    _midashiList = apiData.ListOfYearCreditCommonItemData['data'];

    apiData.ListOfYearCreditCommonItemData = {};

    for (var i = 2020; i <= _endYear; i++) {
      await apiData.getListOfYearCreditData(year: i.toString());
      _makeCommonMidashi(
        year: i,
        commonItem: _midashiList,
        midashi: apiData.ListOfYearCreditData['data']['midashi'],
      );

//      _summaryMap = apiData.ListOfYearCreditData['data']['summary'];

      _makeYearSummaryMap(
        year: i.toString(),
        data: apiData.ListOfYearCreditData['data']['summary'],
      );

      apiData.ListOfYearCreditData = {};
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
        title: const Text('Credit Compare'),
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
            onPressed: () => _goYearCreditCompareScreen(
              context: context,
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
  void _makeCommonMidashi(
      {required int year, required List commonItem, required midashi}) {
    List _list = [];

    for (var i = 0; i < midashi.length; i++) {
      if (commonItem.contains(midashi[i])) {
      } else {
        _list.add(midashi[i]);
      }
    }

    _notCommonMidashi[year.toString()] = _list;
  }

  ///
  Widget _summaryList({required BuildContext context}) {
    List<Widget> _list = [];

    for (var i = 0; i < _midashiList.length; i++) {
      _list.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_midashiList[i]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 100),
                  Expanded(
                    child: Container(
                      child: _getSummaryMonthItem(midashi: _midashiList[i]),
                    ),
                  ),
                ],
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
              children: [
                Column(
                  children: _list,
                ),
                _dispOtherItem(),
              ],
            ),
          ),
        ),
        Container(height: 10),
      ],
    );
  }

  ///
  Widget _dispOtherItem() {
    List<Widget> _list4 = [];

    _notCommonMidashi.forEach((key, value) {
      _list4.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration:
                    BoxDecoration(color: Colors.yellowAccent.withOpacity(0.3)),
                child: Text(key),
              ),
              _dispOtherItemRow(year: key),
            ],
          ),
        ),
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _list4,
    );
  }

  ///
  Widget _dispOtherItemRow({required String year}) {
    List<Widget> _list5 = [];

    var otherTotal = 0;
    for (var i = 0; i < _notCommonMidashi[year].length; i++) {
      _list5.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_notCommonMidashi[year][i]),
              Text(_utility.makeCurrencyDisplay(_yearSummaryMap[year]
                      [_notCommonMidashi[year][i]]
                  .toString())),
            ],
          ),
        ),
      );

      otherTotal += int.parse(
          _yearSummaryMap[year][_notCommonMidashi[year][i]].toString());
    }

    _list5.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(''),
          Text(
            _utility.makeCurrencyDisplay(otherTotal.toString()),
            style: const TextStyle(color: Colors.yellowAccent),
          ),
        ],
      ),
    );

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _list5,
      ),
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
          ),
          child: Text(
            _utility.makeCurrencyDisplay(
                _yearSummaryMap[i.toString()][midashi].toString()),
          ),
        ),
      );
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
        Container(
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
          ),
          child: Text(
            i.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      );
    }

    return Wrap(
      children: _list3,
    );
  }

  /////////////////////////////////////////////////

  ///
  void _goYearCreditCompareScreen({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const YearCreditCompareScreen(),
      ),
    );
  }
}
