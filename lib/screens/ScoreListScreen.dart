// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class ScoreListScreen extends StatefulWidget {
  String date;

  ScoreListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _ScoreListScreenState createState() => _ScoreListScreenState();
}

class _ScoreListScreenState extends State<ScoreListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  bool _loading = false;

  List<Map<dynamic, dynamic>> _scoreData = [];

  int startMoney = 1333926;

  int _allGain = 0;

  List<Map<dynamic, dynamic>> _benefitData = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  ///
  void _makeDefaultDisplayData() async {
    ///////////////////////////////////benefit
    await apiData.getBenefitOfAll();
    if (apiData.BenefitOfAll != null) {
      for (var i = 0; i < apiData.BenefitOfAll['data'].length; i++) {
        var exData = (apiData.BenefitOfAll['data'][i]).split('|');
        Map _map = {};
        _map['ym'] = exData[1];
        _map['benefit'] = exData[2];
        _benefitData.add(_map);
      }
    }
    apiData.BenefitOfAll = {};
    ///////////////////////////////////benefit
    //-----------------------------------//
    List<List<String>> _scoreDayInfo = [];

    await apiData.getMoneyOfAll();
    if (apiData.MoneyOfAll != null) {
      for (var i = 0; i < apiData.MoneyOfAll['data'].length; i++) {
        var exData2 = (apiData.MoneyOfAll['data'][i]).split('|');

        _utility.makeYMDYData(exData2[0], 0);
        if (_utility.day == '01') {
          //先月末の日付
          _utility.makeMonthEnd(
              int.parse(_utility.year), int.parse(_utility.month), 0);
          _utility.makeYMDYData(_utility.monthEndDateTime, 0);
          var prevMonthEnd =
              '${_utility.year}-${_utility.month}-${_utility.day}';

          //今月末の日付
          _utility.makeYMDYData(exData2[0], 0);
          _utility.makeMonthEnd(
              int.parse(_utility.year), int.parse(_utility.month) + 1, 0);
          _utility.makeYMDYData(_utility.monthEndDateTime, 0);
          var thisMonthEnd =
              '${_utility.year}-${_utility.month}-${_utility.day}';

          _scoreDayInfo.add([exData2[0], prevMonthEnd, thisMonthEnd]);
        }
      }
    }
    apiData.MoneyOfAll = {};
    //-----------------------------------//

    _scoreData = [];
    for (int i = 0; i < _scoreDayInfo.length; i++) {
      var dispMonth = "";
      var prevTotal = 0;
      var thisTotal = 0;
      for (int j = 0; j < _scoreDayInfo[i].length; j++) {
        if (j == 0) {
          _utility.makeYMDYData(_scoreDayInfo[i][0], 0);
          dispMonth = "${_utility.year}-${_utility.month}";
          continue;
        }

        await apiData.getMoneyOfDate(date: _scoreDayInfo[i][j]);
        if (apiData.MoneyOfDate != null) {
          if (apiData.MoneyOfDate['data'] != "-") {
            switch (j) {
              case 1: //先月末の日付
                prevTotal = startMoney;
                _utility.makeTotal(apiData.MoneyOfDate['data']);
                prevTotal = _utility.total;
                break;
              case 2: //今月末の日付
                thisTotal = 0;
                _utility.makeTotal(apiData.MoneyOfDate['data']);
                thisTotal = _utility.total;
                break;
            }
          }
        }

        apiData.MoneyOfDate = {};
      } //for[j]

      int _benefit = _getBenefit(ym: dispMonth);

      int _score = ((prevTotal - thisTotal) * -1);
      int _minus = (_benefit > 0) ? (_benefit - _score) : (_score * -1);

      var _map = {};
      _map['month'] = dispMonth;
      _map['prev_total'] = prevTotal.toString();
      _map['this_total'] = thisTotal.toString();
      _map['score'] = _score.toString();
      _map['benefit'] = _benefit.toString();
      _map['minus'] = _minus.toString();

      _scoreData.add(_map);
    } //for[i]

    //////////////////////////////////////////////////
    var scoreCount = _scoreData.length;
    for (var i = 0; i < scoreCount; i++) {
      var value = _scoreData[i];

      if (i == 0) {
        value['gain'] = value['score'];
        _allGain = int.parse(value['score']);
      } else if (i == (scoreCount - 1)) {
        value['gain'] = '';
      } else {
        _allGain += int.parse(value['score']);
        value['gain'] = _allGain;
      }
    }
    //////////////////////////////////////////////////
    setState(() {
      _loading = true;
    });
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Score List'),
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
          (_loading == false)
              ? Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : _scoreList(),
        ],
      ),
    );
  }

  ///
  Widget _scoreList() {
    return ListView.builder(
      itemCount: _scoreData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  ///
  Widget _listItem({required int position}) {
    if (position == _scoreData.length - 1) {
      return Container();
    }

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
            Text('${_scoreData[position]['month']}'),
            Table(
              children: [
                TableRow(children: [
                  Container(
                      alignment: Alignment.topRight,
                      child: const Text('start')),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text('${_scoreData[position]['prev_total']}')),
                  Container(
                      alignment: Alignment.topRight, child: const Text('end')),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text('${_scoreData[position]['this_total']}')),
                  Container(),
                  Container(),
                ]),
                TableRow(children: [
                  Container(
                      alignment: Alignment.topRight,
                      child: const Text('benefit')),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text('${_scoreData[position]['benefit']}')),
                  Container(
                      alignment: Alignment.topRight,
                      child: const Text('minus')),
                  Container(
                      alignment: Alignment.topRight,
                      child: Text('${_scoreData[position]['minus']}')),
                  Container(
                    alignment: Alignment.topRight,
                    child: const Text(
                      'score',
                      style: TextStyle(color: Colors.yellowAccent),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      '${_scoreData[position]['score']}',
                      style: const TextStyle(color: Colors.yellowAccent),
                    ),
                  ),
                ]),
                TableRow(children: [
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                  Container(
                    alignment: Alignment.topRight,
                    child: const Text(
                      'gain',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      '${_scoreData[position]['gain']}',
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ]),
              ],
            ),
          ],
        ),
      )),
    );
  }

  ///
  int _getBenefit({required String ym}) {
    int bene = 0;

    for (var i = 0; i < _benefitData.length; i++) {
      if (ym == _benefitData[i]['ym']) {
        bene = int.parse(_benefitData[i]['benefit']);
        break;
      }
    }

    return bene;
  }
}
