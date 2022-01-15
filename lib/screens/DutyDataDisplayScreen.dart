// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class DutyDataDisplayScreen extends StatefulWidget {
  const DutyDataDisplayScreen({Key? key}) : super(key: key);

  @override
  _DutyDataDisplayScreenState createState() => _DutyDataDisplayScreenState();
}

class _DutyDataDisplayScreenState extends State<DutyDataDisplayScreen> {
  final Utility _utility = Utility();
  ApiData apiData = ApiData();

  final List<String> _midashiList = [];
  final Map<dynamic, dynamic> _dutyDataMap = {};

  bool _loading = false;

  int _endYear = 0;

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

    _midashiList.add('所得税');
    _midashiList.add('住民税');
    _midashiList.add('年金');
    _midashiList.add('国民年金基金');
    _midashiList.add('国民健康保険');

    await apiData.getListOfDutyData();
    var data = apiData.ListOfDutyData['data'];
    apiData.ListOfDutyData = {};

    List _list = [];
    for (var i = 0; i < _midashiList.length; i++) {
      Map _map2 = {};
      for (var j = 2020; j <= _endYear; j++) {
        _list = [];
        data[_midashiList[i]].forEach((value) {
          var exValue = (value).split('|');
          var exDate = (exValue[0]).split('-');
          if (exDate[0] == j.toString()) {
            Map _map = {};
            _map['date'] = exValue[0];
            _map['price'] = exValue[1];
            _list.add(_map);
          }
        });
        _map2[j.toString()] = _list;
      }
      _dutyDataMap[_midashiList[i]] = _map2;
    }

//    print(_dutyDataMap);

/*
    I/flutter ( 7491): {所得税: {
    2020: [{date: 2020-10-07, price: 137700}],
    2021: [{date: 2021-05-31, price: 196900}, {date: 2021-08-02, price: 65600},
    {date: 2021-11-30, price: 65600}]},

    */

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
        title: const Text('Year Duty Fix'),
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

    for (var i = 2020; i <= _endYear; i++) {
      List<Widget> _list2 = [];
      for (var j = 0; j < _midashiList.length; j++) {
        _list2.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _midashiList[j],
                style: const TextStyle(fontSize: 12),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                  ),
                  Expanded(
                    child: Container(
                      child: _getSummaryMonthItem(
                        year: i.toString(),
                        midashi: _midashiList[j],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

        _list2.add(
          const Divider(
            color: Colors.white,
            height: 10,
          ),
        );
      }

      _list.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(2),
                decoration:
                    BoxDecoration(color: Colors.yellowAccent.withOpacity(0.3)),
                child: Text(i.toString()),
              ),
              Column(
                children: _list2,
              ),
            ],
          ),
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
  Widget _getSummaryMonthItem({required String year, required midashi}) {
    List<Widget> _list2 = [];

    int _sum = 0;

    if (_dutyDataMap[midashi][year] != null) {
      for (var i = 0; i < _dutyDataMap[midashi][year].length; i++) {
        _list2.add(
          Container(
            width: 70,
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    _dutyDataMap[midashi][year][i]['price'],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  _dutyDataMap[midashi][year][i]['date'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );

        var value =
            (_dutyDataMap[midashi][year][i]['price']).replaceAll(',', '');
        _sum += int.parse(value);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: _list2,
        ),
        Container(
          alignment: Alignment.topRight,
          child: Text(
            _utility.makeCurrencyDisplay(_sum.toString()),
            style: const TextStyle(
              color: Colors.yellowAccent,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
