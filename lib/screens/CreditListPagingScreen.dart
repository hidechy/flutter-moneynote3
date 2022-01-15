// ignore_for_file: file_names, must_be_immutable, unrelated_type_equality_checks

import 'package:flutter/material.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

class CreditListPagingScreen extends StatefulWidget {
  String ym;
  String kind;
  Map<dynamic, dynamic> creditPagingData = {};
  Map<dynamic, dynamic> sums = {};

  CreditListPagingScreen(
      {Key? key,
      required this.ym,
      required this.kind,
      required this.creditPagingData,
      required this.sums})
      : super(key: key);

  @override
  _CreditListPagingScreenState createState() => _CreditListPagingScreenState();
}

class _CreditListPagingScreenState extends State<CreditListPagingScreen> {
  final Utility _utility = Utility();

  final List<Map<dynamic, dynamic>> _creditPagingList = [];

  final PageController pageController = PageController();

  // ページインデックス
  int currentPage = 0;

  /// 初期動作
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /// 初期データ作成
  void _makeDefaultDisplayData() async {
    Map _map = {};
    _map['ym'] = widget.ym;
    _map['kind'] = 'uc';
    _map['list'] = widget.creditPagingData['uc'];
    _creditPagingList.add(_map);

    Map _map2 = {};
    _map2['ym'] = widget.ym;
    _map2['kind'] = 'rakuten';
    _map2['list'] = widget.creditPagingData['rakuten'];
    _creditPagingList.add(_map2);

    Map _map3 = {};
    _map3['ym'] = widget.ym;
    _map3['kind'] = 'sumitomo';
    _map3['list'] = widget.creditPagingData['sumitomo'];
    _creditPagingList.add(_map3);

    // //
    // var pageNumber = 0;
    // switch (widget.kind) {
    //   case 'uc':
    //     pageNumber = 0;
    //     break;
    //   case 'rakuten':
    //     pageNumber = 1;
    //     break;
    //   case 'sumitomo':
    //     pageNumber = 2;
    //     break;
    // }
    //
    // if (pageController.hasClients) {
    //   pageController.jumpToPage(pageNumber);
    // }

    /////////////////////////////////
    // ページコントローラのページ遷移を監視しページ数を丸める
    pageController.addListener(() {
      int next = pageController.page!.round();
      if (pageController != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    /////////////////////////////////

    setState(() {});
  }

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: size.height * 0.7,
              width: size.width * 0.7,
              margin: const EdgeInsets.only(
                top: 5,
                left: 6,
              ),
              color: Colors.yellowAccent.withOpacity(0.2),
              child: Text(
                '■',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: pageController,
            itemCount: _creditPagingList.length,
            itemBuilder: (context, index) {
              //--------------------------------------// リセット
              bool active = (index == currentPage);
              if (active == false) {}
              //--------------------------------------//

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: dispCreditDetail(index: index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ///
  Widget dispCreditDetail({required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              color: Colors.greenAccent,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.ym),
                      Text(_creditPagingList[index]['kind']),
                    ],
                  ),
                  Text(
                    _utility.makeCurrencyDisplay(
                      widget.sums[_creditPagingList[index]['kind']].toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _dispCreditList(data: _creditPagingList[index]['list']),
            ],
          ),
        ),
      ],
    );
  }

  ///
  Widget _dispCreditList({data}) {
    if (data.length == 0) {
      return const Text(
        'No Data',
        style: TextStyle(
          fontSize: 12,
          color: Colors.yellowAccent,
        ),
      );
    }

    List<Widget> _list = [];

    for (var i = 0; i < data.length; i++) {
      _list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data[i]['item'],
              style: const TextStyle(fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _utility.makeCurrencyDisplay(data[i]['price']),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  data[i]['date'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

      _list.add(
        const Divider(color: Colors.white),
      );
    }

    return Column(
      children: _list,
    );
  }
}
