// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class FundDataDisplayScreen extends StatefulWidget {
  @override
  _FundDataDisplayScreenState createState() => _FundDataDisplayScreenState();
}

class _FundDataDisplayScreenState extends State<FundDataDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  Map funddata = {};

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //----------------------------//
    await apiData.getListOfFundData();
    if (apiData.ListOfFundData != null) {
      funddata = apiData.ListOfFundData;
    }
    apiData.ListOfFundData = {};
    //----------------------------//

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Fund Data'),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _fundList(),
          ),
        ],
      ),
    );
  }

  ///
  Widget _fundList() {
    if (funddata['data'] != null) {
      return ListView.builder(
        itemCount: funddata['data'].length,
        itemBuilder: (context, int position) => _listItem(position: position),
      );
    } else {
      return Container();
    }
  }

  ///
  Widget _listItem({required int position}) {
    var exFunddata = (funddata['data'][position]).split(':');

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
              Text('${exFunddata[0]}'),
              const Divider(color: Colors.indigo),
              _dispFundData(data: exFunddata[1]),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _dispFundData({data}) {
    var exData = (data).split('/');

    List<Widget> _list = [];

    for (var i = 0; i < exData.length; i++) {
      var exLine = (exData[i]).split('|');

      _list.add(
        Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Text('${exLine[0]}'),
            ),
            SizedBox(
              width: 50,
              child: Text('${exLine[1]}'),
            ),
            SizedBox(
              width: 100,
              child: Text(
                '${exLine[2]}',
                style: TextStyle(
                    color: (exLine[4] == '1')
                        ? Colors.yellowAccent
                        : Colors.white),
              ),
            ),
            Text('${exLine[3]}'),
          ],
        ),
      );
    }

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _list,
      ),
    );
  }
}
