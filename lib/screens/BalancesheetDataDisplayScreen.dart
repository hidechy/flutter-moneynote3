// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../controllers/BalanceSheetDataController.dart';

class BalancesheetDataDisplayScreen extends StatelessWidget {
  BalanceSheetDataController balanceSheetDataController = Get.put(
    BalanceSheetDataController(),
  );

  final Utility _utility = Utility();

  BalancesheetDataDisplayScreen({Key? key}) : super(key: key);

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    balanceSheetDataController.loadData(kind: 'AllBalanceSheetData');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Balance Sheet'),
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
              if (balanceSheetDataController.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _BalanceSheetList(
                  data: balanceSheetDataController.data, size: size);
            },
          ),
        ],
      ),
    );
  }

  ///
  Widget _BalanceSheetList({data, size}) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int position) => _listItem(
        position: position,
        data2: data,
        size: size,
      ),
    );
  }

  ///
  Widget _listItem(
      {required int position, required List data2, required Size size}) {
    var data = _makeListData(data: data2[position]);

    return SizedBox(
      height: size.height / 2,
      child: Card(
        color: Colors.black.withOpacity(0.3),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: DefaultTextStyle(
            style: const TextStyle(fontSize: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('${data['ym']}'),
                ),
                _getAssetsWidget(data: data),
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 10),
                  child: Text('${data['assets_total']}'),
                ),
                _getCapitalWidget(data: data),
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 10),
                  child: Text('${data['capital_total']}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Map _makeListData({data}) {
    Map _map = {};

    var exData = data.split('|');
    for (var i = 0; i < exData.length; i++) {
      var exExData = (exData[i]).split(':');
      _map[exExData[0]] = exExData[1];
    }

    return _map;
  }

  ///
  Widget _getAssetsWidget({required Map data}) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.3),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('【現金及び預金合計】'),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['assets_total_deposit_start']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['assets_total_deposit_debit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['assets_total_deposit_credit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['assets_total_deposit_end']}'),
                  ),
                ],
              ),
            ],
          ),
          const Text('【売掛債権合計】'),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['assets_total_receivable_start']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['assets_total_receivable_debit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['assets_total_receivable_credit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['assets_total_receivable_end']}'),
                  ),
                ],
              ),
            ],
          ),
          const Text('【有形固定資産合計】'),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['assets_total_fixed_start']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['assets_total_fixed_debit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['assets_total_fixed_credit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['assets_total_fixed_end']}'),
                  ),
                ],
              ),
            ],
          ),
          const Text('【事業主貸合計】'),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['assets_total_lending_start']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['assets_total_lending_debit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['assets_total_lending_credit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['assets_total_lending_end']}'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  Widget _getCapitalWidget({required Map data}) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.3),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('【流動負債合計】'),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['capital_total_liabilities_start']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['capital_total_liabilities_debit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child:
                        Text('+ ${data['capital_total_liabilities_credit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['capital_total_liabilities_end']}'),
                  ),
                ],
              ),
            ],
          ),
          const Text('【事業主借合計】'),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['capital_total_borrow_start']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['capital_total_borrow_debit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['capital_total_borrow_credit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['capital_total_borrow_end']}'),
                  ),
                ],
              ),
            ],
          ),
          const Text('【元入金】'),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['capital_total_principal_start']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['capital_total_principal_debit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['capital_total_principal_credit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['capital_total_principal_end']}'),
                  ),
                ],
              ),
            ],
          ),
          const Text('【控除前所得合計】'),
          Table(
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('${data['capital_total_income_start']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('- ${data['capital_total_income_debit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('+ ${data['capital_total_income_credit']}'),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text('= ${data['capital_total_income_end']}'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
