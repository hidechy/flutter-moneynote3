// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneynote5/screens/YachinDataDisplayScreen.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class YearHomeFixScreen extends StatefulWidget {
  const YearHomeFixScreen({Key? key}) : super(key: key);

  ///
  @override
  _YearHomeFixScreenState createState() => _YearHomeFixScreenState();
}

class _YearHomeFixScreenState extends State<YearHomeFixScreen> {
  final Utility _utility = Utility();

  ApiData apiData = ApiData();

  final Map<dynamic, dynamic> _homeFixData = {};

  final List<dynamic> _midashiList = [];
  final Map<String, dynamic> _midashiIcon = {};

  int _endYear = 0;

  bool _loading = false;

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

    _midashiList.add('home');
    _midashiList.add('wifi');
    _midashiList.add('mobile');
    _midashiList.add('gas');
    _midashiList.add('electric');
    _midashiList.add('water');

    _midashiIcon['home'] =
        const Icon(FontAwesomeIcons.home, size: 12, color: Colors.greenAccent);
    _midashiIcon['wifi'] =
        const Icon(FontAwesomeIcons.wifi, size: 12, color: Colors.greenAccent);
    _midashiIcon['mobile'] = const Icon(FontAwesomeIcons.mobileAlt,
        size: 12, color: Colors.greenAccent);
    _midashiIcon['gas'] =
        const Icon(FontAwesomeIcons.burn, size: 12, color: Colors.greenAccent);
    _midashiIcon['electric'] =
        const Icon(FontAwesomeIcons.bolt, size: 12, color: Colors.greenAccent);
    _midashiIcon['water'] =
        const Icon(FontAwesomeIcons.tint, size: 12, color: Colors.greenAccent);

    await apiData.getListOfHomeFixData();

    RegExp reg = RegExp("(.+) ((.+))");

    var mapHome = {};
    var listHome = [];

    var mapWifi = {};
    var listWifi = [];

    var mapMobile = {};
    var listMobile = [];

    var mapGas = {};
    var listGas = [];

    var mapElectric = {};
    var listElectric = [];

    var mapWater = {};
    var listWater = [];

    for (var i = 0; i < apiData.ListOfHomeFixData['data'].length; i++) {
      var exValue = (apiData.ListOfHomeFixData['data'][i]).split('|');

      // ym
      var _ym = (exValue[0]).split('-');

      if (_ym[1] == '01') {
        listHome = [];
        listWifi = [];
        listMobile = [];
        listGas = [];
        listElectric = [];
        listWater = [];
      }

      //------------------------------// home
      if (exValue[1] != '') {
        var exVal1 = (exValue[1]).split(' / ');
        for (var j = 0; j < exVal1.length; j++) {
          var match = reg.firstMatch(exVal1[j]);
          if (match != null) {
            Map dataHome = {};
            dataHome['date'] =
                '${exValue[0]}-${match.group(2)!.replaceAll('(', '').replaceAll(')', '')}';
            dataHome['price'] = match.group(1);
            listHome.add(dataHome);
          }
        }
      }
      mapHome[_ym[0]] = listHome;
      //------------------------------// home

      //------------------------------// wifi
      if (exValue[2] != '') {
        var exVal2 = (exValue[2]).split(' / ');
        for (var j = 0; j < exVal2.length; j++) {
          var match = reg.firstMatch(exVal2[j]);
          if (match != null) {
            Map dataWifi = {};
            dataWifi['date'] =
                '${exValue[0]}-${match.group(2)!.replaceAll('(', '').replaceAll(')', '')}';
            dataWifi['price'] = match.group(1);
            listWifi.add(dataWifi);
          }
        }
      }
      mapWifi[_ym[0]] = listWifi;
      //------------------------------// wifi

      //------------------------------// mobile
      if (exValue[3] != '') {
        var exVal3 = (exValue[3]).split(' / ');
        for (var j = 0; j < exVal3.length; j++) {
          var match = reg.firstMatch(exVal3[j]);
          if (match != null) {
            Map dataMobile = {};
            dataMobile['date'] =
                '${exValue[0]}-${match.group(2)!.replaceAll('(', '').replaceAll(')', '')}';
            dataMobile['price'] = match.group(1);
            listMobile.add(dataMobile);
          }
        }
      }
      mapMobile[_ym[0]] = listMobile;
      //------------------------------// mobile

      //------------------------------// gas
      if (exValue[4] != '') {
        var exVal4 = (exValue[4]).split(' / ');
        for (var j = 0; j < exVal4.length; j++) {
          var match = reg.firstMatch(exVal4[j]);
          if (match != null) {
            Map dataGas = {};
            dataGas['date'] =
                '${exValue[0]}-${match.group(2)!.replaceAll('(', '').replaceAll(')', '')}';
            dataGas['price'] = match.group(1);
            listGas.add(dataGas);
          }
        }
      }
      mapGas[_ym[0]] = listGas;
      //------------------------------// gas

      //------------------------------// electric
      if (exValue[5] != '') {
        var exVal5 = (exValue[5]).split(' / ');
        for (var j = 0; j < exVal5.length; j++) {
          var match = reg.firstMatch(exVal5[j]);
          if (match != null) {
            Map dataElectric = {};
            dataElectric['date'] =
                '${exValue[0]}-${match.group(2)!.replaceAll('(', '').replaceAll(')', '')}';
            dataElectric['price'] = match.group(1);
            listElectric.add(dataElectric);
          }
        }
      }
      mapElectric[_ym[0]] = listElectric;
      //------------------------------// electric

      //------------------------------// water
      if (exValue[6] != '') {
        var exVal6 = (exValue[6]).split(' / ');
        for (var j = 0; j < exVal6.length; j++) {
          var match = reg.firstMatch(exVal6[j]);
          if (match != null) {
            Map dataWater = {};
            dataWater['date'] =
                '${exValue[0]}-${match.group(2)!.replaceAll('(', '').replaceAll(')', '')}';
            dataWater['price'] = match.group(1);
            listWater.add(dataWater);
          }
        }
      }
      mapWater[_ym[0]] = listWater;
      //------------------------------// water
    }

    _homeFixData['home'] = mapHome;
    _homeFixData['wifi'] = mapWifi;
    _homeFixData['mobile'] = mapMobile;
    _homeFixData['gas'] = mapGas;
    _homeFixData['electric'] = mapElectric;
    _homeFixData['water'] = mapWater;

    apiData.ListOfHomeFixData = {};

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
        title: const Text('Year Home Fix'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () => _goYachinDataDisplayScreen(),
          color: Colors.greenAccent,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                alignment: Alignment.topLeft,
                child: _midashiIcon[_midashiList[j]],
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

    for (var i = 0; i < _homeFixData[midashi][year].length; i++) {
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
                  _homeFixData[midashi][year][i]['price'],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Text(
                _homeFixData[midashi][year][i]['date'],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

      var value = (_homeFixData[midashi][year][i]['price']).replaceAll(',', '');
      _sum += int.parse(value);
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

  ///////////////////////////////////////////////

  ///
  void _goYachinDataDisplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YachinDataDisplayScreen(),
      ),
    );
  }
}
