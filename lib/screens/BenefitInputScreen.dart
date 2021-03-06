// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';

import '../riverpod/view_model/benefit_view_model.dart';
import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

class BenefitInputScreen extends StatelessWidget {
  BenefitInputScreen({Key? key}) : super(key: key);

  final Utility _utility = Utility();

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('Benefit List'),
        backgroundColor: Colors.black.withOpacity(0.3),
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final benefitList = ref.watch(benefitSearchProvider);

                  return GroupedListView<dynamic, dynamic>(
                    elements: benefitList,
                    groupBy: (item) => item['group'],
                    groupSeparatorBuilder: (groupValue) => Container(
                      color: Colors.black,
                      padding: const EdgeInsets.all(8),
                      child: Text(groupValue),
                    ),
                    itemBuilder: (context, item) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: DefaultTextStyle(
                          style: const TextStyle(fontSize: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(item['ym']),
                                  const SizedBox(width: 30),
                                  Text(item['company']),
                                ],
                              ),
                              Text(
                                _utility.makeCurrencyDisplay(item['price']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    groupComparator: (group1, group2) =>
                        group1.compareTo(group2),
                    itemComparator: (item1, item2) =>
                        item1['ym'].compareTo(item2['ym']),
                    useStickyGroupSeparators: true,
                    floatingHeader: false,
                    order: GroupedListOrder.ASC,
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
