// ignore_for_file: file_names, import_of_legacy_library_into_null_safe, must_be_immutable, unnecessary_null_comparison, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../data/ApiData.dart';

import 'AllCreditItemListScreen.dart';
import 'AmazonPurchaseListScreen.dart';
import 'SeiyuuPurchaseListScreen.dart';

class AllCreditListScreen extends StatefulWidget {
  String date;

  AllCreditListScreen({Key? key, required this.date}) : super(key: key);

  @override
  _AllCreditListScreenState createState() => _AllCreditListScreenState();
}

class _AllCreditListScreenState extends State<AllCreditListScreen> {
  Utility _utility = Utility();
  ApiData apiData = ApiData();

  List<Map<dynamic, dynamic>> _creditCardSpendData = [];

  ItemScrollController _itemScrollController = ItemScrollController();

  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  int maxNo = 0;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    await apiData.getListOfCardSpendData();
    if (apiData.ListOfCardSpendData != null) {
      for (var i = 0; i < apiData.ListOfCardSpendData['data'].length; i++) {
        _creditCardSpendData.add(apiData.ListOfCardSpendData['data'][i]);
      }
    }
    apiData.ListOfCardSpendData = {};

    maxNo = _creditCardSpendData.length;

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
//      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('All Credit（日付順）'),
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
              Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Table(
                  children: [
                    TableRow(children: [
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.list),
                            onPressed: () => _goAllCreditItemListScreen(),
                            color: Colors.greenAccent,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_downward),
                            color: Colors.greenAccent,
                            onPressed: () => _scroll(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.amazon),
                            color: Colors.greenAccent,
                            onPressed: () => _goAmazonPurchaseListScreen(),
                          ),
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.bullseye),
                            color: Colors.greenAccent,
                            onPressed: () => _goSeiyuuPurchaseListScreen(),
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
              Expanded(
                child: _creditCardSpendList(),
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

  ///
  Widget _creditCardSpendList() {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index);
      },
      itemCount: _creditCardSpendData.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  ///
  Widget _listItem({required int position}) {
    var exPm = (_creditCardSpendData[position]['pay_month']).split('-');

    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: _getLeadingBgColor(month: exPm[1]),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${exPm[0]}'),
              Text('${exPm[1]}'),
            ],
          ),
        ),
        trailing:
            _getCreditTrailing(kind: _creditCardSpendData[position]['kind']),
        title: Row(
          children: <Widget>[
            Expanded(
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${_creditCardSpendData[position]['date']}'),
                    Text('${_creditCardSpendData[position]['item']}'),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.topRight,
                      child: Text(_utility.makeCurrencyDisplay(
                          _creditCardSpendData[position]['price'])),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 20,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: Text(
                '${_creditCardSpendData[position]['month_diff']}',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  Color _getLeadingBgColor({required String month}) {
    switch (int.parse(month) % 6) {
      case 0:
        return Colors.orangeAccent.withOpacity(0.3);
      case 1:
        return Colors.blueAccent.withOpacity(0.3);
      case 2:
        return Colors.redAccent.withOpacity(0.3);
      case 3:
        return Colors.purpleAccent.withOpacity(0.3);
      case 4:
        return Colors.greenAccent.withOpacity(0.3);
      case 5:
        return Colors.yellowAccent.withOpacity(0.3);
      default:
        return Colors.black;
    }
  }

  ///
  Widget _getCreditTrailing({kind}) {
    switch (kind) {
      case 'uc':
        return Icon(
          Icons.grade,
          color: Colors.purpleAccent.withOpacity(0.3),
        );
      case 'rakuten':
        return Icon(
          Icons.grade,
          color: Colors.deepOrangeAccent.withOpacity(0.3),
        );
      case 'sumitomo':
        return Icon(
          Icons.grade,
          color: Colors.greenAccent.withOpacity(0.3),
        );
      default:
        return Container();
    }
  }

  ////////////////////////////////////////////////////

  ///
  void _goAllCreditItemListScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AllCreditItemListScreen(
          date: widget.date,
        ),
      ),
    );
  }

  ///
  void _goAmazonPurchaseListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AmazonPurchaseListScreen(
          date: widget.date,
        ),
      ),
    );
  }

  ///
  void _goSeiyuuPurchaseListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeiyuuPurchaseListScreen(
          date: widget.date,
        ),
      ),
    );
  }
}
