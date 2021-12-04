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
  Map<dynamic, dynamic> _dutyDataMap = {};

  bool _loading = false;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    _midashiList.add('所得税');
    _midashiList.add('住民税');
    _midashiList.add('年金');
    _midashiList.add('国民年金基金');
    _midashiList.add('国民健康保険');

    await apiData.getListOfDutyData();
    _dutyDataMap = apiData.ListOfDutyData['data'];
    apiData.ListOfDutyData = {};

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
        title: const Text('Duty Fixed Cost'),
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
              : _dutyList(context: context),
        ],
      ),
    );
  }

  ///
  Widget _dutyList({context}) {
    List<Widget> _list = [];

    for (var i = 0; i < _midashiList.length; i++) {
      _list.add(
        DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_midashiList[i]),
              Container(
                height: 100,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                // child: ListView(
                //   children: _makeDutyItemList(midashi: _midashiList[i]),
                // ),
                child: _makeDutyItemList(midashi: _midashiList[i]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: _list),
          ),
        ),
      ],
    );
  }

  ///
  Widget _makeDutyItemList({required String midashi}) {
    List<Widget> _list = [];

    for (var i = 0; i < _dutyDataMap[midashi].length; i++) {
      var exValue = (_dutyDataMap[midashi][i]).split('|');

      _list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(exValue[0]),
            Text(exValue[1]),
          ],
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
