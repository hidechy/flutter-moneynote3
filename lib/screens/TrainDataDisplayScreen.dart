// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class TrainDataDisplayScreen extends StatefulWidget {
  const TrainDataDisplayScreen({Key? key}) : super(key: key);

  @override
  _TrainDataDisplayScreenState createState() => _TrainDataDisplayScreenState();
}

class _TrainDataDisplayScreenState extends State<TrainDataDisplayScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _trainData = [];

  ItemScrollController _itemScrollController = ItemScrollController();

  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  int maxNo = 0;

  Map<String, dynamic> _holidayList = {};

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    //----------------------------//
    await apiData.getListOfTrainData();
    if (apiData.ListOfTrainData != null) {
      apiData.ListOfTrainData['data'].forEach((key, value) {
        Map _map = {};
        _map['date'] = key;

        if (value == '') {
          _map['value'] = '';
          _map['price'] = '';
          _map['oufuku'] = '';
        } else {
          var exValue = (value).split('|');
          _map['value'] = exValue[0];
          _map['price'] = (exValue[1] != '') ? exValue[1] : '';
          _map['oufuku'] = exValue[2];
        }

        _trainData.add(_map);
      });
    }
    apiData.ListOfTrainData = {};
    //----------------------------//

    //----------------------------//
    await apiData.getHolidayOfAll();
    if (apiData.HolidayOfAll != null) {
      for (var i = 0; i < apiData.HolidayOfAll['data'].length; i++) {
        _holidayList[apiData.HolidayOfAll['data'][i]] = '';
      }
    }
    apiData.HolidayOfAll = {};
    //----------------------------//

    maxNo = _trainData.length;

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Train List'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward),
          color: Colors.greenAccent,
          onPressed: () => _scroll(),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goTrainDataDisplayScreen(),
            color: Colors.greenAccent,
          ),
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
                child: _trainList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  void _scroll() {
    _itemScrollController.scrollTo(
      index: maxNo,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  /// リスト表示
  Widget _trainList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index);
      },
      itemCount: _trainData.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  ///
  Widget _listItem({required int position}) {
    _utility.makeYMDYData(_trainData[position]['date'], 0);

    return (_trainData[position]['value'] == '')
        ? Row(
            children: <Widget>[
              Container(
                width: 100,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _utility.getBgColor(
                      _trainData[position]['date'], _holidayList),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Text(
                  '${_trainData[position]['date']}（${_utility.youbiStr}）',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          )
        : Card(
            color:
                _utility.getBgColor(_trainData[position]['date'], _holidayList),
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
                title: DefaultTextStyle(
              style: const TextStyle(fontSize: 12),
              child: Table(
                children: [
                  TableRow(children: [
                    Text(
                        '${_utility.year}-${_utility.month}-${_utility.day}（${_utility.youbiStr}）'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${_trainData[position]['value']}'),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 80,
                              alignment: Alignment.topCenter,
                              child: (_trainData[position]['oufuku'] == '1')
                                  ? const Text('＜往復＞')
                                  : const Text('＜片道＞'),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Text(_utility.makeCurrencyDisplay(
                                    _trainData[position]['price'])),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            )),
          );
  }

  ///
  void _goTrainDataDisplayScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const TrainDataDisplayScreen(),
      ),
    );
  }
}
