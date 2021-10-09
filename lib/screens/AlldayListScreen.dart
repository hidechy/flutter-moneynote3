// ignore_for_file: unnecessary_null_comparison, file_names, import_of_legacy_library_into_null_safe, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:http/http.dart';

import 'dart:convert';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class AlldayListScreen extends StatefulWidget {
  final String date;

  const AlldayListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _AlldayListScreenState createState() => _AlldayListScreenState();
}

class _AlldayListScreenState extends State<AlldayListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  bool _loading = false;

  List<Map<dynamic, dynamic>> _alldayData = [];

  Map<String, dynamic> _holidayList = {};

  ItemScrollController _itemScrollController = ItemScrollController();

  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  int maxNo = 0;

  List<Map<dynamic, dynamic>> _ymList = [];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //------------------------------//

    Map zerousedate = {};

    String url = "http://toyohide.work/BrainLog/api/timeplacezerousedate";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);
      zerousedate = data;
    }
    //------------------------------//

    //全データ取得
    await apiData.getMoneyOfAll();
    if (apiData.MoneyOfAll != null) {
      int _keepTotal = 0;
      int total = 0;

      var _ym = "";

      for (var i = 0; i < apiData.MoneyOfAll['data'].length; i++) {
        var exData = (apiData.MoneyOfAll['data'][i]).split('|');

        //-------------------------------------//
        List _list = [];
        for (var l = 2; l <= 21; l++) {
          _list.add(exData[l]);
        }
        _utility.makeTotal(_list.join('|'));
        total = _utility.total;
        //-------------------------------------//

        var _map = {};
        _map['date'] = exData[0];
        _map['total'] = total.toString();
        _map['pos'] = i;
        _map['diff'] = ((_keepTotal - total) * -1).toString();

        _map['zeroflag'] = _getZeroUseDate(
          date: exData[0],
          zerousedate: zerousedate,
        );

        _alldayData.add(_map);

        _keepTotal = total;

        //----------------------//
        var exDate2 = (exData[0]).split('-');
        if (_ym != "${exDate2[0]}-${exDate2[1]}") {
          var _map2 = {};
          _map2['ym'] = "${exDate2[0]}-${exDate2[1]}";
          _map2['pos'] = i;
          _ymList.add(_map2);
        }
        _ym = "${exDate2[0]}-${exDate2[1]}";
        //----------------------//

      }
    }
    apiData.MoneyOfAll = {};

    maxNo = _alldayData.length;

    //----------------------------//
    await apiData.getHolidayOfAll();
    if (apiData.HolidayOfAll != null) {
      for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
        _holidayList[apiData.HolidayOfAll['data'][i]] = '';
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    setState(() {
      _loading = true;
    });
  }

  ///
  int _getZeroUseDate({date, required Map zerousedate}) {
    var _num = 0;
    for (var i = 0; i < zerousedate['data'].length; i++) {
      if (zerousedate['data'][i] == date) {
        _num = 1;
        break;
      }
    }
    return _num;
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
//      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Allday List'),
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
            icon: const Icon(Icons.arrow_downward),
            color: Colors.greenAccent,
            onPressed: () => _scroll(pos: maxNo),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.greenAccent,
            onPressed: () => _goAlldayListScreen(context),
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
              : _dispPageContent(),
        ],
      ),
    );
  }

  ///
  Widget _dispPageContent() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
          child: Wrap(
            children: _makeYmBtn(),
          ),
        ),
        const Divider(color: Colors.indigo),
        Expanded(
          child: ScrollablePositionedList.builder(
            itemBuilder: (context, index) {
              return _listItem(position: index);
            },
            itemCount: _alldayData.length,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
          ),
        ),
      ],
    );
  }

  /// リストアイテム表示
  Widget _listItem({required int position}) {
    _utility.makeYMDYData(_alldayData[position]['date'], 0);

    return Card(
      color: _utility.getBgColor(_alldayData[position]['date'], _holidayList),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 10.0),
          child: Table(
            children: [
              TableRow(children: [
                Text('${_alldayData[position]['date']}（${_utility.youbiStr}）'),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(_utility
                      .makeCurrencyDisplay(_alldayData[position]['total'])),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Text(_utility
                      .makeCurrencyDisplay(_alldayData[position]['diff'])),
                ),
              ]),
            ],
          ),
        ),
        trailing: (_alldayData[position]['zeroflag'] == 1)
            ? Icon(
                Icons.star,
                color: Colors.greenAccent.withOpacity(0.5),
                size: 10,
              )
            : const Icon(
                Icons.check_box_outline_blank,
                color: Color(0xFF2e2e2e),
                size: 10,
              ),
      ),
    );
  }

  ///
  void _scroll({required int pos}) {
    _itemScrollController.scrollTo(
      index: pos,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  ///
  List<Widget> _makeYmBtn() {
    List<Widget> _btnList = [];
    for (var i = 0; i < _ymList.length; i++) {
      _btnList.add(
        GestureDetector(
          onTap: () => _scroll(pos: _ymList[i]['pos']),
          child: Container(
            color: Colors.green[900]!.withOpacity(0.5),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '${_ymList[i]['ym']}',
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
      );
    }
    return _btnList;
  }

  ///
  void _goAlldayListScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AlldayListScreen(
          date: widget.date,
        ),
      ),
    );
  }
}
