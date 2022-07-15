// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields, unnecessary_null_comparison, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class WellsDataDisplayScreen extends StatefulWidget {
  @override
  _WellsDataDisplayScreenState createState() => _WellsDataDisplayScreenState();
}

class _WellsDataDisplayScreenState extends State<WellsDataDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  var _wellsDataList = <Wells>[];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    await apiData.getListOfWellsData();
    if (apiData.ListOfWellsData != null) {
      for (var i = 0; i < apiData.ListOfWellsData["data"].length; i++) {
        var exData = (apiData.ListOfWellsData["data"][i]).split(':');
        List _list = [];
        var exDatedata = (exData[1]).split('/');
        for (var j = 0; j < exDatedata.length; j++) {
          var exDd = (exDatedata[j]).split('|');
          Map _map = {};
          _map['num'] = exDd[0];
          _map['monthday'] = exDd[1];
          _map['price'] = exDd[2];
          _map['total'] = exDd[3];
          _list.add(_map);
        }
        _wellsDataList
            .add(Wells(isExpanded: false, year: exData[0], data: _list));
      }
    }
    apiData.ListOfWellsData = {};

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

//    var oneHeight = ((size.height) / 2) - 100;
    var oneHeight = (size.height - 100);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Wells Data'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: const Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goWellsDataDisplayScreen(),
            color: Colors.greenAccent,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
          SizedBox(
            height: oneHeight,
            child: ListView(
              children: <Widget>[
                Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: Colors.black.withOpacity(0.1),
                  ),
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      _wellsDataList[index].isExpanded =
                          !_wellsDataList[index].isExpanded;
                      setState(() {});
                    },
                    children: _wellsDataList.map(_createPanel).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  ExpansionPanel _createPanel(Wells __WELLS) {
    return ExpansionPanel(
      canTapOnHeader: true,
      //
      headerBuilder: (BuildContext context, bool isExpanded) {
        return Container(
          color: Colors.black.withOpacity(0.3),
          padding: const EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 12),
            child: Text(
              __WELLS.year,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
      //
      body: Container(
        width: double.infinity,
        color: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.all(10),
        child: _getWellsDataColumn(data: __WELLS.data),
      ),
      //
      isExpanded: __WELLS.isExpanded,
    );
  }

  ///
  Widget _getWellsDataColumn({data}) {
    List<Widget> _list = [];

    var _loopNum = (data.length / 2).ceil();
    for (var i = 0; i < _loopNum; i++) {
      var _number = (i * 2);
      _list.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        '${data[_number]['num']}',
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text('${data[_number]['monthday']}'),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: (data[_number]['price'] == "")
                          ? const Text('')
                          : Text(_utility
                              .makeCurrencyDisplay(data[_number]['price'])),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.topRight,
                      child: (data[_number]['total'] == "")
                          ? const Text('')
                          : Text(_utility
                              .makeCurrencyDisplay(data[_number]['total'])),
                    ),
                  ],
                ),
              ),
              (_number + 1 >= data.length)
                  ? Expanded(child: Container())
                  : Expanded(
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              '${data[_number + 1]['num']}',
                              style: const TextStyle(color: Colors.greenAccent),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('${data[_number + 1]['monthday']}'),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10),
                            child: (data[_number + 1]['price'] == "")
                                ? const Text('')
                                : Text(_utility.makeCurrencyDisplay(
                                    data[_number + 1]['price'])),
                          ),
                          Container(
                            width: 50,
                            alignment: Alignment.topRight,
                            child: (data[_number + 1]['total'] == "")
                                ? const Text('')
                                : Text(_utility.makeCurrencyDisplay(
                                    data[_number + 1]['total'])),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
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

  ///
  _goWellsDataDisplayScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WellsDataDisplayScreen(),
      ),
    );
  }
}

class Wells {
  bool isExpanded;
  String year;
  List data;

  Wells({required this.isExpanded, required this.year, required this.data});
}
