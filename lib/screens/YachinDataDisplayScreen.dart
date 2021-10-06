// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class YachinDataDisplayScreen extends StatefulWidget {
  @override
  _YachinDataDisplayScreenState createState() =>
      _YachinDataDisplayScreenState();
}

class _YachinDataDisplayScreenState extends State<YachinDataDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _yachinData = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    await apiData.getListOfHomeFixData();
    if (apiData.ListOfHomeFixData != null) {
      for (var i = 0; i < apiData.ListOfHomeFixData['data'].length; i++) {
        var exData = (apiData.ListOfHomeFixData['data'][i]).split('|');

        Map _map = {};

        _map['ym'] = exData[0];
        _map['yachin'] = exData[1];
        _map['wifi'] = exData[2];
        _map['mobile'] = exData[3];
        _map['gas'] = exData[4];
        _map['denki'] = exData[5];
        _map['suidou'] = exData[6];

        _yachinData.add(_map);
      }
    }
    apiData.ListOfHomeFixData = {};

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('家計固定費'),
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
          Column(
            children: <Widget>[
              Expanded(
                child: _yachinList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// リスト表示
  Widget _yachinList() {
    return ListView.builder(
      itemCount: _yachinData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /// リストアイテム表示
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
              Text('${_yachinData[position]['ym']}'),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(FontAwesomeIcons.home, size: 12),
                  ),
                  Text('${_yachinData[position]['yachin']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(FontAwesomeIcons.wifi, size: 12),
                  ),
                  Text('${_yachinData[position]['wifi']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(FontAwesomeIcons.mobileAlt, size: 12),
                  ),
                  Text('${_yachinData[position]['mobile']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(FontAwesomeIcons.bolt, size: 12),
                  ),
                  Text('${_yachinData[position]['denki']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(FontAwesomeIcons.burn, size: 12),
                  ),
                  Text('${_yachinData[position]['gas']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(FontAwesomeIcons.tint, size: 12),
                  ),
                  Text('${_yachinData[position]['suidou']}')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
