// ignore_for_file: file_names, must_be_immutable, prefer_final_fields, unnecessary_null_comparison, non_constant_identifier_names

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

class SeiyuuItemListScreen extends StatefulWidget {
  String date;

  SeiyuuItemListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _SeiyuuItemListScreenState createState() => _SeiyuuItemListScreenState();
}

class Seiyuu {
  bool isExpanded;
  String item;
  List data;

  Seiyuu({required this.isExpanded, required this.item, required this.data});
}

class _SeiyuuItemListScreenState extends State<SeiyuuItemListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Seiyuu> _seiyuuCurrentItemList = <Seiyuu>[];
  List<Seiyuu> _seiyuuNotBuyItemList = <Seiyuu>[];

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    await apiData.getSeiyuuPurchaseItemOfDate(date: widget.date);
    if (apiData.SeiyuuPurchaseItemOfDate != null) {
      for (var i = 0;
          i < apiData.SeiyuuPurchaseItemOfDate["data"].length;
          i++) {
        var exData = (apiData.SeiyuuPurchaseItemOfDate["data"][i]).split(':');
        List _list = [];
        var exDatedata = (exData[1]).split('/');
        for (var j = 0; j < exDatedata.length; j++) {
          var exDd = (exDatedata[j]).split('|');
          Map _map = {};
          _map['date'] = exDd[0];
          _map['tanka'] = exDd[1];
          _map['kosuu'] = exDd[2];
          _map['price'] = exDd[3];
          _list.add(_map);
        }
        _seiyuuCurrentItemList
            .add(Seiyuu(isExpanded: false, item: exData[0], data: _list));
      }

      for (var i = 0;
          i < apiData.SeiyuuPurchaseItemOfDate["data2"].length;
          i++) {
        var exData = (apiData.SeiyuuPurchaseItemOfDate["data2"][i]).split(':');
        List _list = [];
        var exDatedata = (exData[1]).split('/');
        for (var j = 0; j < exDatedata.length; j++) {
          var exDd = (exDatedata[j]).split('|');
          Map _map = {};
          _map['date'] = exDd[0];
          _map['tanka'] = exDd[1];
          _map['kosuu'] = exDd[2];
          _map['price'] = exDd[3];
          _list.add(_map);
        }
        _seiyuuNotBuyItemList
            .add(Seiyuu(isExpanded: false, item: exData[0], data: _list));
      }
    }
    apiData.SeiyuuPurchaseItemOfDate = {};

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var oneHeight = ((size.height) / 2) - 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        title: const Text('Seiyuu Items'),
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _goSeiyuuItemListScreen(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('最近購入したもの'),
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
                          _seiyuuCurrentItemList[index].isExpanded =
                              !_seiyuuCurrentItemList[index].isExpanded;
                          setState(() {});
                        },
                        children:
                            _seiyuuCurrentItemList.map(_createPanel).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('最近購入しないもの'),
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
                          _seiyuuNotBuyItemList[index].isExpanded =
                              !_seiyuuNotBuyItemList[index].isExpanded;
                          setState(() {});
                        },
                        children:
                            _seiyuuNotBuyItemList.map(_createPanel2).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  ExpansionPanel _createPanel(Seiyuu __SEIYUU) {
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
              __SEIYUU.item,
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
        child: _getSeiyuuDataColumn(data: __SEIYUU.data),
      ),
      //
      isExpanded: __SEIYUU.isExpanded,
    );
  }

  ///
  ExpansionPanel _createPanel2(Seiyuu __SEIYUU) {
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
              __SEIYUU.item,
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
        child: _getSeiyuuDataColumn(data: __SEIYUU.data),
      ),
      //
      isExpanded: __SEIYUU.isExpanded,
    );
  }

  ///
  Widget _getSeiyuuDataColumn({data}) {
    List<Widget> _list = [];

    for (var i = 0; i < data.length; i++) {
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
              SizedBox(width: 60, child: Text('${data[i]['date']}')),
              Container(
                  alignment: Alignment.topRight,
                  width: 50,
                  child: Text(_utility.makeCurrencyDisplay(data[i]['tanka']))),
              Container(
                  alignment: Alignment.topRight,
                  width: 30,
                  child: Text('${data[i]['kosuu']}')),
              Container(
                  alignment: Alignment.topRight,
                  width: 60,
                  child: Text(_utility.makeCurrencyDisplay(data[i]['price']))),
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
  _goSeiyuuItemListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SeiyuuItemListScreen(
          date: widget.date,
        ),
      ),
    );
  }
}
