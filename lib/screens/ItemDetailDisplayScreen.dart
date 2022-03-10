import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:convert';

import 'package:http/http.dart';

import '../riverpod/item_detail/ItemDetail.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

class ItemDetailDisplayScreen extends StatelessWidget {
  final String date;
  final String item;
  final int sum;

  ItemDetailDisplayScreen(
      {Key? key, required this.date, required this.item, required this.sum})
      : super(key: key);

  final Utility _utility = Utility();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(item),
        backgroundColor: Colors.transparent,
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
          Column(
            children: [
              Consumer(builder: (context, ref, child) {
                ref
                    .watch(itemDetailProvider.notifier)
                    .getItemDetailData(date: date, item: item);

                final itemList = ref.watch(itemDetailProvider);

                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => _listItem(itemList[index]),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(color: Colors.white),
                    itemCount: itemList.length,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  ///
  _listItem(Detail itemList) {
    _utility.makeYMDYData(itemList.date.toString(), 0);
    var date =
        "${_utility.year}-${_utility.month}-${_utility.day}（${_utility.youbiStr}）";

    return ListTile(
      title: DefaultTextStyle(
        style: const TextStyle(fontSize: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date),
            Text(_utility.makeCurrencyDisplay(itemList.price)),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////
final itemDetailProvider =
    StateNotifierProvider.autoDispose<ItemDetailStateNotifier, List<Detail>>(
        (ref) {
  return ItemDetailStateNotifier([]);
});

//////////////////////////////////////////////////////////////////////////

class ItemDetailStateNotifier extends StateNotifier<List<Detail>> {
  ItemDetailStateNotifier(List<Detail> state) : super(state);

  ///
  void getItemDetailData({required String date, required String item}) async {
    try {
      String url = "http://toyohide.work/BrainLog/api/itemDetailDisplay";
      Map<String, String> headers = {'content-type': 'application/json'};
      String body = json.encode({"date": date, "item": item});
      Response response =
          await post(Uri.parse(url), headers: headers, body: body);
      final itemDetail = itemDetailFromJson(response.body);
      state = itemDetail.data;
    } catch (e) {
      throw e.toString();
    }
  }
}
