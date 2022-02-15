import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'credit.dart';
import 'credit_search_viewmodel.dart';

import '../../utilities/utility.dart';
import '../../utilities/CustomShapeClipper.dart';

class CreditSearchResultScreen extends ConsumerWidget {
  final String company;

  const CreditSearchResultScreen({required this.company, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Utility _utility = Utility();

    final credit = ref.watch(creditSearchProvider(company));

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(company),
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
          data(credit),
        ],
      ),
    );
  }

  Widget data(AsyncValue<Credit> credit) {
    Utility _utility = Utility();

    return credit.when(
      data: (data) {
        return ListView.separated(
            itemBuilder: (context, index) {
              var exDate = (data.data[index].date.toString()).split(' ');
              var exYm = (data.data[index].ym).split('-');
              return Card(
                color: Colors.black.withOpacity(0.3),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: _utility.getLeadingBgColor(month: exYm[1]),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(exYm[0]),
                        Text(exYm[1]),
                      ],
                    ),
                  ),
                  title: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exDate[0]),
                        Text(data.data[index].item),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            _utility
                                .makeCurrencyDisplay(data.data[index].price),
                          ),
                        ),
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
}
