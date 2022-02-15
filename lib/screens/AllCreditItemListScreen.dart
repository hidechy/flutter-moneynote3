// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../controllers/CreditDataController.dart';

class AllCreditItemListScreen extends StatelessWidget {
  CreditDataController creditDataController = Get.put(
    CreditDataController(),
  );

  final Utility _utility = Utility();

  final ItemScrollController _itemScrollController = ItemScrollController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int maxNo = 0;

  String date;

  AllCreditItemListScreen({Key? key, required this.date}) : super(key: key);

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    creditDataController.loadData(kind: 'AllCardItemData');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('All Credit（種別順）'),
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
          Obx(
            () {
              if (creditDataController.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _creditCardItemList(data: creditDataController.data);
            },
          ),
        ],
      ),
    );
  }

  ///
  Widget _creditCardItemList({data}) {
    return ScrollablePositionedList.builder(
      itemBuilder: (context, index) {
        return _listItem(position: index, data: data);
      },
      itemCount: data.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
    );
  }

  ///
  Widget _listItem({required int position, required List data}) {
    var exPm = (data[position]['pay_month']).split('-');

    return Column(
      children: <Widget>[
        (data[position]['flag'] == 1)
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.3),
                ),
                width: double.infinity,
                child: Text(
                  'x',
                  style: TextStyle(
                    color: Colors.greenAccent.withOpacity(0.3),
                  ),
                ),
              )
            : Container(),
        Card(
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
            trailing: _getCreditTrailing(kind: data[position]['kind']),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(fontSize: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${data[position]['date']}'),
                        Text('${data[position]['item']}'),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.topRight,
                          child: Text(
                            _utility
                                .makeCurrencyDisplay(data[position]['price']),
                          ),
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
                    '${data[position]['month_diff']}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

      case 'amex':
        return Icon(
          Icons.grade,
          color: Colors.yellowAccent.withOpacity(0.3),
        );

      default:
        return Container();
    }
  }
}
