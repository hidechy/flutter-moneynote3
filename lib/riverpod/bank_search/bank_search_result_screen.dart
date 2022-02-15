import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bank.dart';
import 'bank_search_viewmodel.dart';

import '../../utilities/utility.dart';
import '../../utilities/CustomShapeClipper.dart';

class BankSearchResultScreen extends ConsumerWidget {
  final String ginkou;

  const BankSearchResultScreen({required this.ginkou, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Utility _utility = Utility();
    Map _bankName = _utility.getBankName();

    final bank = ref.watch(bankSearchProvider(ginkou));

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(_bankName[ginkou]),
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
        children: [
          _utility.getBackGround(),
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
          data(bank),
        ],
      ),
    );
  }

  Widget data(AsyncValue<Bank> bank) {
    Utility _utility = Utility();

    return bank.when(
      data: (data) {
        return ListView.separated(
            itemBuilder: (context, index) {
              var exDate = (data.data[index].date.toString()).split(' ');

              return Card(
                color: Colors.black.withOpacity(0.3),
                child: ListTile(
                  leading: _makeLeadingIcon(diff: data.data[index].diff),
                  title: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12),
                    child: Table(
                      children: [
                        TableRow(children: [
                          Text(exDate[0]),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              _utility
                                  .makeCurrencyDisplay(data.data[index].price),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              _utility.makeCurrencyDisplay(
                                data.data[index].diff.toString(),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemCount: data.data.length);
      },
      error: (err, stack) => Text(err.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  ///
  Widget _makeLeadingIcon({required int diff}) {
    if (diff < 0) {
      return const Icon(
        Icons.arrow_circle_down,
        color: Colors.pinkAccent,
      );
    } else {
      return const Icon(
        Icons.arrow_circle_up,
        color: Colors.greenAccent,
      );
    }
  }
}
