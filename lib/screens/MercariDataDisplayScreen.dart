// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields, unnecessary_null_comparison, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class MercariDataDisplayScreen extends StatefulWidget {
  @override
  _MercariDataDisplayScreenState createState() =>
      _MercariDataDisplayScreenState();
}

class _MercariDataDisplayScreenState extends State<MercariDataDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _mercariData = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //----------------------------//
    await apiData.getListOfMercariData();
    if (apiData.ListOfMercariData != null) {
      for (var i = 0; i < apiData.ListOfMercariData['data'].length; i++) {
        _mercariData.add(apiData.ListOfMercariData['data'][i]);
      }
    }
    apiData.ListOfMercariData = {};

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('mercari'),
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
          _mercariList(),
        ],
      ),
    );
  }

  /// リスト表示
  Widget _mercariList() {
    return ListView.builder(
      itemCount: _mercariData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    _utility.makeYMDYData(_mercariData[position]['date'], 0);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      '${_mercariData[position]['date']}（${_utility.youbiStr}）'),
                  Text(_utility.makeCurrencyDisplay(
                      _mercariData[position]['day_total'].toString())),
                ],
              ),
              _dispDailyItem(
                date: _mercariData[position]['date'],
                record: _mercariData[position]['record'],
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(_utility.makeCurrencyDisplay(
                        _mercariData[position]['total'].toString())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _dispDailyItem({date, record}) {
    var exRecord = (record).split('/');

    List<Widget> _list = [];
    for (var i = 0; i < exRecord.length; i++) {
      var exOneline = (exRecord[i]).split('|');

      _list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 40,
                child: _getBuySellMark(buy_sell: exOneline[0]),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${exOneline[1]}'),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              (exOneline[0] == 'sell')
                                  ? Text(_utility
                                      .makeCurrencyDisplay(exOneline[5]))
                                  : Text(
                                      '-${_utility.makeCurrencyDisplay(exOneline[5])}'),
                            ],
                          ),
                        ),
                        Container(
                          child: (exOneline[0] == 'sell')
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '販売日：${exOneline[6]}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '決済日：${exOneline[7]}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '決済日：${exOneline[7]}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '到着日：${exOneline[8]}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _list,
      ),
    );
  }

  ///
  Widget _getBuySellMark({buy_sell}) {
    switch (buy_sell) {
      case "sell":
        return const Icon(Icons.arrow_upward,
            size: 20, color: Colors.yellowAccent);
      case "buy":
        return const Icon(Icons.arrow_downward,
            size: 20, color: Colors.redAccent);
    }
    return Container();
  }
}
