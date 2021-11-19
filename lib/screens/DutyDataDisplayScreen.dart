// ignore_for_file: file_names, prefer_final_fields, unnecessary_null_comparison

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
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _zeikinData = [];
  List<Map<dynamic, dynamic>> _nenkinData = [];
  List<Map<dynamic, dynamic>> _nenkinkikinData = [];
  List<Map<dynamic, dynamic>> _kenkouhokenData = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    await apiData.getListOfDutyData();
    if (apiData.ListOfDutyData != null) {
      for (var i = 0; i < apiData.ListOfDutyData['data']['税金'].length; i++) {
        var exData = apiData.ListOfDutyData['data']['税金'][i].split('|');
        Map _map = {};
        _map['date'] = exData[0];
        _map['price'] = exData[1];
        _zeikinData.add(_map);
      }

      for (var i = 0; i < apiData.ListOfDutyData['data']['年金'].length; i++) {
        var exData = apiData.ListOfDutyData['data']['年金'][i].split('|');
        Map _map = {};
        _map['date'] = exData[0];
        _map['price'] = exData[1];
        _nenkinData.add(_map);
      }

      for (var i = 0;
      i < apiData.ListOfDutyData['data']['国民年金基金'].length;
      i++) {
        var exData = apiData.ListOfDutyData['data']['国民年金基金'][i].split('|');
        Map _map = {};
        _map['date'] = exData[0];
        _map['price'] = exData[1];
        _nenkinkikinData.add(_map);
      }

      for (var i = 0;
      i < apiData.ListOfDutyData['data']['国民健康保険'].length;
      i++) {
        var exData = apiData.ListOfDutyData['data']['国民健康保険'][i].split('|');
        Map _map = {};
        _map['date'] = exData[0];
        _map['price'] = exData[1];
        _kenkouhokenData.add(_map);
      }
    }
    apiData.ListOfDutyData = {};

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var _oneListHeight = ((size.height - 150) / 4).floor();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Duty Data'),
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
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('税金'),
                  Container(
                    height: double.parse(_oneListHeight.toString()),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: ListView(
                      children: _makeZeikinList(),
                    ),
                  ),
                  const Text('年金'),
                  Container(
                    height: double.parse(_oneListHeight.toString()),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: ListView(
                      children: _makeNenkinList(),
                    ),
                  ),
                  const Text('国民年金基金'),
                  Container(
                    height: double.parse(_oneListHeight.toString()),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: ListView(
                      children: _makeNenkinkikinList(),
                    ),
                  ),
                  const Text('国民健康保険'),
                  Container(
                    height: double.parse(_oneListHeight.toString()),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: ListView(
                      children: _makeKenkouhokenList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  List<Widget> _makeZeikinList() {
    List<Widget> _dataList = [];
    for (var i = 0; i < _zeikinData.length; i++) {
      _dataList.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${_zeikinData[i]['date']}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  _utility.makeCurrencyDisplay(_zeikinData[i]['price']),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _dataList;
  }

  ///
  List<Widget> _makeNenkinList() {
    List<Widget> _dataList = [];
    for (var i = 0; i < _nenkinData.length; i++) {
      _dataList.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${_nenkinData[i]['date']}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  _utility.makeCurrencyDisplay(_nenkinData[i]['price']),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _dataList;
  }

  ///
  List<Widget> _makeNenkinkikinList() {
    List<Widget> _dataList = [];
    for (var i = 0; i < _nenkinkikinData.length; i++) {
      _dataList.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${_nenkinkikinData[i]['date']}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  _utility.makeCurrencyDisplay(_nenkinkikinData[i]['price']),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _dataList;
  }

  ///
  List<Widget> _makeKenkouhokenList() {
    List<Widget> _dataList = [];
    for (var i = 0; i < _kenkouhokenData.length; i++) {
      _dataList.add(
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                '${_kenkouhokenData[i]['date']}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: Text(
                  _utility.makeCurrencyDisplay(_kenkouhokenData[i]['price']),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return _dataList;
  }
}
