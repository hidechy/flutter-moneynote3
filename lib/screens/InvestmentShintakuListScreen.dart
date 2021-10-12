// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class InvestmentShintakuListScreen extends StatefulWidget {
  @override
  _InvestmentShintakuListScreenState createState() =>
      _InvestmentShintakuListScreenState();
}

class _InvestmentShintakuListScreenState
    extends State<InvestmentShintakuListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _shintakuDetailData = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    await apiData.getListOfShintakuDetailData();
    if (apiData.ListOfShintakuDetailData != null) {
      for (var i = 0;
          i < apiData.ListOfShintakuDetailData['data'].length;
          i++) {
        var exData = (apiData.ListOfShintakuDetailData['data'][i]).split(';');

        Map _map = {};
        _map['name'] = exData[0];
        _map['date'] = exData[1];
        _map['suuryou'] = exData[2];
        _map['cost'] = exData[3];
        _map['result'] = exData[4];
        _map['score'] = exData[5];
        _map['data'] = exData[6];
        _shintakuDetailData.add(_map);
      }
    }
    apiData.ListOfShintakuDetailData = {};

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
          _shintakuList(),
        ],
      ),
    );
  }

  ///
  Widget _shintakuList() {
    return ListView.builder(
      itemCount: _shintakuDetailData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  ///
  Widget _listItem({required int position}) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_shintakuDetailData[position]['name']}'),
              Container(
                decoration:
                    BoxDecoration(color: Colors.yellowAccent.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 60,
                      child:
                          Text('${_shintakuDetailData[position]['suuryou']}'),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text('${_shintakuDetailData[position]['cost']}'),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text('${_shintakuDetailData[position]['result']}'),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text('${_shintakuDetailData[position]['score']}'),
                    ),
                    Text('${_shintakuDetailData[position]['date']}'),
                  ],
                ),
              ),
              const Divider(color: Colors.indigo),
              _dispDetail(data: _shintakuDetailData[position]['data']),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _dispDetail({data}) {
    List<Widget> _list = [];

    var exData = (data).split('/');
    for (var i = 0; i < exData.length; i++) {
      var exValue = (exData[i]).split('|');
      _list.add(
        Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              child: Text('${exValue[2]}'),
            ),
            SizedBox(
              width: 60,
              child: Text('${exValue[3]}'),
            ),
            SizedBox(
              width: 60,
              child: Text('${exValue[4]}'),
            ),
            SizedBox(
              width: 60,
              child: Text('${exValue[5]}'),
            ),
            Text('${exValue[0]}'),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(
        children: _list,
      ),
    );
  }
}
